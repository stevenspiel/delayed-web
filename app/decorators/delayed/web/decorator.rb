module Delayed
  module Web
    class Decorator
      def self.get_obj(handler)
        parts = handler[:arguments].last.values[0].split('/')
        main_app_class, id = parts.last(2)
        "::#{main_app_class}".constantize.find_by(id: id)
      end

      def initialize(job)
        @job = job
      end

      # for the link_to
      def to_param
        @job.id
      end

      def decorator
        # Job might be for object that does not exist yet/anymore
        @decorator ||= (non_email_job? || get_obj) ?
          Delayed::Web::ActiveRecordDecorator.new(@job) :
          Delayed::Web::NotFoundDecorator.new(@job)
      end

      private

      def method_missing(method, *args, &block)
        decorator.send(method, *args, &block)
      end

      def respond_to_missing?(method_name, include_private = false)
        decorator.respond_to?(method_name) || super
      end

      def handler
        @handler ||= YAML.load(@job.handler).job_data.with_indifferent_access
      end

      def non_email_job?
        !(@job.handler.match('job_class: ActionMailer::DeliveryJob'))
      end

      def get_obj
        self.class.get_obj(handler)
      end
    end
  end
end
