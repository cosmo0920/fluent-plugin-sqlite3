README fluent-plugin-sqlite3
============================

Fluent::Sqlite3Output
---------------------
<img src='https://raw.github.com/fluent/website/master/logos/fluentd2.png' width='176px'/>

### Required gems
- sqlite3


Getting started
---------------
Add a following directive to fluent.conf and launch fluentd.

    <match sqlite3.**>
      type sqlite3
      path test.db
    </match>

Then run next.

    echo '{"name":"Jhon","age":24}' | fluent-cat sqlite3.persons
    echo '{"name":"Mike","age":27}' | fluent-cat sqlite3.persons

Let's see the database.

    sqlite3 test.db "select * from persons"
    1|Jhon|24
    2|Mike|27

### Ad hoc mode
[Getting started](#getting-started) is in `ad hoc mode`.

- tables are created when it's needed
- table names are the 2nd later part of tag, so don't contain illegal characters for table name
- primary key is id and auto increment
- column names are corresponding to all keys for given json


### Strict mode

If a schema you use is already fixed, you can use `strict mode`.

In the case, `table` and `columns` parameters should be used.

    <match sqlite3.**>
      type    sqlite3
      path    test.db
      table   persons
      columns name, age, country
    </match>


### Optional parameters

- `includes`: is in order to insert the columns you need
- `excludes`: is in order to filter out some keys you don't need to insert


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

      ## includes keys of json when inserting a new record
      #includes name, eye
      ## excludes keys of json when inserting a new record
      #excludes hair, eye

      ## fluentd built-in options
      buffer_type    memory
      flush_interval 1s
      retry_limit    1
      retry_wait     1s
      num_threads    1
    </match>
