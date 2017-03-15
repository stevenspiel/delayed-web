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
        'missing'
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
