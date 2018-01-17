# BitPermission

Bitwise permission operate

## Features

* Eeay — Define you list-type permissions, convert to integer-type permissions, operate them using BitPermission!
* Performance — Use erlang bitwise calculate.
* Pure — All function are pure function.

## Installation

Add it to your deps list in `mix.exs`:

```elixir
defp deps do
  [
    {:bit_permission, github: "qwas368/BitPermission"}
  ]
end
```

Fetch mix dependencies by running:
```sh
$ mix deps.get
```

## Examples

Build your list-type permission

```elixir
# full permission (list-type)
full_permission_list = [:create, :read, :update, :delete]
```

Change list-type permission to integer-type permission like:

```elixir
# full permission (integer-type)
full_permission = full_permission_list |> BitPermission.to_integer(full_permission_list)

# read permission (integer-type)
read_permission = [:read] |> BitPermission.to_integer(full_permission_list)
```
Create a user data with permission and use it

```elixir
# create user data
user = %{name: "John", permission: read_permission}

# can?
case user[:permission] |> BitPermission.can?(full_permission) do
  true -> ...
  false -> ...
end
```

### Contributing

Welcome contributions! This is my first github project and want to learn more.
* You feel like an important feature is missing from the BitPermission, feel free to fork the project
and open a pull request.
* Since English is not my native language, please help to correct my spelling or grammar error.
