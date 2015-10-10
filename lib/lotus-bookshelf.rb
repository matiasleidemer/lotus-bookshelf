require 'lotus/model'
require 'lotus/mailer'
Dir["#{ __dir__ }/lotus-bookshelf/**/*.rb"].each { |file| require_relative file }

Lotus::Model.configure do
  ##
  # Database adapter
  #
  # Available options:
  #
  #  * Memory adapter
  #    adapter type: :memory, uri: 'memory://localhost/lotus-bookshelf_development'
  #
  #  * SQL adapter
  #    adapter type: :sql, uri: 'sqlite://db/lotus-bookshelf_development.sqlite3'
  #    adapter type: :sql, uri: 'postgres://localhost/lotus-bookshelf_development'
  #    adapter type: :sql, uri: 'mysql://localhost/lotus-bookshelf_development'
  #
  adapter type: :sql, uri: ENV['LOTUS_BOOKSHELF_DATABASE_URL']
  # place your tests here

  ##
  # Migrations
  #
  migrations 'db/migrations'
  schema     'db/schema.sql'

  ##
  # Database mapping
  #
  # Intended for specifying application wide mappings.
  #
  # You can specify mapping file to load with:
  #
  # mapping "#{__dir__}/config/mapping"
  #
  # Alternatively, you can use a block syntax like the following:
  #
  mapping do
     collection :books do
       entity     Book
       repository BookRepository

       attribute :id,     Integer
       attribute :title,  String
       attribute :author, String
     end
  end
end.load!

Lotus::Mailer.configure do
  root "#{ __dir__ }/lotus-bookshelf/mailers"

  # See http://lotusrb.org/guides/mailers/delivery
  delivery do
    development :test
    test        :test
    # production :stmp, address: ENV['SMTP_PORT'], port: 1025
  end
end.load!
