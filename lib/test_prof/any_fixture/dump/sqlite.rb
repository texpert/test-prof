# frozen_string_literal: true

module TestProf
  module AnyFixture
    class Dump
      module SQLite
        module_function

        def reset_sequence!(table_name, start)
          conn = ActiveRecord::Base.connection

          conn.execute("DELETE FROM sqlite_sequence WHERE name=#{table_name}")
          conn.execute <<~SQL.chomp
            INSERT INTO sqlite_sequence (name, seq)
            VALUES (#{table_name}, #{start})
          SQL
        end

        def import(path)
          db = ActiveRecord::Base.connection.pool.spec.config[:database]
          return false if %r{:memory:}.match?(db)

          `sqlite3 #{db} < "#{path}"`
          true
        rescue Errno::ENOENT
          false
        end
      end
    end
  end
end