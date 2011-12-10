require 'yaml'

credentials = YAML::load(File.open("#{Rails.root}/config/credentials.yml"))
AMAZON_KEY = credentials['key']
AMAZON_SECRET = credentials['secret']
ASSOCIATE_TAG = credentials['associate_tag']
