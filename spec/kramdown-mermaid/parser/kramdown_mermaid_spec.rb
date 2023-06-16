# frozen_string_literal: true

require 'kramdown-mermaid/parser/kramdown'
require 'kramdown'

describe Kramdown::Parser::KramdownMermaid do
  context 'when parsing a simple block including erDiagram' do
    it 'coverts to hash ast' do
      ast = Kramdown::Document.new("erDiagram %% some comments\n", input: 'KramdownMermaid').to_hash_ast
      expect(ast[:children]).to eq([{ type: :er_diagram, value: "erDiagram %% some comments\n",
                                      options: { location: 2 } }])
    end
  end

  context 'when parsing a simple block including entity' do
    it 'coverts to hash ast' do
      ast = Kramdown::Document.new("hoge {\n  bigint id PK\n  int fuga\n }\n", input: 'KramdownMermaid').to_hash_ast
      expect(ast[:children]).to eq([
                                     { type: :entity, value: "hoge {\n  bigint id PK\n  int fuga\n }",
                                       options: { entity: 'hoge',
                                                  attributes: [{ type: 'bigint', name: 'id', constraint: 'PK' },
                                                               { type: 'int', name: 'fuga', constraint: nil }],
                                                  location: 5 } }, { type: :blank, value: "\n" }
                                   ])
    end
  end

  context 'when parsing a simple block including relation' do
    it 'coverts to hash ast' do
      ast = Kramdown::Document.new("hoges |o--o{  fugas: \"\"\n", input: 'KramdownMermaid').to_hash_ast
      expect(ast[:children]).to eq([{ type: :relation, value: "hoges |o--o{  fugas: \"\"\n",
                                      options: { left_entity: 'hoges',
                                                 left_relation: '|o', right_relation: 'o{',
                                                 right_entity: 'fugas', location: 2 } }])
    end
  end
end
