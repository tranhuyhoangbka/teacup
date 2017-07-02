class HardWorker
  include Sidekiq::Worker

  def perform
    puts "#{Time.now}"
  end
end
