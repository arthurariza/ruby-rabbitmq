# frozen_string_literal: true

require 'bunny'

module RabbitMQ
  class Connection
    def initialize(queue_name:,
                   bunny_instance: Bunny.new(automatically_recover: false, username: 'user', password: 'password'))
      @connection = bunny_instance
      @connection.start
      @channel = connection.create_channel
      @queue = channel.quorum_queue(queue_name)
    end

    def close_connection = connection.close

    # Enables fair dispatch by limiting the number of unacknowledged messages
    # sent to this consumer at a time. RabbitMQ will not deliver a new message
    # until the consumer acknowledges the previous one(s), distributing work
    # evenly across all active consumers instead of round-robin.
    #
    # @param prefetch_count [Integer] max unacknowledged messages in a queue (default: 1)
    def use_fair_dispatch(prefetch_count = 1) = channel.prefetch(prefetch_count)

    private

    attr_reader :connection, :channel, :queue
  end
end
