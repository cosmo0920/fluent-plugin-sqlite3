README fluent-plugin-sqlite3
============================

Fluent::Sqlite3Output
---------------------
<img src='https://raw.github.com/fluent/website/master/logos/fluentd2.png' width='176px'/>

Required gems

- sqlite3


Configuration
-------------

    <match sqlite3.**>
      type sqlite3
      path test.db

      ## strict mode
      ## -----------
      ## Expects the table already exists and it has the columns.
      #table   persons
      #columns name, age, country

      ## ad hoc mode
      ## -----------
      ## this mode is enabled in case table and columns
      ## parameters are empty.
      ##
      ## echo '{"name":"Jhon","age":24}' | sqlite3.persons
      ##
      ## This creates a new table PERSONS which
      ## has "name" and "age" columns.
      ## The primary key is "id" which is AUTOINCREMENT.

      ## excludes keys of json when inserting a new record
      #excludes hair, eye

      ## fluentd built-in options
      buffer_type    memory
      flush_interval 1s
      retry_limit    1
      retry_wait     1s
      num_threads    1
    </match>
