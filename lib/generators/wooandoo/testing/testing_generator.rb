puts "lib/generators/testing_generator.rb"

require "rails/generators/base"

module Wooandoo
  module Generators
    class TestingGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      
      def configure_rails_application_for_testing
        add_gems
        init_rspec
        init_spork
        init_guard
      end

      # ----------------------------------------------------------------
      protected
      # ----------------------------------------------------------------

      def add_gems
        append_to_file "Gemfile", "\n\n# GEM FOR TESTING\n"
        
        gem "rspec-rails", :group => [:test, :development]

        gem "capybara", :group => :test

        gem "factory_girl_rails", :group => :test

        gem 'database_cleaner', :group => :test

        gem 'timecop', :group => :test

        gem "guard-rspec", :group => :test
        gem 'guard-spork', :group => :test
        gem 'spork', '~> 0.9.0.rc9', :group => :test
      end

      # ----------------------------------------------------------------

      def init_rspec
        generate "rspec:install"

        %w{spec/support spec/models spec/routing spec/macro spec/factories}.each do |path|
          empty_directory path
        end

      end

      # ----------------------------------------------------------------

      def init_spork
        run "spork --bootstrap"
        template "spec_helper.rb", "spec/spec_helper.rb", :force => true
      end

      # ----------------------------------------------------------------

      def init_guard
        run "guard init spork"
        run "guard init rspec"

        gsub_file "Guardfile", /guard 'rspec'.*? do/, "guard 'rspec', :version => 2, :cli => \"--drb -f d\" do"
      end
    end
  end
end