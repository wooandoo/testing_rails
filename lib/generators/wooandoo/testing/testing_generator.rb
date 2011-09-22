puts "lib/generators/testing_generator.rb"

require "rails/generators/base"

module Wooandoo
  module Generators
    class TestingGenerator < Rails::Generators::Base
      source_root File.expand_path("../templates", __FILE__)
      
      def configure_rails_application_for_testing
        add_gems
        init_pry
        init_rspec
        init_spork
        init_guard
      end

      # ----------------------------------------------------------------
      protected
      # ----------------------------------------------------------------

      def add_gems
        append_to_file "Gemfile", "\n\n# GEM FOR TESTING\n\n"
        
        gem 'spork', '~> 0.9.0.rc9', :group => :test
        gem 'rb-fsevent', :group => :test
        gem 'growl', :group => :test
        gem 'guard-spork', :group => :test
        
        gem 'guard-bundler', :group => :test
        gem 'guard-migrate', :group => :test
        
        gem "rspec-rails", :group => [:test, :development]
        gem "guard-rspec", :group => :test

        gem "capybara", :group => :test
        gem "capybara-webkit", :group => :test

        gem "factory_girl_rails", :group => :test

        gem 'database_cleaner', :group => :test

        gem 'timecop', :group => :test

        gem 'pry', :group => [:test, :development]
      end

      # ----------------------------------------------------------------

      def init_rspec
        generate "rspec:install"

        %w{spec/support spec/models spec/routing spec/macro spec/factories spec/requests spec/mailers spec/controllers spec/helpers}.each do |path|
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
        run "guard init bundler"
        run "guard init migrate"
        run "guard init rspec"
        
        gsub_file "Guardfile", /guard 'spork'(.*?) do/, "guard 'spork'\1, :wait => 10 do"
        gsub_file "Guardfile", /guard 'rspec'(.*?) do/, "guard 'rspec'\1, :cli => \"--drb -f d\" do"
      end
      
      # ----------------------------------------------------------------
      
      def init_pry
        # see https://gist.github.com/1190475
        # add 
        # silence_warnings do
        #   begin
        #     require 'pry'
        #     IRB = Pry
        #   rescue LoadError
        #   end
        # end
      end
    end
  end
end