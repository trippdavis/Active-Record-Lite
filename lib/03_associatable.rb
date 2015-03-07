require_relative '02_searchable'
require 'active_support/inflector'
require 'byebug'
# Phase IIIa
class AssocOptions
  attr_accessor(
    :foreign_key,
    :class_name,
    :primary_key
  )

  def model_class
    @class_name.constantize
  end

  def table_name
    model_class.table_name
  end
end

class BelongsToOptions < AssocOptions
  def initialize(name, options = {})
    if options[:foreign_key]
      @foreign_key = options[:foreign_key]
    else
      @foreign_key = "#{name}_id".to_sym
    end

    if options[:class_name]
      @class_name = options[:class_name]
    else
      @class_name = name.to_s.camelize
    end

    if options[:primary_key]
      @primary_key = options[:primary_key]
    else
      @primary_key = :id
    end
  end
end

class HasManyOptions < AssocOptions
  def initialize(name, self_class_name, options = {})
    if options[:foreign_key]
      @foreign_key = options[:foreign_key]
    else
      @foreign_key = "#{self_class_name}Id".underscore.to_sym
    end

    if options[:class_name]
      @class_name = options[:class_name]
    else
      @class_name = name.to_s.camelize.singularize
    end

    if options[:primary_key]
      @primary_key = options[:primary_key]
    else
      @primary_key = :id
    end
  end
end

module Associatable
  # Phase IIIb
  def belongs_to(name, options = {})
    options = BelongsToOptions.new(name, options)

    assoc_options[name] = options

    define_method("#{name}") do
      foreign_key = self.send(options.foreign_key)
      model_class = options.model_class
      model_class.where({id: foreign_key}).first
    end

  end

  def has_many(name, options = {})
    options = HasManyOptions.new(name, self, options)

    define_method("#{name}") do
      primary_key = self.send(options.primary_key)
      model_class = options.model_class
      model_class.where({options.foreign_key => primary_key})
    end
  end

  def assoc_options
    @assoc_options ||= {}
  end
end

class SQLObject
  extend Associatable
end
