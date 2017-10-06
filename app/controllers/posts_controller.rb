class PostsController < ApplicationController
  before_action :load_post

  def show
    check_desc_speech_file
  end

  private
  def load_post
    @post = Post.find params[:id]
  end

  def check_desc_speech_file
      speech_file_name = Settings.speech_file.speech_file_name % @post.id.to_s
      @desc_speech_file = Dir.glob("#{AwsPolly::Speecher::SPEECH_FOLDER_PATH}/#{speech_file_name}").first
      return @desc_speech_file if @desc_speech_file
      desc = @post.content.dup
      binding.pry
      speecher = AwsPolly::Speecher.new desc,
        (Settings.speech_file.name_prefix % @post.id.to_s)
      @desc_speech_file = speecher.convert_to_speech
    end
end
