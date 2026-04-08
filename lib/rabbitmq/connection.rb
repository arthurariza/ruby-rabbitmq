# frozen_string_literal: true

require 'bunny'
require 'delegate'
require_relative './channel'

module RabbitMQ
  class Connection < SimpleDelegator
    def initialize(
      bunny_instance: Bunny.new(automatically_recover: false, username: 'user', password: 'password')
    )
      super(bunny_instance)
    end

    def connect
      start

      yield
    ensure
      close
    end

    def make_channel
      Channel.new(connection: self)
    end
  end
end
