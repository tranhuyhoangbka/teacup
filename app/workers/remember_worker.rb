class RememberWorker
  include Sidekiq::Worker

  def perform
    admin = Admin.first
    admin.posts.create title: "xxxxxxxx", content: "description"
    puts "----****** Test Me *****---------"
  end
end
