require_relative '03_associatable'
require 'byebug'
# Phase IV
module Associatable
  # Remember to go back to 04_associatable to write ::assoc_options

  def has_one_through(name, through_name, source_name)
    define_method(name) do
      through_options = self.class.assoc_options[through_name]
      source_options = through_options.model_class.assoc_options[source_name]
      result = DBConnection.execute(<<-SQL, self.attributes["#{through_options.foreign_key}".to_sym])
        SELECT
          a.*
        FROM
          #{source_options.table_name} AS a
        JOIN
          #{through_options.table_name} AS b
        ON b.#{source_options.foreign_key} = a.#{source_options.primary_key}
        WHERE
          b.#{through_options.primary_key} = ?
      SQL

      source_options.class_name.constantize.new(result[0])
    end
  end
end
