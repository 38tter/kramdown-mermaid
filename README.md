# kramdown-mermaid

This is a gem for parsing [Mermaid syntax](https://mermaid.js.org/), and is an extension of kramdown.

Currently, only parsing of [Entity Relationship Diagrams](https://mermaid.js.org/syntax/entityRelationshipDiagram.html) is supported, but we hope to support parsing of Class Diagrams and Sequence Diagrams and more in the future.

## Installation

Add this line to your application's Gemfile:

    gem 'kramdown-mermaid'

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install kramdown-mermaid

## Usage

    require 'kramdown'
    require 'kramdown-mermaid'

    text = <<EOS

    # some title
    ccc **ddd** eee

    # Image
    ![Wikimedia](https://en.wikipedia.org/wiki/Wikimedia_Commons#/media/File:Commons-logo-en.svg "Wikimedia")

    some comments

    erDiagram %% some comment
        hoges {
            bigint id PK
            int price
            date start_on
            datetime created_at
            datetime updated_at
        }

        fugas {
            bigint id PK
            int price
            datetime created_at
            datetime updated_at
        }

    hoges |o--o{  fugas: "some comment"** 
    EOS
    
    Kramdown::Document.new(text, input: 'KramdownMermaid').to_hash_ast
    
    # => 
    {:type=>:root,
    :options=>{:encoding=>#<Encoding:UTF-8>, :location=>1, :options=>{}, :abbrev_defs=>{}, :abbrev_attr=>{}, :footnote_count=>0},
    :children=>
    [{:type=>:header,
    :options=>{:level=>1, :raw_text=>"some title", :location=>1},
    :children=>[{:type=>:text, :value=>"some title", :options=>{:location=>1}}]},
    {:type=>:p,
    :options=>{:location=>2},
    :children=>
    [{:type=>:text, :value=>"ccc ", :options=>{:location=>2}},
    {:type=>:strong, :options=>{:location=>2}, :children=>[{:type=>:text, :value=>"ddd", :options=>{:location=>2}}]},
    {:type=>:text, :value=>" eee", :options=>{:location=>2}}]},
    {:type=>:blank, :value=>"\n"},
    {:type=>:header, :options=>{:level=>1, :raw_text=>"Image", :location=>4}, :children=>[{:type=>:text, :value=>"Image", :options=>{:location=>4}}]},
    {:type=>:p,
    :options=>{:location=>5},
    :children=>
    [{:type=>:img,
    :attr=>{"src"=>"https://en.wikipedia.org/wiki/Wikimedia_Commons#/media/File:Commons-logo-en.svg", "alt"=>"Wikimedia", "title"=>"Wikimedia"},
    :options=>{:location=>5, :ial=>nil}}]},
    {:type=>:blank, :value=>"\n"},
    {:type=>:p, :options=>{:location=>7}, :children=>[{:type=>:text, :value=>"some comments", :options=>{:location=>7}}]},
    {:type=>:blank, :value=>"\n"},
    {:type=>:er_diagram, :value=>"erDiagram %% some comment \n", :options=>{:location=>10}},
    {:type=>:p,
    :options=>{:location=>10},
    :children=>
    [{:type=>:text,
    :value=>"hoges { \n    bigint id PK\n    int price\n    date start_on\n    datetime created_at\n    datetime updated_at\n  }",
    :options=>{:location=>10}}]},
    {:type=>:entity,
    :value=>"  \n  fugas {\n    bigint id PK\n    int price\n    datetime created_at\n    datetime updated_at\n  }",
    :options=>
    {:entity=>"fugas",
    :attributes=>
    [{:type=>"bigint", :name=>"id", :constraint=>"PK"},
    {:type=>"int", :name=>"price", :constraint=>nil},
    {:type=>"datetime", :name=>"created_at", :constraint=>nil},
    {:type=>"datetime", :name=>"updated_at", :constraint=>nil}],
    :location=>24}},
    {:type=>:relation,
    :value=>"\n\nhoges |o--o{  fugas: \"some comment\"\n",
    :options=>{:left_entity=>"hoges", :left_relation=>"|o", :right_relation=>"o{", :right_entity=>"fugas", :location=>26}}]}


## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` or `bundle exec rspec` on root to run the tests. 
You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

PRs and issues are always welcomed on GitHub at https://github.com/38tter/kramdown-mermaid. 
This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](https://github.com/[USERNAME]/kramdown-mermaid/blob/master/CODE_OF_CONDUCT.md).

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Kramdown::Mermaid project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/kramdown-mermaid/blob/master/CODE_OF_CONDUCT.md).
