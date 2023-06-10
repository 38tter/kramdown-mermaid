# frozen_string_literal: true

require_relative 'kramdown-mermaid/version'

require 'kramdown'

module Kramdown
  class Element
    CATEGORY[:er_diagram] = :block
  end
end
