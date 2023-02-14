class Admin::ApplicationsController < Admin::BaseController
  def show
    @application = Application.find(params[:id])
    @full_address = "#{@application.street_address} #{@application.city}, #{@application.state} #{@application.zip_code}"
    if params[:application_pet_id]
      # approved_pet = Pet.find(params[:pet])

      @application_pet = ApplicationPet.find(params[:application_pet_id])
    end
  end

  def update
    # approved_pet = Pet.find(params[:pet_id])
    application = Application.find(params[:id])
    application_pet = ApplicationPet.find_record(params[:id], params[:pet_id])

    application_pet.update(approved: true)
    redirect_to "/admin/applications/#{application.id}/?application_pet_id=#{application_pet.id}"
  end
end