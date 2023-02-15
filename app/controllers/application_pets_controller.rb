class ApplicationPetsController < ApplicationController
  def create
    @application = Application.find(params[:application_id])
    mypet = Pet.find(params[:mypet])
    ApplicationPet.create!(application: @application, pet: mypet)

    redirect_to "/applications/#{@application.id}"
  end
end