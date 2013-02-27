require "rubygems"
require "bundler"

Bundler.setup(:default, :development)

class Fluent::Sqlite3OutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
    #require 'fluent/plugin/out_sqlite3'
  end
  
  CONFIG = %[
    path a.db
  ]

  def create_deiver(conf=CONFIG, tag='test')
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::Sqlite3Output, tag) {
      def start
      end
    }.configure(conf)
  end

  def test_format
  end

  def test_write
    d = create_driver
    t = emit_documents(d)
    collection_name, documents = d.run
    assert_equal [{}, {}], documents
    assert_equal 'test', collection_name
  end
end
