class ResetPasswordMailWorker
  include Sidekiq::Worker

  def perform user_id
    user = User.find_by_id user_id
    return unless user
    user.send_reset_password_instructions
  end
end