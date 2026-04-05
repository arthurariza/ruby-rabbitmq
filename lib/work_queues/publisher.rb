# frozen_string_literal: true

require './lib/rabbitmq/connection'
require './lib/rabbitmq/constants'

module WorkQueues
  class Publisher < RabbitMQ::Connection
    def publish(message)
      # routing_key: routes the message to the queue matching the queue name — when using the
      # default exchange, messages are delivered to the queue whose name equals the routing key.
      # persistent: marks the message as durable so RabbitMQ writes it to disk; combined with
      # a durable queue, this ensures messages survive a broker restart.
      channel.default_exchange.publish(message, routing_key: queue.name, persistent: true)
      puts " [x] Sent #{message}"

      close_connection
    end
  end
end

if __FILE__ == $PROGRAM_NAME
  5.times do |i|
    dots = '.' * i
    WorkQueues::Publisher.new(queue_name: RabbitMQ::Constants::QUEUES[:hello]).publish("Hello World#{dots}")
  end
end
