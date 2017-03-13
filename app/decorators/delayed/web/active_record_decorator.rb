module Delayed
  module Web
    class ActiveRecordDecorator < SimpleDelegator
      def queue! now = Time.current
        update_attributes! run_at: now, failed_at: nil, last_error: nil
      end

      def subject
        format_obj(get_obj(handler[:arguments].last.values[0]))
      end

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

      def get_obj(string)
        parts = string.split('/')
        main_app_class, id = parts.last(2)
        "::#{main_app_class}".constantize.find(id)
      end

      def format_obj(obj)
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
