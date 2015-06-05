# Spine::Authorisation

[![Gem Version](https://badge.fury.io/rb/spine-authorisation.svg)](http://badge.fury.io/rb/spine-authorisation)
[![Dependency Status](https://gemnasium.com/rspine/authorisation.svg)](https://gemnasium.com/rspine/authorisation)
[![Test Coverage](https://codeclimate.com/github/rspine/authorisation/badges/coverage.svg)](https://codeclimate.com/github/rspine/authorisation/coverage)
[![Code Climate](https://codeclimate.com/github/rspine/authorisation/badges/gpa.svg)](https://codeclimate.com/github/rspine/authorisation)

Authorisation context for Ruby applications.

## Installation

To install it, add the gem to your Gemfile:

```ruby
gem 'spine-authorisation'
```

Then run `bundle`. If you're not using Bundler, just `gem install spine-authorisation`.

## Usage

Authorisation uses [Spine::Permissions](https://github.com/rspine/permissions)
and [Spine::Restrictions](https://github.com/rspine/restrictions) to define
rules.

```ruby
Spine::Authorisation.permissions do
  define(:user).grant(:read, :all)
end

Spine::Authorisation.restrictions do
  register(MyRestriction).restrict(:write, :all)
end
```

You can call `permissions` and `restrictions` directly or define yourself a
context. It requires you to override `role` and `subject` methods.

```ruby
class UserContext
  include Spine::Authorisation::Context

  # Required to override
  def role
    user.role
  end

  # Required to override
  def subject
    user
  end

  def user
   # find by identity
  end
end

context = UserContext.new
context.authorize(:read, :tasks)
# => true
```

Context authorize method also publishes events `:granted` and `:denied` with
`context, action, resource` arguments and `restricted` with
`context, restriction, action, resource` arguments (see more
[Spine::Hub](https://github.com/rspine/hub) to see how to subscribe these).

### Using with Spine::Engines

```ruby
# application.rb

module MyApp
  module Application
    extension Spine::Authorisation::Engine
  end
end
```

Then you need to define your permissions and restrictions in
`config/authorisation.rb`.

```ruby
module MyApp
  module Application
    permissions.define(:user).grant(:read, :all)
    permissions.define(:admin).grant(:all, :all)

    restrictions.register(MyRestriction).restrict(:write, :all)
  end
end
```
