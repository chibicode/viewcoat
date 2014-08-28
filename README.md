# Viewcoat, for Rails Views

**Viewcoat** lets you pass *optional* parameters to Rails partials ... in a weird way. @chibicode believes that this makes view code simpler.

### Before Viewcoat:

Let's say I'd like to render a partial that contains a Bootstrap [button group](http://getbootstrap.com/components/#btn-groups). Its classes can be customized via `button_class` and `button_group_class` parameters, and the second button can be hidden by setting `show_second_button` to false.

#### `show.erb`:

```erb
<%= render "buttons",
  button_class: "btn-primary",
  button_group_class: "btn-group-lg",
  show_second_button: false %>
```

#### `_buttons.erb`:

```
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

#### `show.html`:

```erb
<%= coat.with(button_class: "btn-primary",
  button_group_class: "btn-group-lg",
  show_second_button: false) do %>

  <%= render "buttons" %>

<% end %>
```

#### `_buttons.html`:

```
<% coat.defaults(button_class: "btn-default",
  button_group_class: "",
  show_second_button: false) %>

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

```erb
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
<!--  -->
```

**NOTE:** If we were to use a cache block in `_c.erb` above, it'll compute the cache key using values of *both* a and b.

## Contributing

1. Fork it ( https://github.com/chibicode/viewcoat/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
