# UnixLikePermissions

The `UnixLikePermissions` gem provides a Ruby implementation for managing a Unix-like permissions system. It allows you to manipulate permission flags (such as read, create, update, destroy) using binary operations, offering an ActiveRecord type for easy integration with Rails applications.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'unix_like_permissions'
```

And then execute:

```shell
bundle install
```

Or install it yourself with:

```shell
gem install unix_like_permissions
```

The `UnixLikePermissions` gem utilizes binary operations to manage permissions efficiently. Each permission is associated with a bit within an integer, and the permission set is represented as a binary number. Here's how it works:

- Each permission is assigned a binary value (`read` is `1`, `create` is `10`, `update` is `100`, `destroy` is `1000` in binary).
- Setting a permission turns the corresponding bit to `1` (true), while unsetting it turns the bit to `0` (false).
- Binary `OR` (`|`) operations are used to enable permissions.
- Binary `AND` (`&`) operations combined with `NOT` (`~`) are used to disable permissions.
- Binary `AND` (`&`) operations are used to check if a permission is enabled.

These operations allow the gem to manage permissions in a performant and memory-efficient way, mirroring the time-tested Unix permission system.

- **Efficiency**: Managing permissions as bits within a single integer is computationally efficient and fast.
- **Flexibility**: Easily define your own set of permissions according to the needs of your application.
- **Intuitiveness**: The API is designed to be simple and easy to use, even for developers not familiar with bitwise operations.
- **ActiveRecord Integration**: Comes with built-in support for ActiveRecord, making it easy to store permissions in a database.
- **Object-Oriented**: Provides a clear object-oriented interface for permission operations.

## Usage

After installing the gem, you can use it to define a set of permissions and interact with them in an object-oriented manner.
Defining Permissions

Permissions are represented as a series of bits, with each bit corresponding to a particular permission. You can define and load a custom permissions map or use the default one.
Using Default Permissions

UnixLikePermissions::PermissionSeries object consumes Integer value of a permission code.
To create a new PermissionSeries object, you can pass an Integer value to the constructor:

```ruby
permission_series = UnixLikePermissions::PermissionSeries.new(0)
```

0 stands for no permissions set. You can also pass a string to the constructor 0 and then set permissions using the set method:

```ruby
permission_series = UnixLikePermissions::PermissionSeries.new('0')
permission_series.set(update: true)
permission_series.set(destroy: true)

permission_series.to_i # => 6
permission_series.to_h # => {:update=>true, :destroy=>true, :read=>false, :create=>false}
permission_series.update? # => true
permission_series.read # => false
```

The gem comes with a default set of permissions:

    read
    create
    update
    destroy

You can use these permissions as follows:

```ruby
permission_series = UnixLikePermissions::PermissionSeries.new(0)
permission_series.set(update: true)
permission_series.set(destroy: true)
```

### Loading a Custom Permissions Map

You can define your own permissions map and load it using the UnixLikePermissions.load_permissions_map! method:

```ruby
custom_permissions = [
  :show,
  :impersonate,
  :delete,
  :report
]

UnixLikePermissions.load_permissions_map!(custom_permissions)
```

###  Checking Permissions

You can check if a particular permission is set by calling the query methods:

```ruby
permission_series.delete? # => true or false
permission_series.impersonate? # => true or false
```

### Serialization for ActiveRecord

The gem provides a custom type for ActiveRecord, so you can use it directly in your models:

```ruby
# db/migrate/*

class AddPermissionsToUsers < ActiveRecord::Migration[6.0]
  def change
    add_column :users, :permissions, :integer, default: 0
  end
end

# app/models/user.rb
class User < ApplicationRecord
  attribute :permissions, UnixLikePermissions::Types::PermissionSeries.new
end

# config/initializers/unix_like_permissions.rb
require 'unix_like_permissions'
require 'unix_like_permissions/types/permission_series'

ActiveRecord::Type.register(:permission_series_type, UnixLikePermissions::Types::PermissionSeries)

```

### API
*With default permissions map goes the following API:*

#### Checking Permissions

    read?: Returns true if the read permission is set.
    create?: Returns true if the create permission is set.
    update?: Returns true if the update permission is set.
    destroy?: Returns true if the destroy permission is set.

```ruby
permissions.update?
```

#### Permission Value

`#to_i`: Returns the integer value of the permissions.

```ruby
permissions.to_i  # => 4
```

#### Serialization

`#to_h`: Returns a hash with permission names as keys and boolean values indicating whether each permission is set.
```ruby
permissions.to_h  # => { read: false, create: false, update: true, destroy: false }
```

`#to_s`: Returns a string representation of the set permissions.
```ruby
permissions.to_s  # => "update"
```

`#to_a(type = :str)`: Returns an array representation of the permissions. The type parameter can be :str, :int, or :bool.
```ruby
permissions.to_a(:bool)  # => [false, false, true, false]
permissions.to_a(:int)  # => [0, 0, 1, 0]
permissions.to_a(:str)  # => ['0', '0', '1', '0]
```


#### Miscellaneous

`#set_all(value)`: Sets all permissions to the boolean value provided (true or false).

```ruby
permissions.set_all(true)

permissions.to_s # => "read create update destroy"
```

set({ permission: value, ... }): Sets the specified permission to the boolean value provided (true or false).

```ruby
permissions.set(read: true, create: false)
permissions.to_s # => "read"
```

## Contributing

Bug reports and pull requests are welcome on GitHub at [repository URL]. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [code of conduct](link to code of conduct).

## License

The gem is available as open source under the terms of the MIT License.
