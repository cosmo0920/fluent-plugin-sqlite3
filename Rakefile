namespace :gem do
  desc "build"
  task :build do
    `gem build fluent-plugin-sqlite3.gemspec`
  end

  desc "install"
  task :install => ["gem:build"] do
    `gem install fluent-plugin-sqlite3-0.0.0.gem`
  end

  desc "publish"
  task :publish do
    `gem push fluent-plugin-sqlite3-0.0.0.gem`
  end
end
