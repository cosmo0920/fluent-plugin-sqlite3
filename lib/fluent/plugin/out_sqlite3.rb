require "sqlite3"
require "fluent/plugin/output"

class Fluent::Plugin::Sqlite3Output < Fluent::Plugin::Output
  Fluent::Plugin.register_output('sqlite3', self)

  DEFAULT_BUFFER_TYPE = "memory"

  helpers :compat_parameters

  config_param :path,     :string
  config_param :table,    :string, :default => nil
  config_param :columns,  :string, :default => nil
  config_param :includes, :string, :default => nil
  config_param :excludes, :string, :default => nil

  config_section :buffer do
    config_set_default :@type, DEFAULT_BUFFER_TYPE
  end

  def initialize
    super
  end

  def configure(conf)
    compat_parameters_convert(conf, :buffer)
    super
    @type = conf["type"]
    if (@table and not(@columns)) or (not(@table) and @columns)
      raise "strict mode requires table and columns parameters"
    end
  end

  DELIMITER = / *, */

  def start
    super
    @db = ::SQLite3::Database.new @path
    @stmts = {}
    if @table
      cols = @columns.split(DELIMITER).map {|e| ":#{e}"}.join(",")
      @stmts[@table] = @db.prepare "INSERT INTO #{@table}(#{@columns}) VALUES(#{cols})"
    end
  end

  def to_insert(table, columns)
    cols = columns.split(DELIMITER).map {|e| ":#{e}"}.join(",")
    "INSERT INTO #{table}(#{columns}) VALUES(#{cols})"
  end

  def shutdown
    log.debug "shutdown"
    @stmts.each {|k,v| v.close}
    @db.close
    super
  end

  def format(tag, time, record)
    [tag, time, record].to_msgpack
  end

  def write(chunk)
    @db.transaction
    begin
      write1(chunk)
      @db.commit
    rescue => ex
      @db.rollback
      log.error "rollback: ", ex
      raise
    end
  end

  def formatted_to_msgpack_binary?
    true
  end

  def write1(chunk)
    chunk.msgpack_each do |tag, time, record|
      if record.keys.length == 0
        log.warn "no any keys for #{tag}"
        return
      end
      table = (@table or tag.split('.')[1]) # param 'table' or 2nd later part of tag.
      if @includes
        (record.keys - @includes.split(DELIMITER)).each {|e| record.delete e}
      end
      if @excludes
        @excludes.split(DELIMITER).each {|e| record.delete e}
      end
      unless @stmts[table]
        cols = record.keys.join ","
        @db.execute "CREATE TABLE IF NOT EXISTS #{table} (id INTEGER PRIMARY KEY AUTOINCREMENT,#{cols})"
        @stmts[table] = @db.prepare (a = to_insert(table, cols))
        log.debug "create a new table, #{table.upcase} (it may have been already created)"
      end
      @stmts[table].execute record
    end
  end
end
