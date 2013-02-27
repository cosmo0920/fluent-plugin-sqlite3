require "sqlite3"

class Fluent::Sqlite3Output < Fluent::BufferedOutput
  Fluent::Plugin.register_output('sqlite3', self)

  config_param :path,    :string
  config_param :table,   :string, :default => nil
  config_param :columns, :string, :default => nil

  def initialize
    super
  end

  def configure(conf)
    super
    @type = conf["type"]
  end
  
  def start
    super
    @db = ::SQLite3::Database.new @path
    @stmts = {}
    if @table and @columns
      @stmts[@table] = @db.prepare to_insert(@table, @columns)
    end
  end

  def to_insert(table, columns)
    cols = columns.split(/ *, */).map {|e| ":#{e}"}.join(",")
    "INSERT INTO #{table}(#{columns}) VALUES(#{cols})"
  end

  def shutdown
    super
    $log.debug "shutdown"
    @stmt.close
    @db.close
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def write(chunk)
    chunk.msgpack_each do |tag, time, record|
      table = (@table or tag.slice(@type.length + 1, tag.length))
      unless @stmts[table]
        cols = record.keys.join ","
        @db.execute "CREATE TABLE IF NOT EXISTS #{table} (#{cols})"
        @stmts[table] = @db.prepare (a = to_insert(table, cols))
        $log.debug "create a new table, #{table.upcase}"
      end
      @stmts[table].execute record
    end
  end
end
