require "sqlite3"

class Fluent::Sqlite3Output < Fluent::BufferedOutput
  Fluent::Plugin.register_output('sqlite3', self)

  config_param :path,    :string
  config_param :table,   :string
  config_param :columns, :string

  def initialize
    super
  end

  def configure(conf)
    super
    @path     = conf['path']
    @table    = conf['table']
    @columns  = conf['columns']
  end
  
  def start
    super
    @db = ::SQLite3::Database.new @path
    cols = _columns.map {|e| ":#{e}"}.join(",")
    @stmt = @db.prepare "INSERT INTO #{@table}(#{@columns}) VALUES(#{cols})"
  end

  def _columns
    @columns.split(/ ?, ?/)
  end
  private :_columns
  
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
      #$log.debug "tag: ", tag, ", time: ", time, ", record: ", record
      @stmt.execute record
      $log.debug record
    end
  end
end
