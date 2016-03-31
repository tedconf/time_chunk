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
