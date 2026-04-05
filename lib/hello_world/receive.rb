# frozen_string_literal: true

require 'bunny'

module HelloWorld
  module Receive
    module_function

    def receive
      connection = Bunny.new(automatically_recover: false, username: 'user', password: 'password')
      connection.start

      channel = connection.create_channel
      queue = channel.quorum_queue('hello')

      begin
        puts ' [*] Waiting for messages. To exit press CTRL+C'
        queue.subscribe(block: true) do |_delivery_info, _properties, body|
          puts " [x] Received #{body}"
        end
      rescue Interrupt => _e
        connection.close

        exit(0)
      end
    end
  end
end

HelloWorld::Receive.receive if __FILE__ == $PROGRAM_NAME
