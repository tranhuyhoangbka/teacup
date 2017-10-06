require "aws-sdk"

class AwsPolly::Speecher
  PUBLIC_FOLDER_PATH = "#{Rails.root}/public"
  SPEECH_FOLDER_PATH = PUBLIC_FOLDER_PATH + "/speeches"

  def initialize content, file_name
    binding.pry
    FileUtils.mkdir_p(SPEECH_FOLDER_PATH) unless File.exists?(SPEECH_FOLDER_PATH)
    aws_credentials = Aws::Credentials.new ENV.fetch("AWS_ACCESS_KEY_ID"),
      ENV.fetch("AWS_SECRET_ACCESS_KEY")
    Aws.config.update({
      region: Settings.aws_polly.region,
      credentials: aws_credentials
    })
    @client = Aws::Polly::Client.new
    @content, @file_name = content, file_name
    split_phrase
  end

  def convert_to_speech
    retrieved_files = []
    final_speech_file_path = SPEECH_FOLDER_PATH +
      "/#{file_name}.mp3"
    @text_phrases.each.with_index(1) do |phrase, index|
      retrieved_files << speech_phrase(phrase, "#{file_name}_#{index}")
    end
    system "cat #{retrieved_files.join(" ")} > #{final_speech_file_path}"
    system "rm #{retrieved_files.join(" ")}"
    final_speech_file_path
  end

  private
  attr_reader :client, :content, :file_name

  def speech_phrase phrase_content, tmp_file_name
    file_path = SPEECH_FOLDER_PATH + "/#{tmp_file_name}.mp3"
    client.synthesize_speech({
      response_target: file_path,
      output_format: Settings.aws_polly.output_format,
      sample_rate: Settings.aws_polly.sample_rate,
      text: phrase_content,
      text_type: Settings.aws_polly.text_type,
      voice_id: specify_voice(phrase_content)
    })
    file_path
  end

  def split_phrase
    str = content.dup
    content.split(Settings.regex.japanese_character).map(&:strip)
      .select(&:present?).uniq.each do |sentence|
      str.gsub! sentence, ";;;#{sentence};;;"
    end
    binding.pry
    @text_phrases = str.split(";;;").select &valid_phrase
  end

  def specify_voice text_phrase
    if text_phrase.match Settings.regex.japanese_sentence
      Settings.voice_type.japanese
    else
      Settings.voice_type.english
    end
  end

  def valid_phrase
    ->phrase do
      phrase.match(Settings.regex.english) ||
        (phrase.match(Settings.regex.japanese_sentence) &&
        !phrase.match(Settings.regex.japanese_speacial_char))
    end
  end
end