require 'ruby-ambient'

am = Ambient.new('channel_id', read_key: 'dummy', write_key: 'dummy')

p am.send({d1: 1, d2: 2})
