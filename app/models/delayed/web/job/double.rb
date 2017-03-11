module Delayed
  module Web
    class Job::Double
      attr_accessor :id
      attr_accessor :created_at
      attr_accessor :run_at
      attr_accessor :to
      attr_accessor :email_type
      attr_accessor :subject
      attr_accessor :attempts
      attr_accessor :failed_at
      attr_accessor :locked_at
      attr_accessor :locked_by
      attr_accessor :last_error
      attr_accessor :handler

      def initialize attributes = {}
        @id         = attributes[:id]
        @created_at = attributes[:created_at]
        @run_at     = attributes[:run_at]
        @to         = attributes[:to]
        @email_type = attributes[:email_type]
        @subject    = attributes[:subject]
        @attempts   = attributes[:attempts]
        @failed_at  = attributes[:failed_at]
        @locked_at  = attributes[:locked_at]
        @locked_by  = attributes[:locked_by]
        @last_error = attributes[:last_error]
        @handler    = attributes[:handler]
      end

      def to_param
        id
      end

      def queue!
        true
      end

      def destroy
        self
      end

      def self.find *args
        decorate build_failed
      end

      def self.all
        [build_executing, build_failed, build_queued].map do |job|
          decorate job
        end
      end

      def self.decorate job
        StatusDecorator.new job
      end

      def self.build_executing
        new id: 1, created_at: 1.minute.ago, run_at: 1.minute.ago,
          attempts: 1, last_error: nil, locked_at: 30.seconds.ago,
          locked_by: 'host.local', handler: '---'
      end

      def self.build_failed
        new id: 2, created_at: 5.hours.ago, run_at: 2.hours.from_now,
          attempts: 4, failed_at: 1.hour.ago, last_error: 'RuntimeError: RuntimeError',
          locked_at: nil, locked_by: nil, handler: '---'
      end

      def self.build_queued
        new id: 3, created_at: 30.seconds.ago, run_at: 30.seconds.ago,
          attempts: 0, last_error: nil, locked_at: nil, locked_by: nil,
          handler: '---'
      end
    end
  end
end
