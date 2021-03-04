# -*- encoding: utf-8 -*-

require File.expand_path('../lib/time_chunk/version', __FILE__)

Gem::Specification.new do |s| # rubocop:disable Metrics/BlockLength
  s.name = 'time_chunk'
  s.version = TimeChunk::VERSION

  if s.respond_to? :required_rubygems_version=
    s.required_rubygems_version = Gem::Requirement.new('>= 0')
  end
  s.authors = ['Alex Dean']
  s.date = '2013-05-17'
  s.description = 'Iterate over time ranges in discrete chunks.'
  s.email = 'alex@crackpot.org'
  s.extra_rdoc_files = %w[LICENSE.txt README.md]
  s.files = %w[
    .document
    .rspec
    Gemfile
    LICENSE.txt
    README.md
    Rakefile
    lib/time_chunk.rb
    lib/time_chunk/version.rb
    spec/spec_helper.rb
    spec/time_chunk_spec.rb
    time_chunk.gemspec
  ]
  s.homepage = 'http://github.com/tedconf/time_chunk'
  s.licenses = ['MIT']
  s.require_paths = ['lib']
  s.rubygems_version = '1.8.24'
  s.summary = 'Iterate over time ranges in discrete chunks.'

  # https://guides.rubygems.org/specification-reference/
  s.add_development_dependency 'rake'
  s.add_development_dependency 'rspec'
  s.add_development_dependency 'rdoc'
  s.add_development_dependency 'bundler', '> 2.0'
  s.add_development_dependency 'brakeman'
  s.add_development_dependency 'bundler-audit'
  s.add_development_dependency 'ci_reporter_rspec'
  s.add_development_dependency 'rubocop'
  s.add_development_dependency 'rubocop-checkstyle_formatter'
end
