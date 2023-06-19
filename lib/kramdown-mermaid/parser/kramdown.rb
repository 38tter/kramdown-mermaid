# frozen_string_literal: true

require 'kramdown/parser/kramdown'

module Kramdown
  module Parser
    # An extension of kramdown parser, currently entity and relation diagram is only supported
    class KramdownMermaid < ::Kramdown::Parser::Kramdown
      def initialize(source, options)
        super
        @block_parsers.unshift(:er_diagram)
        @block_parsers.unshift(:entity)
        @block_parsers.unshift(:relation)
      end

      ER_DIAGRAM = 'erDiagram'
      # Regarding to constraints, see https://mermaid.js.org/syntax/entityRelationshipDiagram.html
      CONSTRAINTS = %i[PK FK UK].freeze

      ER_DIAGRAM_START = /#{ER_DIAGRAM}[^\n]*(?:%%)?[^\n]*\n/.freeze
      ENTITY_START = /[\s\t]*([a-z_]*)[\s\t]*\{\n((?:.*\n)+?)[\s\t]*\}/.freeze
      RELATION_START = /[\s\t]*([a-z_]*)[\s\t]*(\|o|\|\||\}o|\}\|)--(o\{|\|\||o\{|\|\{)[\s\t]*([a-z_]*):[\s\t]*".*"[\s\t]*\n/.freeze # rubocop:disable Layout/LineLength

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

      def parse_relation
        @src.pos += @src.matched_size
        start_line_number = @src.current_line_number

        left_entity = @src[1]
        left_relation = @src[2]
        right_relation = @src[3]
        right_entity = @src[4]

        @tree.children << Element.new(:relation, @src.matched, nil, {
                                        left_entity: left_entity,
                                        left_relation: left_relation,
                                        right_relation: right_relation,
                                        right_entity: right_entity,
                                        location: start_line_number
                                      })
      end
      define_parser(:relation, RELATION_START)
    end
  end
end
