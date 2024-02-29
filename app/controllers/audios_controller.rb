class AudiosController < ApplicationController
  include ActionController::Live
  def stream
    response.headers['Content-Type'] = 'audio/mpeg'
    # 仮のメソッド呼び出し（実際にはVoicevoxServiceに合わせて調整が必要）
    blog = Blog.find(params[:id])
    voice_data_stream = VoicevoxService.text_to_speech_stream(blog.content, 3)

    voice_data_stream.each do |chunk|
      response.stream.write(chunk)
    end
  ensure
    response.stream.close
  end
end
