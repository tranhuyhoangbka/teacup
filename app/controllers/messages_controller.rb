class MessagesController < ApplicationController
  before_action :authenticate_user!

  def index
    @messages = Message.all
  end

  def create
    @message = current_user.messages.build message_params
    @message.save
    ActionCable.server.broadcast "messages", render(
      partial: "messages/message",
      object: @message
    )
  end

  private
  def message_params
    params.require(:message).permit :body
  end
end
