class Admin::SheltersController < Admin::BaseController
  def index
    @shelters_pending_applications = Shelter.pending_applications 
  end
end