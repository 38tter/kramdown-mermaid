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

  context 'when parsing a complex document' do
    let(:with_mermaid_src) { IO.read(File.expand_path('../../fixtures/with_mermaid.md', __dir__)) }

    context 'with mermaid' do
      it 'converts to ast' do
        ast = Kramdown::Document.new(with_mermaid_src, input: 'KramdownMermaid').to_hash_ast
        expect(ast[:children]).to eq(
          [{ type: :header, options: { level: 1, raw_text: 'some title', location: 1 }, children: [{ type: :text, value: 'some title', options: { location: 1 } }] },
           { type: :blank, value: "\n" },
           { type: :ul,
             options: { location: 3, first_list_marker: '-' },
             children: [{ type: :li, options: { location: 3 }, children: [{ type: :p, options: { location: 3, transparent: true }, children: [{ type: :text, value: 'a', options: { location: 3 } }] }] },
                        { type: :li,
                          options: { location: 4 },
                          children: [{ type: :p, options: { location: 4, transparent: true }, children: [{ type: :text, value: "b\n", options: { location: 4 } }] },
                                     { type: :ul,
                                       options: { location: 5, first_list_marker: '-' },
                                       children: [{ type: :li, options: { location: 5 }, children: [{ type: :p, options: { location: 5, transparent: true }, children: [{ type: :text, value: 'cc', options: { location: 5 } }] }] },
                                                  { type: :li, options: { location: 6 },
                                                    children: [{ type: :p, options: { location: 6, transparent: true }, children: [{ type: :text, value: 'dd', options: { location: 6 } }] }] }] }] }] },
           { type: :blank, value: "\n" },
           { type: :header, options: { level: 1, raw_text: 'inline', location: 8 },
             children: [{ type: :text, value: 'inline', options: { location: 8 } }] },
           { type: :p, options: { location: 9 },
             children: [{ type: :text, value: 'ccc ', options: { location: 9 } }, { type: :strong, options: { location: 9 }, children: [{ type: :text, value: 'ddd', options: { location: 9 } }] }, { type: :text, value: ' eee', options: { location: 9 } }] },
           { type: :blank, value: "\n" },
           { type: :header, options: { level: 1, raw_text: 'Image', location: 11 },
             children: [{ type: :text, value: 'Image', options: { location: 11 } }] },
           { type: :p, options: { location: 12 },
             children: [{ type: :img, attr: { 'src' => 'https://en.wikipedia.org/wiki/Wikimedia_Commons#/media/File:Commons-logo-en.svg', 'alt' => 'Wikimedia', 'title' => 'Wikimedia' }, options: { location: 12, ial: nil } }] },
           { type: :blank, value: "\n" },
           { type: :p, options: { location: 14 },
             children: [{ type: :text, value: 'some comments', options: { location: 14 } }] },
           { type: :blank, value: "\n" },
           { type: :er_diagram, value: "erDiagram %% some comment \n",
             options: { location: 17 } },
           { type: :p, options: { location: 17 },
             children: [{ type: :text, value: "hoges { \n    bigint id PK\n    int price\n    date start_on\n    datetime created_at\n    datetime updated_at\n  }", options: { location: 17 } }] },
           { type: :entity,
             value: "  \n  fugas {\n    bigint id PK\n    int price\n    datetime created_at\n    datetime updated_at\n  }",
             options: { entity: 'fugas',
                        attributes: [{ type: 'bigint', name: 'id', constraint: 'PK' }, { type: 'int', name: 'price', constraint: nil }, { type: 'datetime', name: 'created_at', constraint: nil }, { type: 'datetime', name: 'updated_at', constraint: nil }], location: 31 } },
           { type: :relation, value: "\n\nhoges |o--o{  fugas: \"some comment\"\n",
             options: { left_entity: 'hoges', left_relation: '|o', right_relation: 'o{', right_entity: 'fugas', location: 33 } },
           { type: :relation, value: "piyos |o--|| hoges: \"some comment\"\n",
             options: { left_entity: 'piyos', left_relation: '|o', right_relation: '||', right_entity: 'hoges', location: 34 } },
           { type: :relation, value: "fugas ||--o{ hoges: \"\"\n",
             options: { left_entity: 'fugas', left_relation: '||', right_relation: 'o{', right_entity: 'hoges', location: 35 } }]
        )
      end
    end
  end
end
