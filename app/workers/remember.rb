class Remember
  include Sidekiq::Worker

  def perform
    admin = Admin.first
    admin.posts.create title: "xxxxxxxx", content: "description"
  end
end
