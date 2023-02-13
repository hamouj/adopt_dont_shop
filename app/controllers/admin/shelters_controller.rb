class Admin::SheltersController < Admin::BaseController
  def index
    @shelters_pending_applications = Shelter.pending_applications 
    @shelters = Shelter.sort_alphabetically_descending
  end
end