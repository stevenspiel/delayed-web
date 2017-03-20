module Delayed
  module Web
    module ApplicationHelper
      def flash_dom_class flash_type
        case flash_type.to_s
        when 'notice' then 'alert-success'
        when 'alert'  then 'alert-error'
        else               'alert-info'
        end
      end

      def dt(date)
        l(date.to_datetime.in_time_zone('Pacific Time (US & Canada)'), format: :short)
      rescue ArgumentError, NoMethodError
        ''
      end

      def execution_class(datetime)
        return unless datetime.present?

        hours_until_execution = (datetime - Time.now.utc) / 1.hour
        infinity = 1.0 / 0.0

        case hours_until_execution
        when -infinity..0 then 'immediately'
        when 0..24        then 'soon'
        when 24..infinity then ''
        end
      end
    end
  end
end
