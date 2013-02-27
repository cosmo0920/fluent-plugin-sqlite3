require "sqlite3"

class Fluent::Sqlite3Output < Fluent::BufferedOutput
  Fluent::Plugin.register_output('sqlite3', self)

  config_param :path, :string

  def initialize
    super
  end

  def configure(conf)
    super
    @path = conf['path']
  end
  
  def start
    super
    $log.debug "path: ", @path
    @db = ::SQLite3::Database.new @path
    @stmt = @db.prepare "INSERT INTO aaa(id) VALUES(:id)"
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
      #$log.debug "tag: ", tag, ", time: ", time, ", record: ", record
      #@stmt.bind_params :id, data.length
      r = @stmt.execute id: tag.length
      #$log.debug r
    end
  end
end
