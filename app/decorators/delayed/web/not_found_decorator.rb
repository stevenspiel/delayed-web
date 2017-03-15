module Delayed
  module Web
    class NotFoundDecorator < SimpleDelegator
      include Delayed::Web::MailerDecorator

      def queue!
        false
      end

      def subject
        "NOT FOUND (#{subject_id})"
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

      private def subject_id
        attributes['handler'].split('/LeaseApplicant/').last.match(/\d+/).to_s
      end
    end
  end
end
