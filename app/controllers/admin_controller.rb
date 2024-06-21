class AdminController < ApplicationController
  before_action :is_user_authorized

  def audits
    if current_user.manager?
      @organisation_audits = Audited::Audit.where(user_id: current_user.organisation.users.pluck(:id))
    else
      @organisation_audits = Audited::Audit.where(user_id: current_user.id)
    end
    @audits = @organisation_audits.order("id DESC")
    @types  = @organisation_audits.pluck(:auditable_type).uniq.sort
    @actions= %w[update create destroy]
    @users = current_user.organisation.users.ordered 

    if params[:search].present?
      @audits = @audits.where("audited_changes ILIKE ?", "%#{params[:search]}%")
    end

    if params[:start_date].present? && params[:end_date].present? 
      @audits = @audits.where("created_at BETWEEN (?) AND (?)", params[:start_date], params[:end_date])
    end

    if params[:user_id].present?
      @audits = @audits.where(user_id: params[:user_id])
    end

    if params[:type].present?
      @audits = @audits.where(auditable_type: params[:type])
    end

    if params[:action_name].present?
      @audits = @audits.where(action: params[:action_name])
    end

    @pagy, @audits = pagy(@audits)
  end

  def create_new_user
    @user = User.new
  end

  def create_new_user_do
    @user = User.new(params.require(:user).permit(:nom, :prénom, :email, :password, :rôle, :service))
    @user.organisation = current_user.organisation

    respond_to do |format|
      if @user.save
        format.html { redirect_to users_url, notice: "Participant créé avec succès." }
        format.json { render :show, status: :created, location: @user }
      else
        format.html { render :create_new_user, status: :unprocessable_entity }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  private

  def is_user_authorized
    authorize :admin
  end
end
