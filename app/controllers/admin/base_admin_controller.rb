class Admin::BaseAdminController < ApplicationController

  before_action :authenticate_admin!

  protect_from_forgery

  layout "admin/base"

  protected
  def authenticate_admin!
    if admin_signed_in?
      super
    else
      store_location_for(:admin, request.url)
      redirect_to admin_session_url, :notice => 'if you want to add a notice'
      ## if you want render 404 page
      ## render :file => File.join(Rails.root, 'public/404'), :formats => [:html], :status => 404, :layout => false
    end
  end

end
