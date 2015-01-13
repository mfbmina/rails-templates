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
  gem 'jazz_fingers'
  gem 'letter_opener'
  # Until listen has better support for recursive symlinks or until Guardfiles
  # can specify a list of watchdirs.
  # See https://github.com/guard/guard/issues/674
  # See https://github.com/guard/listen/pull/273
  # See https://github.com/guard/listen/pull/274
  gem 'listen', '~> 2.7.12'
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

# Its really useful cache gems for bundler
# this command checks if exists gem cache folder, then link it!
run '[ -d ~/.cache/gems ] && mkdir -p vendor/bundle/ && ln -ns ~/.cache/gems vendor/bundle/cache'

run "rm .gitignore"
# Gitignore
file ".gitignore", <<-END
### Rails ###
*.rbc
capybara-*.html
.rspec
/log
/tmp
/db/*.sqlite3
/db/*.sqlite3-journal
/public/system
/coverage/
/spec/tmp
**.orig
rerun.txt
pickle-email-*.html

# TODO Comment out these rules if you are OK with secrets being uploaded to the repo
config/initializers/secret_token.rb
config/secrets.yml

## Environment normalisation:
/.bundle
/vendor/bundle

# these should all be checked in to normalise the environment:
# Gemfile.lock, .ruby-version, .ruby-gemset

# unless supporting rvm < 1.11.0 or doing something fancy, ignore this:
.rvmrc

# if using bower-rails ignore default bower_components path bower.json files
/vendor/assets/bower_components
*.bowerrc
bower.json


### Ruby ###
*.gem
*.rbc
/.config
/coverage/
/InstalledFiles
/pkg/
/spec/reports/
/test/tmp/
/test/version_tmp/
/tmp/

## Specific to RubyMotion:
.dat*
.repl_history
build/

## Documentation cache and generated files:
/.yardoc/
/_yardoc/
/doc/
/rdoc/

## Environment normalisation:
/.bundle/
/lib/bundler/man/

# for a library or gem, you might want to ignore these files since the code is
# intended to run in multiple environments; otherwise, check them in:
# Gemfile.lock
# .ruby-version
# .ruby-gemset

# unless supporting rvm < 1.11.0 or doing something fancy, ignore this:
.rvmrc
END

after_bundle do
  # Initialize Guard
  run "bundle exec guard init"

  # Run Generators
  generate "simple_form:install --bootstrap"
  generate "responders:install"
  generate "rspec:install"

  git :init
  git add: '.'
  git commit: "-a -m 'Rails'"
end