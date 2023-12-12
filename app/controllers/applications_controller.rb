class ApplicationsController < ApplicationController
  def index

  end

  def new

  end

  def create
    @application = Application.new(application_params)
    @application.set_status_in_progress
    if @application.save
      redirect_to "/applications/#{@application.id}"
    else
      flash[:alert] = "Error: All fields are required."
      redirect_to new_application_path
    end
  end

  def edit

  end

  def update
    application = Application.find(params[:id])
    if params[:good_owner_comments].present?
      application.update(
        good_owner_comments: [params[:good_owner_comments]],
        status: "Pending"
      )
    end

    redirect_to show_application_path
  end

  def show
    @application = Application.find(params[:id])
  end

  def destroy

  end

  private
  def application_params
    params.permit(
      :name,
      :street_address,
      :city,
      :state,
      :zipcode,
      :description,
      :good_owner_comments,
      status: "In Progress") # is it best practice to hard code this or is there a better way to do this?
  end
end
