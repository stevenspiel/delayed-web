module Delayed
  module Web
    class TaskJobDecorator
      def initialize(task)
        @task = task
      end

      def method_missing(method, *args, &block)
        decorator.send(method, *args, &block)
      end

      def respond_to_missing?(method_name, _include_private = false)
        decorator.respond_to?(method_name) || super
      end

      def decorator
        @decorator ||= @task.job.present? ?
          Delayed::Web::Decorator.new(Delayed::Web::StatusDecorator.new(@task.job)) :
          OpenStruct.new(status: 'failed', last_error: '')
      end
    end
  end
end
