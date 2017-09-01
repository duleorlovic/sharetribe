# encoding: utf-8
class Admin::EmailsController < Admin::AdminBaseController
  def new
    @selected_tribe_navi_tab = "admin"
    @selected_left_navi_link = "email_members"
  end

  def create
    content = params[:email][:content].gsub(/[”“]/, '"') if params[:email][:content] # Fix UTF-8 quotation marks
    email_job = CreateMemberEmailBatchJob.new(@current_user.id, @current_community.id, params[:email][:subject], content, params[:email][:locale], params[:email][:recipients])
    Delayed::Job.enqueue(email_job)
    flash[:notice] = t("admin.emails.new.email_sent")
    redirect_to :action => :new
  end

  protected

  ADMIN_EMAIL_OPTIONS = [:all_users, :admins, :with_listing, :with_listing_no_payment, :with_payment_no_listing, :no_listing_no_payment, :customers]

  def admin_email_options
    ADMIN_EMAIL_OPTIONS.map{|option| [I18n.t("admin.emails.new.recipients.options.#{option}"), option] }
  end

  helper_method :admin_email_options
end
