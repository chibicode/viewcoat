# Viewcoat, for Rails Views

[![Gem Version](https://badge.fury.io/rb/viewcoat.svg)](http://badge.fury.io/rb/viewcoat)
[![Build Status](https://travis-ci.org/chibicode/viewcoat.svg)](https://travis-ci.org/chibicode/viewcoat)
[![Code Climate](https://codeclimate.com/github/chibicode/viewcoat/badges/gpa.svg)](https://codeclimate.com/github/chibicode/viewcoat)
[![Coverage Status](https://img.shields.io/coveralls/chibicode/viewcoat.svg)](https://coveralls.io/r/chibicode/viewcoat)

**Viewcoat** lets you pass *optional* parameters to Rails partials ... in a weird way. [@chibicode](http://github.com/chibicode) believes that this makes view code simpler. Viewcoat also plays with [fragment caching](http://guides.rubyonrails.org/caching_with_rails.html#fragment-caching) nicely.

### Before Viewcoat:

Let's say I'd like to render a partial that contains a Bootstrap [button group](http://getbootstrap.com/components/#btn-groups). Its classes can be customized via `button_class` and `button_group_class` parameters, and the second button can be hidden by setting `show_second_button` to false.

#### `show.erb`:

```html+erb
<%= render "buttons",
  button_class: "btn-primary",
  button_group_class: "btn-group-lg",
  show_second_button: false %>
```

#### `_buttons.erb`:

```html+erb
<% button_class ||= "btn-default" %>
<% button_group_class ||= "" %>
<% local_assigns.fetch :show_second_button, true %>

<% cache [button_class, button_group_class, show_second_button] do %>
  <div class="btn-group <%= button_group_class %>">
    <button class="btn <%= button_class %>">Button 1</button>
    <% if show_second_button %>
      <button class="btn <%= button_class %>">Button 2</button>
    <% end %>
  </div>
<% end %>
```

Notice that setting defaults can be tricky for boolean values (`||=` trick [doesn't work](http://stackoverflow.com/questions/2060561/optional-local-variables-in-rails-partial-templates-how-do-i-get-out-of-the-de#comment2015511_2060815).) Also, you'd have to list all the parameters on `cache`.

### After Viewcoat:

Viewcoat uses `coat.with`, `coat.defaults`, and `method_missing` to simplify the above code.

#### `show.erb`:

```html+erb
<%= coat.with(button_class: "btn-primary",
  button_group_class: "btn-group-lg",
  show_second_button: false) do %>

  <%= render "buttons" %>

<% end %>
```

#### `_buttons.erb`:

```html+erb
<% coat.defaults(button_class: "btn-default",
  button_group_class: "",
  show_second_button: true) %>

<% cache [coat] do %>
  <div class="btn-group <%= coat.button_group_class %>">
    <button class="btn <%= coat.button_class) %>">Button 1</button>
    <% if coat.show_second_button %>
      <button class="btn <%= coat.button_class %>">Button 2</button>
    <% end %>
  </div>
<% end %>
```

That's it. Nothing radical. I use this when [presenters](https://www.ruby-toolbox.com/categories/rails_presenters) become overkill.

## Installation

    gem 'viewcoat'

## Usage

### Rails View Helpers

- `coat`

  Returns a `Viewcoat::Store` instance, which does all the magic.

### `Viewcoat::Store` methods

- `coat.with(hash) { block }`

  Stores all key-value pairs from `hash` and makes it available inside `block`, overriding defaults (see below).

- `coat.defaults(hash)`

  Sets the default value from `hash`.

- `coat.cache_key`

  Returns a unique cache key representing the current store.

- `coat.<key_name>`

  Retrieves a value using `key_name`.

- `coat.<key_name> = <value>`

  Sets `key_name`, `value` pair.

- `coat.<method_name>`

  If the key doesn't exist, then the method will be delegated to the internal hash that stores data. So you can call `Hash` methods, e.g. `coat.include?(:key)`

### Notes on Nesting

You can nest `with`, and all of the variables from outer blocks will be available in the child block.

```html+erb
<!-- a.erb -->
<%= coat.with(a: 1) do %>
  <%= render "b" %>
<% end %>

<!-- _b.erb -->
<%= coat.with(b: 2) do %>
  <%= render "c" %>
<% end %>

<!-- _c.erb -->
<%= coat.a %>
<%= coat.b %>
```

**NOTE:** If we were to use a cache block in `_c.erb` above, it'll compute the cache key using values of *both* a and b.

### Tested Ruby Versions

It's failing on 1.9.3 because `OpenStruct` doesn't have `#to_h` method, and I'm too lazy to fix this.

- 2.0.0
- 2.1.2

## Contributing

1. Fork it ( https://github.com/chibicode/viewcoat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request

## Author

Shu Uesugi ([Twitter](http://twitter.com/chibicode)/[GitHub](http://github.com/chibicode)/[G+](https://plus.google.com/110325199858284431541?rel=author)).

![Shu Uesugi](http://www.gravatar.com/avatar/b868d84bbe2ed30ec45c9253e1c1cefe.jpg?s=200)

### License

[MIT License](http://chibicode.mit-license.org/)
