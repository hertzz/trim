require 'rubygems'
require 'bundler/setup'
require 'rake'
require 'sequel'
require 'yaml'
require 'erb'
require 'mysql2'
require 'rake/testtask'

ruby_env = ENV['RUBY_ENV'] ||= 'development'
database_config = YAML.load(ERB.new(File.read('config/database.yml')).result)[ruby_env]

namespace :db do
  desc "Run database migrations"

  task :migrate, [:version] do |t, args|
    puts "Running Sequel migrations..."
    Sequel.extension :migration
    db = Sequel.connect(database_config)

    if args[:version]
      puts "Migrating to version #{args[:version]}..."
      Sequel::Migrator.run(db, "db/migrations", target: args[:version].to_i)
    else
      puts "Migrating to latest..."
      Sequel::Migrator.run(db, "db/migrations")
    end
  end

  desc "Create database"
  task :create do
    puts "Creating dattabase..."

    client = Mysql2::Client.new(
      host: database_config['host'],
      username: database_config['username'],
      password: database_config['password']
    )
    client.query("CREATE DATABASE #{database_config['database']}")
    client.close
  end

  desc "Drop database"
  task :drop do
    puts "Dropping database..."

    client = Mysql2::Client.new(
      host: database_config['host'],
      username: database_config['username'],
      password: database_config['password']
    )
    client.query("DROP DATABASE #{database_config['database']}")
    client.close
  end
end

namespace :test do
  desc "Run rspec tests"
  task :spec do
    puts "Running RSpec tests..."

    begin
      require 'rspec/core/rake_task'
      RSpec::Core::RakeTask.new(:spec) do |t|
        t.rspec_opts = "--require spec_helper"
      end
    rescue
      # No rspec available
      puts "rspec is not available, skipping"
    end
  end
end
