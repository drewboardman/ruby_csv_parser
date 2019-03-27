Counts all rows in all directory `csv` files that have a particular matching key/value

## Installation
* Recommend [`rbenv`](https://github.com/rbenv/rbenv).
* If you're on a mac, probably need to run:

```
rbenv local <my version I want>
```

* Install gems

```
gem install bundler # if you haven't already
bundle install --path=vendor/bundle
```

### Example usage

```ruby
bundle exec ruby rip_parse.rb "$(pwd)" name Drew

Drew rows in this file: 10000
Drew rows total so far: 30000
Time: 0.16
Memory: 0.39 MB
```
