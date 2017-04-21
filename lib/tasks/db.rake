require 'yaml'
namespace :db do
  require "sequel"
  Sequel.extension :migration
  # ENV['RACK_ENV'] ||= 'development'
  migr_dir = File.join(File.dirname(__FILE__), '..', '..', 'db', 'migrations')
  db_config = YAML.load(File.read(File.join(File.dirname(__FILE__), '..', '..', 'db','database.yml')))[ENV['RACK_ENV']]

  # DB = Sequel.connect(db_config)

  desc "Prints current schema version"
  task :version => [:environment] do
    version = if DB.tables.include?(:schema_info)
      DB[:schema_info].first[:version]
    end || 0

    puts "Schema Version: #{version}"
  end

  desc "Perform migration up to latest migration available"
  task :migrate => [:environment] do
    begin

      Sequel::Migrator.run(DB, migr_dir)
      Rake::Task['db:version'].execute
    rescue Sequel::DatabaseConnectionError => e
      puts e
      # sh("sudo -su #{db_config['username']} -S createdb -p #{db_config['port']} -h #{db_config['host']} -O #{db_config['username']} #{db_config['database']}" )
    end
  end

  desc "Perform rollback to specified target or full rollback as default"
  task :rollback => [:environment, :version] do |t, args|
    Sequel::Migrator.run(DB, migr_dir, :target => args[:version].to_i) # this shit isnt working(
    Rake::Task['db:version'].execute
  end

  desc "Perform migration reset (full rollback and migration)"
  task :reset => [:environment] do
    Sequel::Migrator.run(DB, migr_dir, :target => 0)
    Sequel::Migrator.run(DB, migr_dir)
    Rake::Task['db:version'].execute
  end

end
