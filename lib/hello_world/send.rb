# frozen_string_literal: true

require 'bunny'
require 'json'

module HelloWorld
  module Send
    module_function

    def run
      connection = Bunny.new(automatically_recover: false, username: 'user', password: 'password')
      connection.start

      channel = connection.create_channel
      queue = channel.quorum_queue('hello')

      channel.default_exchange.publish('Hello World!', routing_key: queue.name)
      puts " [x] Sent 'Hello World!'"

      connection.close
    end
  end
end

HelloWorld::Send.run if __FILE__ == $PROGRAM_NAME
