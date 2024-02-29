class VoicevoxService
  include HTTParty
  # base_uriは、HTTParty gemを使用するクラスメソッドで、このサービスクラスがリクエストを送信する際の基本となるURLを設定
  base_uri 'http://localhost:50021'

  def self.text_to_speech(text, speaker_id)
    # audio_queryのエンドポイントにPOSTリクエストを送信する
    # CGI.escapeメソッドは、URLに含めるテキスト文字列を安全にエスケープするために使用される。
    query_response = post("/audio_query?text=#{CGI.escape(text)}&speaker=#{speaker_id}")

    # ステータスコードが200以外の場合は、エラーログを出力してnilを返す
    unless query_response.code == 200
      Rails.logger.error "VOICEVOX audio_query error: #{query_response}"
      return nil
    end

    # synthesisのエンドポイントにPOSTリクエストを送信する
    # query_responseのボディをそのままsynthesisに渡す
    synthesis_response = post("/synthesis?speaker=#{speaker_id}", body: query_response.body, headers: { 'Content-Type' => 'application/json' })

    # ステータスコードが200以外の場合は、エラーログを出力してnilを返す
    unless synthesis_response.code == 200
      Rails.logger.error "VOICEVOX synthesis error: #{synthesis_response}"
      return nil
    end

    # synthesisのレスポンスボディ（音声データ）を返す
    synthesis_response.body
  end
end
