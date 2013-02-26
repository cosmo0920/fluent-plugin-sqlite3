Gem::Specification.new do |s|
  s.name        = 'fluent-plugin-sqlite3'
  s.version     = '0.0.0'
  s.date        = '2013-02-26'
  s.summary     = "fluentd output to sqlite3"
  s.description = "fluentd output to sqlite3"
  s.authors     = ["Tomotaka Sakuma"]
  s.email       = 'ktmtmks@gmail.com'
  s.files       = ["lib/fluent/plugin/out_sqlite3.rb"]
  s.homepage    = 'https://github.com/tmtk75/fluent-plugin-sqlite3.git'

  gem.add_development_dependency "fluentd"
  gem.add_development_dependency "sqlite3"
  gem.add_runtime_dependency "fluentd"
  gem.add_runtime_dependency "sqlite3"
end
