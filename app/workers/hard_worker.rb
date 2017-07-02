class HardWorker
  include Sidekiq::Worker

  def perform
    admin = Admin.first
    admin.posts.create title: "new post", content: "description"
  end
end
