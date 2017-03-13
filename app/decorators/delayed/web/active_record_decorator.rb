module Delayed
  module Web
    class ActiveRecordDecorator < SimpleDelegator
      include Delayed::Web::MailerDecorator

      def queue!(now = Time.current)
        update_attributes! run_at: now, failed_at: nil, last_error: nil
      end

      def subject
        format_obj(Delayed::Web::Decorator.get_obj(handler))
      end
    end
  end
end
