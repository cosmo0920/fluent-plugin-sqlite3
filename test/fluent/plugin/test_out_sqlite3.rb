require 'fluent/test'
require 'fluent/test/driver/output'
require 'fluent/test/helpers'
require 'fluent/plugin/out_sqlite3'
require 'fileutils'

class Fluent::Sqlite3OutputTest < Test::Unit::TestCase
  include Fluent::Test::Helpers

  def setup
    Fluent::Test.setup
    @db = ::SQLite3::Database.new DBPATH
  end

  def teardown
    @db.close
    FileUtils.rm(DBPATH)
  end

  DBPATH = "a.db"
  CONFIG = %[
    path #{DBPATH}
  ]

  TAG = 'test.records'

  def create_driver(conf=CONFIG)
    Fluent::Test::Driver::Output.new(Fluent::Plugin::Sqlite3Output) {
      def start
        super
      end
    }.configure(conf)
  end

  def get_documents(driver, table = TAG.split('.')[1])
    rows = []
    @db.execute( "select * from #{table}" ) do |row|
      rows << row
    end
    rows
  end

  def test_format
    d = create_driver
    time = event_time
    d.run(default_tag: TAG, shutdown: false) do
      d.feed(time, {'record' => 'message', 'value' => 0.12})
    end
    assert_equal [TAG, time, {'record' => 'message', 'value' => 0.12}].to_msgpack, d.formatted[0]
  end

  def test_write
    d = create_driver
    d.run(default_tag: TAG, shutdown: false) do
      d.feed({'record' => 'message', 'value' => 0.12})
    end
    doc = get_documents(d)
    assert_equal [[1, 'message', 0.12]], doc
  end
end
