#!/bin/bash

# Template Jenkins Wrapper for Language: 'Ruby'

# Setup our ruby and gemset
source /usr/local/rvm/scripts/rvm
type rvm | head -1

# Use our gemset (create it if it doesn't already exist)
ruby_version=`cat .ruby-version | tr -d '\n'`
ruby_gemset=`cat .ruby-gemset | tr -d '\n'`

rvm use "${ruby_version}@${ruby_gemset}" --create

# Make sure bundler is installed for this ruby version/gemset
gem list bundler -i >/dev/null 2>&1
if [ $? -eq 1 ]; then
  echo "Installing bundler"
  gem install bundler
fi

export DB_DATABASE=''

# you can delete this block once you've set DB_DATABASE and dealt with
# database-local.yml support.
if [ -z "${DB_DATABASE}" ]; then
  echo "you need to do a little db setup..."
  echo
  echo "#1: edit jenkins.sh, set a value for DB_DATABASE, and commit/push the result"
  echo "#2: update your application.rb to support config/database-local.yml"
  echo "    example:"
  echo
  echo "      module YourApp"
  echo "        class Application < Rails::Application"
  echo "          # load database-local.yml instead of database.yml if it exists"
  echo "          local_db_file = 'config/database-local.yml'"
  echo "          paths['config/database'] = [local_db_file] if File.exist?(local_db_file)"
  echo "        end"
  echo "      end"
  echo
  echo "    you don't absolutely have to do this"
  echo "    but the default script/jenkins.sh expects it."
  exit 1
fi

# Exit immediately if any single command fails
set -e

cp $DATABASE_YAML $WORKSPACE/config/database-local.yml

# Setup the database config using the password provided by Jenkins
if [ -z "${DB_PASSWORD}" ]; then
  echo "DB_PASSWORD is not set, check credential-store plugin and job config"
  exit 1
fi

if [ -z "${DATABASE_YAML}" ]; then
  echo "DATABASE_YAML is not set, check jenkins job config"
  exit 1
fi

# use jenkins-specific secrets file if it exists
if [ -e $WORKSPACE/config/secrets.jenkins.yml ]; then
  cp $WORKSPACE/config/secrets.jenkins.yml $WORKSPACE/config/secrets.yml
fi

# Ensure we have ruby
ruby --version
echo "Ruby Gemset:"
rvm current
echo ""

# Print all commands after expansion.  Note that you can put this earlier
# in the script, but rvm prints out a wall-o-text.
set -x

# Good to know the path
echo "PATH is ${PATH}"

# any non-normal exit status from now on should fail the build
set -e

# Update all our gems
bundle install --without development

# Setup the database
bundle exec rake db:schema:load

# Security check
ignores=""
bundle exec bundle-audit update
bundle exec bundle-audit check --ignore=${ignores}

export COVERAGE=on
bundle exec rake spec

# check for style violations
# never fail the build at this step. let a jenkins post-build action do this
# if necessary
#
# output:
#   print clang format to stdout, which ends up in jenkins console
#   create html version in build/ for viewing from jenkins web UI.
#   print checkstyle.xml for consumption by jenkins checkstyle plugin
bundle exec rubocop \
  --require rubocop/formatter/checkstyle_formatter \
  --display-cop-names \
  --format clang \
  --format html \
  --out build/rubocop.html \
  --format RuboCop::Formatter::CheckstyleFormatter \
  --out tmp/checkstyle.xml || true

# Security scan
# See http://brakemanscanner.org/docs/ignoring_false_positives/ to ignore anything reported here.
bundle exec brakeman -z --format html --output build/brakeman.html

exit 0
