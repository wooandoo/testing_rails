= testing_rails

Testing rails is a generator to install and configure components in a rails application to test it with RSpec:

- rspec-rails
- capybara
- factory-girl

The tests are launched by guard and accelerated by spork.

== Installation

In the Gemfile:

```ruby
gem "testing_rails"
```

So configure the rails application to test it:

```ruby
rails g wooandoo:testing
```

Start guard to execute rspec tests:

	guard

== Contributing to testing_rails
 
* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. This is important so I don't break it in a future version unintentionally.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

== Copyright

Copyright (c) 2011 Frédéric Mascaro. See LICENSE.txt for
further details.

