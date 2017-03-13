module Delayed
  module Web
    module MailerDecorator
      def to
        handler[:arguments][0].split('::').first.gsub('To', '')
      end

      def email_type
        "#{mailer} #{method}"
      end

      private

      def handler
        YAML.load(self[:handler]).job_data.with_indifferent_access
      end

      def format_obj(obj)
        return 'RECORD NOT FOUND' unless obj.present?
        "#{obj} (#{obj.id}) <br>#{obj.try(:email)}".html_safe
      end

      def mailer
        handler[:arguments][0].split('::').last.gsub('Mailer', '')
      end

      def method
        handler[:arguments][1].humanize.downcase
      end
    end
  end
end
