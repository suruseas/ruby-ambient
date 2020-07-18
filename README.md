# Ruby::Ambient

A simple library that calls Ambient's API, which can be used similarly to [official python library](https://github.com/AmbientDataInc/ambient-python-lib)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'ruby-ambient'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install ruby-ambient

## Usage

### Send sensor data to Ambient

`write_key` is required. Set it when you create the ambient instance, or set it from accessor.

```ruby
am = Ambient.new('12345', write_key: '1234567890abcdef')
p am.send({d1: 1.03, d2: 2.2})
# => #<Net::HTTPOK 200 OK readbody=true>
```

```ruby
am = Ambient.new('12345')
am.write_key = '1234567890abcdef'
am.send([
  { created: '2020/7/18 20:21:19', d1: 2.3, d2: 3.8 },
  { created: '2020/7/18 20:21:20', d1: 2.1, d2: 3.1 },
])
```

### Receive sensor data from Ambient

`read_key` is required. Set it when you create the ambient instance, or set it from accessor.

```ruby
require 'pp'
am = Ambient.new('12345', read_key: '1234567890abcdef')
pp am.read()

# => 
# [{:d1=>1.1, :d2=>2.1, :created=>"2017-02-18T03:00:00.000Z"},
#  {:d1=>1.5, :d2=>3.8, :created=>"2017-02-18T03:01:00.000Z"},
#  {:d1=>1, :d2=>0.8, :created=>"2017-02-18T03:02:00.000Z"},
#  {:d1=>2.3, :d2=>3.8, :created=>"2020-07-16T11:21:19.000Z"},
#  {:d1=>2.1, :d2=>3.1, :created=>"2020-07-16T11:21:20.000Z"},
#  {:d1=>1.1, :d2=>2.1, :created=>"2020-07-18T07:00:00.000Z"},
#  {:d1=>1.1, :d2=>2.1, :created=>"2020-07-18T07:00:00.000Z"},
#  {:d1=>1.5, :d2=>3.8, :created=>"2020-07-18T07:01:00.000Z"},
#  {:d1=>1.5, :d2=>3.8, :created=>"2020-07-18T07:01:00.000Z"},
#  {:d1=>1, :d2=>0.8, :created=>"2020-07-18T07:02:00.000Z"},
#  {:d1=>1, :d2=>0.8, :created=>"2020-07-18T07:02:00.000Z"},
#  {:d1=>1, :d2=>2, :created=>"2020-07-18T08:43:33.240Z"},
#  {:d1=>1, :d2=>2, :created=>"2020-07-18T12:31:18.886Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:21:13.917Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:21:26.165Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:21:57.722Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:22:23.619Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:23:03.688Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:24:04.937Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:26:25.843Z"}]
```

If you want to specify a date, set the `date`.
The format of the date is `YYYY-mm-dd` or `YYYY/mm/dd`.


```ruby
require 'pp'
am = Ambient.new('12345', read_key: '1234567890abcdef')
pp am.read(date: '2017-2-18')

# => 
# [{:d1=>1.1, :d2=>2.1, :created=>"2017-02-18T03:00:00.000Z"},
#  {:d1=>1.5, :d2=>3.8, :created=>"2017-02-18T03:01:00.000Z"},
#  {:d1=>1, :d2=>0.8, :created=>"2017-02-18T03:02:00.000Z"}]
```

If you want to specify the period, set `start` and `end`.
The time zone of the date is `JST`.

```ruby
require 'pp'
am = Ambient.new('12345', read_key: '1234567890abcdef')
pp am.read(start: '2020-07-18 22:20:00', end: '2020-07-18 22:25:00')

# => 
# [{:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:21:13.917Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:21:26.165Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:21:57.722Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:22:23.619Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:23:03.688Z"},
#  {:d1=>1.03, :d2=>2.2, :created=>"2020-07-18T13:24:04.937Z"}]
```

### Receive channel information

`read_key` is required. Set it when you create the ambient instance, or set it from accessor.

```ruby
require 'pp'
am = Ambient.new('12345', read_key: '1234567890abcdef')
pp am.prop()

# =>
# {:ch=>"12345",
#  :user=>"1234",
#  ...
# }
```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/suruseas/ruby-ambient.
