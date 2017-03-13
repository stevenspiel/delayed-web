module Delayed
  module Web
    class NotFoundDecorator < SimpleDelegator
      include Delayed::Web::MailerDecorator

      def queue!
        false
      end

      def subject
        'NOT FOUND'
      end

      def status
        'failed'
      end

      def can_destroy?
        false
      end

      def can_queue?
        false
      end

      def last_error
        true
      end
    end
  end
end
