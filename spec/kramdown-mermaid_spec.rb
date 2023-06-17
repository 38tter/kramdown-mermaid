# frozen_string_literal: true

RSpec.describe Kramdown::Parser do
  it 'has a version number' do
    expect(Kramdown::Parser::KRAMDOWN_MERMAID_VERSION).not_to be nil
  end
end
