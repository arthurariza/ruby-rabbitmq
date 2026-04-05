# frozen_string_literal: true

require './lib/rabbitmq/connection'
require './lib/rabbitmq/constants'

module WorkQueues
  class Worker < RabbitMQ::Connection
    def initialize(queue_name:)
      super(queue_name:)

      use_fair_dispatch
    end

    def perform_work
      # manual_ack: true disables automatic acknowledgement — RabbitMQ will not remove the
      # message from the queue until we explicitly ack it. This prevents message loss if the
      # worker crashes mid-processing; RabbitMQ will re-queue the message and deliver it to
      # another worker instead.
      queue.subscribe(manual_ack: true, block: true) do |delivery_info, _properties, body|
        puts " [x] Received #{body}"
        # imitate some work
        sleep rand(body.count('.').to_i) + 1
        puts ' [x] Done'

        # Acknowledge the message using its unique delivery tag, signalling to RabbitMQ that
        # the message was successfully processed and can be removed from the queue.
        channel.ack(delivery_info.delivery_tag)
      end
    end
  end
end

WorkQueues::Worker.new(queue_name: RabbitMQ::Constants::QUEUES[:hello]).perform_work if __FILE__ == $PROGRAM_NAME
