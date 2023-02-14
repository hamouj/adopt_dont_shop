class Admin::ApplicationsController < Admin::BaseController
  def show
    @application = Application.find(params[:id])
    @full_address = "#{@application.street_address} #{@application.city}, #{@application.state} #{@application.zip_code}"
  end

  def update
    application = Application.find(params[:id])
    pet = Pet.find(params[:pet_id])
    application_pet = pet.find_application_pet(application.id)
    application_pet.update(approved: true)

    redirect_to "/admin/applications/#{application.id}"
  end
end