# frozen_string_literal: true

require 'kramdown/parser/kramdown'

module Kramdown
  module Parser
    class KramdownErDiagram < ::Kramdown::Parser::Kramdown
      def initialize(source, options)
        super
        @block_parsers.unshift(:er_diagram)
        @block_parsers.unshift(:entity)
      end

      ER_DIAGRAM = 'erDiagram'
      # See https://github.com/rails/rails/blob/984c3ef2775781d47efa9f541ce570daa2434a80/activerecord/lib/active_record/connection_adapters/abstract/schema_definitions.rb#L257-L258
      TYPES = %i[bigint binary boolean date datetime decimal float integer json string text time timestamp
                 virtual references].freeze
      CONSTRAINTS = %i[PK FK UK].freeze

      ER_DIAGRAM_START = /#{ER_DIAGRAM}[^\n]*(?:%%)?[^\n]*\n/.freeze
      ENTITY_START = /[\s\t]*([a-z_]*)[\s\t]*\{\n((?:.*\n)+?)[\s\t]*\}/.freeze

      def parse_er_diagram
        @src.pos += @src.matched_size
        start_line_number = @src.current_line_number

        @tree.children << Element.new(:er_diagram, @src.matched, nil, {
                                        location: start_line_number
                                      })
      end
      define_parser(:er_diagram, ER_DIAGRAM_START)

      def attributes
        arr = @src[2].split(/\n/).map { |a| a.gsub(/\A\s*/, '').gsub(/\s*\Z/, '') }
        arr.map do |a|
          s = a.split(/\s/)

          type = s[0]
          name = s[1]
          constraint = s.length > 2 ? s[2] : nil

          raise Kramdown::Error, "Invalid type #{s[0]} for attribute #{s[1]}" unless TYPES.include? s[0].to_sym

          if constraint && !CONSTRAINTS.include?(constraint.to_sym)
            raise Kramdown::Error,
                  "Invalid constraint #{constraint} for attribute #{s[1]}"
          end

          { type: type, name: name, constraint: constraint }
        end
      end

      def parse_entity
        @src.pos += @src.matched_size
        start_line_number = @src.current_line_number

        entity = @src[1]

        @tree.children << Element.new(:entity, @src.matched, nil, {
                                        entity: entity,
                                        attributes: attributes,
                                        location: start_line_number
                                      })
      end
      define_parser(:entity, ENTITY_START)
    end
  end
end
