# frozen_string_literal: true

require './lib/rabbitmq/connection'
require './lib/rabbitmq/constants'

module WorkQueues
  class Publisher
    def initialize(queue_name:, connection: RabbitMQ::Connection.new)
      @queue_name = queue_name
      @connection = connection
    end

    def publish(message)
      connection.connect do
        channel = connection.make_channel
        queue = channel.create_quorum_queue(queue_name)

        # routing_key: routes the message to the queue matching the queue name — when using the
        # persistent: marks the message as durable so RabbitMQ writes it to disk; combined with
        # a durable queue, this ensures messages survive a broker restart.
        channel.default_exchange.publish(message, routing_key: queue.name, persistent: true)
        puts " [x] Sent #{message}"
      end
    end

    private

    attr_reader :connection, :queue_name
  end
end

if __FILE__ == $PROGRAM_NAME
  5.times do |i|
    dots = '.' * i
    WorkQueues::Publisher.new(queue_name: RabbitMQ::Constants::QUEUES[:hello]).publish("Hello World#{dots}")
  end
end
