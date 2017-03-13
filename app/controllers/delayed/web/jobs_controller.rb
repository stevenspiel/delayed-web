module Delayed
  module Web
    class JobsController < Delayed::Web::ApplicationController
      def queue
        if job.can_queue?
          job.queue!
          flash[:notice] = t(:notice, scope: 'delayed/web.flashes.jobs.queued')
        else
          status = t(job.status, scope: 'delayed/web.views.statuses')
          flash[:alert] = t(:alert, scope: 'delayed/web.flashes.jobs.queued', status: status)
        end
        redirect_to :back
      end

      def destroy
        if job.can_destroy?
          job.destroy
          flash[:notice] = t(:notice, scope: 'delayed/web.flashes.jobs.destroyed')
        else
          status = t(job.status, scope: 'delayed/web.views.statuses')
          flash[:alert] = t(:alert, scope: 'delayed/web.flashes.jobs.destroyed', status: status)
        end
        redirect_to :back
      end

      def scheduled_email
        where = "run_at IS NOT NULL AND handler LIKE '%job_class: ActionMailer::DeliveryJob%'"
        @paginator = Delayed::Web::Job.paginated_where(params[:page], where)
        @scheduled_emails = Delayed::Web::Job.decorated(@paginator)
      end

      def queued
        where = 'run_at IS NULL'
        @paginator = Delayed::Web::Job.paginated_where(params[:page], where)
        @jobs = Delayed::Web::Job.decorated(@paginator)
      end

      def job
        @job = Delayed::Web::Job.find params[:id]
      end
      helper_method :job
    end
  end
end
