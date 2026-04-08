require 'delegate'
require_relative './queue'

module RabbitMQ
  class Channel < SimpleDelegator
    def initialize(connection:)
      super(connection.create_channel)
    end

    # Enables fair dispatch by limiting the number of unacknowledged messages
    # sent to this consumer at a time. RabbitMQ will not deliver a new message
    # until the consumer acknowledges the previous one(s), distributing work
    # evenly across all active consumers instead of round-robin.
    #
    # @param prefetch_count [Integer] max unacknowledged messages in a queue (default: 1)
    def use_fair_dispatch(prefetch_count = 1)
      prefetch(prefetch_count)

      self
    end

    def create_quorum_queue(queue_name)
      Queue.new(channel: self).create_quorum_queue(queue_name)
    end
  end
end
