class Fluent::Sqlite3Output < Fluent::BufferedOutput
  Fluent::Plugin.register_output('sqlite3', self)

  config_param :path, :string

  def initialize
    $log.debug "initialized"
  end

  def configure(conf)
    super
  end
  
  def start
    super
  end
  
  def shutdown
    super
  end

  def format(tag, time, record)
  end

  def client
  end

  def write(chunk)
  end
end
