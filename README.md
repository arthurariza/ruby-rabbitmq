# RabbitMQ Ruby Tutorials

This repository follows the official [RabbitMQ tutorials](https://www.rabbitmq.com/tutorials) implemented in Ruby using the [Bunny](https://github.com/ruby-amqp/bunny) gem.

## Tutorials covered

- **Hello World** (`lib/hello_world/`) — send and receive a single message
- **Work Queues** (`lib/work_queues/`) — distribute tasks across multiple workers with fair dispatch and message acknowledgement

## Requirements

- RabbitMQ running locally on the default port (`5672`)
- Ruby with Bundler

```sh
bundle install
```

## Running RabbitMQ with Docker

```sh
docker run --detach --hostname rabbitmq --name rabbitmq \
    --env RABBITMQ_DEFAULT_USER=user \
    --env RABBITMQ_DEFAULT_PASS=password \
    --publish 15672:15672 \
    --publish 5672:5672 \
    rabbitmq:management-alpine
```

The management UI will be available at [http://localhost:15672](http://localhost:15672) (user: `user`, password: `password`).

## Usage

### Hello World

```sh
ruby lib/hello_world/receive.rb
ruby lib/hello_world/send.rb
```

### Work Queues

```sh
ruby lib/work_queues/worker.rb     # start one or more workers
ruby lib/work_queues/publisher.rb  # publish messages
```
