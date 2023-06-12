# frozen_string_literal: true

require 'kramdown/parser/kramdown'
require 'pry-byebug'

module Kramdown
  module Parser
    class KramdownErDiagram < ::Kramdown::Parser::Kramdown
      def initialize(source, options)
        super
        @block_parsers.unshift(:er_diagram)
        @block_parsers.unshift(:entity)
      end

      ER_DIAGRAM_START = /erDiagram[^\n]*(?:%%)?[^\n]*\n/.freeze
      ENTITY_START = /[\s\t]*([a-z]*)[\s\t]*\{\n(.*\n)+?[\s\t]*\}/.freeze

      def parse_er_diagram
        @src.pos += @src.matched_size
        start_line_number = @src.current_line_number

        @tree.children << Element.new(:er_diagram, @src.matched, nil, {
                                        location: start_line_number
                                      })
      end
      define_parser(:er_diagram, ER_DIAGRAM_START)

      def parse_entity
        @src.pos += @src.matched_size
        start_line_number = @src.current_line_number

        @tree.children << Element.new(:entity, @src.matched, nil, {
                                        location: start_line_number
                                      })
      end
      define_parser(:entity, ENTITY_START)
    end
  end
end
