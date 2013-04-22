class RegistrationsController < Devise::RegistrationsController
  skip_before_filter :authenticate_user!

  def new
    @user = User.new
  end

  def create
    build_resource

    if resource.save
      set_flash_message :notice, :signed_up if is_navigational_format?
      sign_in(resource_name, resource)
      respond_with resource, :location => after_sign_up_path_for(resource)
    else
      clean_up_passwords resource
      respond_with resource
    end
  end
end
