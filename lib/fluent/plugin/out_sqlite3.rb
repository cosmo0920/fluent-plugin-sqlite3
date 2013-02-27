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
  end
  
  def shutdown
    super
    $log.debug "shutdown"
  end

  def format(tag, time, record)
    #$log.debug "tag: ", tag
    #$log.debug "time: ", time
    #$log.debug "record: ", record
    [tag, time, record].to_json + "\n"
  end

  def client
    $log.debug "client"
  end

  def write(chunk)
    data = chunk.read
    #$log.debug "chunk: ", chunk
    $log.debug "data: ", data
    stmt = @db.prepare "INSERT INTO aaa(id) VALUES(:id)"
    #stmt.bind_params :id, data.length
    r = stmt.execute id: data.length
    $log.debug r
  end
end
