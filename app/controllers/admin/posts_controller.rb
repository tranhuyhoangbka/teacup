class Admin::PostsController < Admin::BaseAdminController
  def index
    @posts = current_admin.posts
  end
end