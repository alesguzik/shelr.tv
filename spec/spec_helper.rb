ENV["RAILS_ENV"] ||= 'test'
require 'rubygems'
require File.expand_path("../../config/environment", __FILE__)
require 'spork'
require 'capybara/rails'
require 'capybara/rspec'
require 'turnip'
require 'turnip/capybara'
require 'database_cleaner'
require 'rspec/rails'

Spork.prefork do
  # The Spork.prefork block is run only once when the spork server is started.
  # You typically want to place most of your (slow) initializer code in here, in
  # particular, require'ing any 3rd-party gems that you don't normally modify
  # during development.
  #
  # Loading more in this block will cause your tests to run faster. However,
  # if you change any configuration or code from libraries loaded here, you'll
  # need to restart spork for it take effect.

  Capybara.default_driver = :selenium

  RSpec.configure do |config|
    config.include FactoryGirl::Syntax::Methods
    config.include Mongoid::Matchers
    config.before(:each) { Mongoid::IdentityMap.clear }

    # == Mock Framework
    #
    # If you prefer to use mocha, flexmock or RR, uncomment the
    # appropriate line:
    #
    # config.mock_with :mocha
    # config.mock_with :flexmock
    # config.mock_with :rr
    config.mock_with :rspec


    # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
    # config.fixture_path = "#{::Rails.root}/spec/fixtures"

    # If you're not using ActiveRecord, or you'd prefer not to run each of your
    # examples within a transaction, remove the following line or assign false
    # instead of true.
    # config.use_transactional_fixtures = true

    config.include SunspotMatchers
    config.before do
      Sunspot.session = SunspotMatchers::SunspotSessionSpy.new(Sunspot.session)

    end

    config.after :each do
      DatabaseCleaner.clean
    end

    #
    # Turnip
    #
    Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }

    #
    # Datablase cleaner
    #
    # config.after :each do
    #   DatabaseCleaner.clean
    # end
  end
end

Spork.each_run do
  # This code will be run each time you run your specs.
  # The Spork.each_run block is run each time you run your specs.  In case you
  # need to load files that tend to change during development, require them here.
  # With Rails, your application modules are loaded automatically, so sometimes
  # this block can remain empty.

  # Requires supporting ruby files with custom matchers and macros, etc,
  # in spec/support/ and its subdirectories.
  Dir[Rails.root.join("spec/support/**/*.rb")].each {|f| require f}
  Dir.glob("spec/steps/**/*steps.rb") { |f| load f, true }
end
