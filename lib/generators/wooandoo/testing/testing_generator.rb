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

				update_test_environment
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
				gem "launchy", :group => :test

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
				
				gsub_file "Guardfile", /guard 'spork'(.*?) do/, "guard 'spork'\1, :rspec => true, :cucumber => false, :test_unit => false, :bundler => false, :wait => 15 do"
				gsub_file "Guardfile", /guard 'migrate'(.*?) do/, "guard 'migrate'\1, :run_on_start => true, :test_clone => false, :reset => true, :rails_env => 'test' do"
				gsub_file "Guardfile", /guard 'rspec'(.*?) do/, "guard 'rspec'\1, :cli => \"--drb -f d\", :all_on_start => false, :all_after_pass => false do"
			end
			
			# ----------------------------------------------------------------
			
			def init_pry
				# see https://gist.github.com/1190475
				# add 
				# silence_warnings do
				#		begin
				#			require 'pry'
				#			IRB = Pry
				#		rescue LoadError
				#		end
				# end
			end

			# ----------------------------------------------------------------
			
			def update_test_environment
				gsub_file File.join("config", "environments", "test.rb"), /config.cache_classes = true/, "config.cache_classes = false"
			end
		end
	end
end