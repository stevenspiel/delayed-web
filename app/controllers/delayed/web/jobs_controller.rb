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

      def index
        @paginator = Delayed::Web::Job.paginated_where(params[:page], nil)
        @jobs = Delayed::Web::Job.decorated(@paginator)
      end

      def scheduled_email
        where = "run_at IS NOT NULL AND handler LIKE '#{mailer_matcher}'"
        @paginator = Delayed::Web::Job.paginated_where(params[:page], where)
        @scheduled_emails = Delayed::Web::Job.decorated(@paginator)
      end

      def queued
        where = "handler NOT LIKE '#{mailer_matcher}' AND handler NOT LIKE '#{health_check_task_matcher}'"
        @paginator = Delayed::Web::Job.paginated_where(params[:page], where)
        @jobs = Delayed::Web::Job.decorated(@paginator)
      end

      def health_check
        where = "handler LIKE '#{health_check_task_matcher}'"
        @paginator = Delayed::Web::Job.paginated_where(params[:page], where)
        @jobs = Delayed::Web::Job.decorated(@paginator)
      end

      def health_check_tasks
        @tasks = ::DelayedJob::HealthCheckTask.paginate(page: params[:page], per_page: 50)
      end

      helper_method def job
        @job = Delayed::Web::Job.find params[:id]
      end

      private def mailer_matcher
        '%job_class: ActionMailer::DeliveryJob%'
      end

      private def health_check_task_matcher
        '%method_name: :eliminate_health_check_task!%'
      end
    end
  end
end
