DB = Sequel.connect(YAML.load(File.read(File.join(File.dirname(__FILE__), '..', 'db','database.yml')))[ENV['RACK_ENV']])

DB.extension :pagination
