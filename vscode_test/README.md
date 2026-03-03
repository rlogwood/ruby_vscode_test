# vscode on ruby RBS and Sorbet 

As a RubyMine user, I wanted to explore early support for inline RBS comment support in vscode.

The 2nd iteration has this working and requires using Sorbet. RubyMine doesn't support inline RBS yet.

But ruby/rbs is already getting the improvements, thanks @sautaro! 
- [inline.md](https://github.com/ruby/rbs/blob/master/docs/inline.md)
- TODO: try out master branch of https://github.com/ruby/rbs and try to get inline RBS working without Sorbet LSP
  




# Iteration 1 - use rbs and steep

- `Gemfile`
```
# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rbs'
gem 'rubocop', '~> 1.85', group: :development
gem 'ruby-lsp'
gem 'steep'
```

```
bundle exec steep init
```

```
# Steepfile
target :default do
  signature "sig"
  check "."
end
```

```
bundle exec steep check
```


# Iteration 2 - use Sorbet

- `Gemfile`
```
# frozen_string_literal: true

source 'https://rubygems.org'

gem 'rbs'
gem 'ruby-lsp'
gem 'sorbet', group: :development
gem 'sorbet-runtime'
gem 'sorbet-static'
gem 'sorbet-static-and-runtime'


gem 'tapioca', '>= 0.17', require: false, group: :development

gem 'rubocop', '~> 1.85', group: :development
```



- Steps
```
bundle install
bundle exec srb init
bundle exec tapioca init
bundle exec tapioca gems
bundle exec tapioca dsl
```

- To handle possible conflicts
> sorbet/rbi/gems/rbs@4.0.0.dev.5.rbi:3768: Parent of class RBS::DefinitionBuilder::MethodBuilder::Methods::Definition redefined from Anonymous_Struct_2 to Struct https://srb.help/5012
    3768 |class RBS::DefinitionBuilder::MethodBuilder::Methods::Definition < ::Struct
```
sed -i 's/# typed: false/# typed: ignore/' sorbet/rbi/gems/rbs@4.0.0.dev.5.rbi
bundle exec srb tc
```

### Summary
- Ruby LSP + Sorbet extension in VS Code
- Tapioca for generating RBI files
- `sorbet/config` with `--enable-experimental-rbs-comments`
- `#: inline comments for type annotations`
- `.rubocop.yml` with AllowRBSInlineAnnotation: true


### `.rubocopy.yml` 
- needed to prevent reformating of `#:` comments
```yaml
Layout/LeadingCommentSpace:
  AllowRBSInlineAnnotation: true
```


### `sorbet/config`
```
--dir
.
--ignore=/tmp/
--ignore=/vendor/bundle
--enable-experimental-rbs-comments
```

### Simple typed example with inline RBS style comments
```ruby
# frozen_string_literal: true
# typed: true

# NOTE: sorbet requires the `# typed: true` signature at the top of the file to enable type checking.

# This is a simple calculator
class Calculator
  #: (Integer, Integer) -> Integer
  def add(a, b)
    a + b
  end
end
```

### CachyOS notes
```
# install watchman, choose watchman-bin
paru -S watchman
```

### vscode notes
- install sorbet extension
```
code --install-extension sorbet.sorbet-vscode-extension

```
- update `.vscode/settings.json`

```
{
  // Use asdf for Ruby version management
  "rubyLsp.rubyVersionManager": {
    "identifier": "asdf"
  },
  // Enable RBS inline type comments (#: syntax)
  "sorbet.commandLineOptions": ["--enable-experimental-rbs-comments"]
}
```
