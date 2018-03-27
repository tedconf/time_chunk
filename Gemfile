source 'https://rubygems.org'
# Add dependencies required to use your gem here.
# Example:
#   gem 'activesupport', '>= 2.3.5'

# Add dependencies to develop your gem here.
# Include everything needed to run rake, tests, features, etc.
group :development do
  gem 'bundler', '>= 1.2.0'
  gem 'rdoc', '~> 3.12'
end

group :development, :test do
  gem 'brakeman', require: false
  gem 'bundler-audit'
  gem 'ci_reporter_rspec', require: false
  gem 'rake', '~> 11.0' # due to last_comment deprecation regarding rspec
  gem 'rspec', '~> 2.0'
  gem 'rubocop', require: false
  gem 'rubocop-checkstyle_formatter'
end
