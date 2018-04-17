Gem::Specification.new do |s|
  s.name        = 'fluent-plugin-sqlite3'
  s.version     = '1.0.0'
  s.date        = '2016-09-22'
  s.summary     = "fluentd output to sqlite3"
  s.description = "fluentd output to sqlite3"
  s.authors     = ["Tomotaka Sakuma"]
  s.email       = 'ktmtmks@gmail.com'
  s.files       = ["lib/fluent/plugin/out_sqlite3.rb"]
  s.homepage    = 'https://github.com/tmtk75/fluent-plugin-sqlite3.git'

  s.add_dependency "fluentd", [">= 0.14.15", "< 2"]
  s.add_dependency "sqlite3", ">= 1.3.7"
  s.add_development_dependency "test-unit", "~> 3.2.0"
  s.add_development_dependency "rake", "~> 12.0.0"
  s.add_development_dependency "bundler", "~> 1.13"
end
