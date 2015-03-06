require_relative 'db_connection'
require 'active_support/inflector'
# NB: the attr_accessor we wrote in phase 0 is NOT used in the rest
# of this project. It was only a warm up.

class SQLObject
  def self.columns
    column_names = DBConnection.execute2(<<-SQL)
      SELECT
        *
      FROM
        #{table_name}
      LIMIT
        0
      SQL

      column_names.flatten.map(&:to_sym)
  end

  def self.finalize!
    self.columns.each do |column|
      define_method("#{column}") do
        self.attributes["#{column}".to_sym]
      end

      define_method("#{column}=") do |column_set|
        self.attributes["#{column}".to_sym] = column_set
      end
    end
  end

  def self.table_name=(table_name)
    @table_name = table_name
  end

  def self.table_name
    return @table_name if @table_name
    self.to_s.tableize
  end

  def self.all
    # ...
  end

  def self.parse_all(results)
    # ...
  end

  def self.find(id)
    # ...
  end

  def initialize(params = {})
    params.each do |attr, value|
      attr_sym = attr.to_sym
      unless self.class.columns.include?(attr_sym)
        raise "unknown attribute '#{attr}'"
      end

      send("#{attr_sym}=", value)
    end
  end

  def attributes
    @attributes ||= {}
  end

  def attribute_values
    # ...
  end

  def insert
    # ...
  end

  def update
    # ...
  end

  def save
    # ...
  end
end
