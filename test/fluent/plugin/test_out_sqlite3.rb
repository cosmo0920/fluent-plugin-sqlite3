require 'fluent/test'
require 'fluent/plugin/out_sqlite3'

$log = Object.new.instance_eval {|obj| def method_missing(method, *args); end; self }

class Fluent::Sqlite3OutputTest < Test::Unit::TestCase
  def setup
    Fluent::Test.setup
  end
  
  CONFIG = %[
    path a.db
  ]

  def create_driver(conf=CONFIG, tag='test')
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::Sqlite3Output, tag) {
      def start
      end
    }.configure(conf)
  end

  def test_format
  end

  def test_write
    d = create_driver
    collection_name, documents = d.run
    assert_equal [{}, {}], documents
    assert_equal 'test', collection_name
  end
end
