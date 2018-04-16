require 'fluent/test'
require 'fluent/plugin/out_sqlite3'
require 'fileutils'

$log = Object.new.instance_eval {|obj| def method_missing(method, *args); end; self }

class Fluent::Sqlite3OutputTest < Test::Unit::TestCase
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

  def create_driver(conf=CONFIG, tag=TAG)
    Fluent::Test::BufferedOutputTestDriver.new(Fluent::Sqlite3Output, tag) {
      def start
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
    time = Time.now.to_i
    d.emit({'record' => 'message', 'value' => 0.12}, time)
    d.expect_format [TAG, time, {'record' => 'message', 'value' => 0.12}].to_msgpack
    d.run
  end

  def test_write
    d = create_driver
    d.emit({'record' => 'message', 'value' => 0.12})
    d.run
    doc = get_documents(d)
    assert_equal [[1, 'message', 0.12]], doc
  end
end
