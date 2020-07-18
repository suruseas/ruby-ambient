require 'ruby-ambient'

am = Ambient.new('channel_id', read_key: 'dummy', write_key: 'dummy')

pp am.prop
