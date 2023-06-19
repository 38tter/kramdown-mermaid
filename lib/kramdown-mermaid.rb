# frozen_string_literal: true

require_relative 'kramdown-mermaid/version'

require 'kramdown'

module Kramdown
  # :nodoc:
  class Element
    CATEGORY[:er_diagram] = :block
    CATEGORY[:entity] = :block
    CATEGORY[:relation] = :block
  end
end

require 'kramdown-mermaid/parser'
