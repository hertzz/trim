require 'rubygems'
require 'bundler/setup'
require 'sequel'
require 'yaml'
require 'erb'
require 'mysql2'

ruby_env = ENV['RUBY_ENV'] ||= 'development'
database_config = YAML.load(ERB.new(File.read('config/database.yml')).result)[ruby_env]

namespace :db do
  desc "Run MySQL migrations"
  task :migrate, [:version] do |t, args|
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

  desc "Create MySQL database"
  task :create do
    client = Mysql2::Client.new(
      host: database_config['host'],
      username: database_config['username'],
      password: database_config['password']
    )
    client.query("CREATE DATABASE #{database_config['database']}")
    client.close
  end

  desc "Drop MySQL database"
  task :drop do
    client = Mysql2::Client.new(
      host: database_config['host'],
      username: database_config['username'],
      password: database_config['password']
    )
    client.query("DROP DATABASE #{database_config['database']}")
    client.close
  end
end
