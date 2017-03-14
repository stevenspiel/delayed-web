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
    end
  end
end
