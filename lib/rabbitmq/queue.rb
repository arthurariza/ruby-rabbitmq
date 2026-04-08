module RabbitMQ
  class Queue
    def initialize(channel:)
      @channel = channel
    end

    def create_quorum_queue(queue_name)
      channel.quorum_queue(queue_name)
    end

    private

    attr_reader :channel
  end
end
