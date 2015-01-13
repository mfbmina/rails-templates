gem 'country_select'
gem 'devise'
gem 'haml-rails'
gem 'json'
gem 'responders'
gem 'sidekiq'
gem 'simple_form'

gem_group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'guard', require: false
  gem 'guard-rails', require: false
  gem 'guard-bundler', require: false
  gem 'guard-livereload', require: false
  gem 'guard-rspec', require: false
  gem 'jazz_hands', github: 'nixme/jazz_hands', branch: 'bring-your-own-debugger'
  gem 'letter_opener'
  gem 'pry-byebug'
  gem 'quiet_assets'
  gem 'spring-commands-rspec'
  gem 'thin'
end
 
gem_group :development, :test do
  gem 'rspec-rails'
  gem 'shoulda-matchers', require: false
end
 
gem_group :test do
  gem 'capybara'
  gem 'email_spec'
  gem 'turnip'
end

# Run Generators
generate "responders:install"
generate "simple_form:install --bootstrap"
generate "rspec:install"

# Initialize Guard
run "guard init"

# Configure letter_opener to intercept mail send on development
environment 'config.action_mailer.delivery_method = :letter_opener', env: 'development'

# now you can rake db:seed:seed_file_name
# custom seeds lives on db/seeds/
rakefile("custom_seed.rake") do
  <<-TASK
    namespace :db do
      namespace :seed do
        Dir[File.join(Rails.root, 'db', 'seeds', '*.rb')].each do |filename|
          task_name = File.basename(filename, '.rb').intern    
          task task_name => :environment do
            load(filename) if File.exist?(filename)
          end
        end
      end
    end
  TASK
end