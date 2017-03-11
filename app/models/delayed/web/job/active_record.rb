module Delayed
  module Web
    class Job::ActiveRecord
      def self.find *args
        decorate Delayed::Job.find(*args)
      end

      def self.all
        jobs = Delayed::Job.order('id DESC').limit(100)
        Enumerator.new do |enumerator|
          jobs.each do |job|
            enumerator.yield decorate(job)
          end
        end
      end

      def self.where(*args)
        jobs = Delayed::Job.where(args).order('id DESC').limit(100)
        Enumerator.new do |enumerator|
          jobs.each do |job|
            enumerator.yield decorate(job)
          end
        end
      end

      def self.decorate job
        job = StatusDecorator.new job
        job = ActiveRecordDecorator.new job
        job
      end
    end
  end
end
