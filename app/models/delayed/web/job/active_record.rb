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

      def self.decorated(decoratables)
        Enumerator.new do |enumerator|
          decoratables.each do |decoratable|
            enumerator.yield decorate(decoratable)
          end
        end
      end

      def self.paginated_where(page, where, per_page = 50)
        Delayed::Job.paginate(page: page, per_page: per_page).where(where).order('id DESC')
      end

      def self.decorate job
        job = StatusDecorator.new job
        job = ActiveRecordDecorator.new job
        job
      end
    end
  end
end
