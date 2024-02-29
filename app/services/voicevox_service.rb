class VoicevoxService
  include HTTParty
  # base_uriは、HTTParty gemを使用するクラスメソッドで、このサービスクラスがリクエストを送信する際の基本となるURLを設定
  base_uri 'http://localhost:50021'

  # テキストを受け取り、指定された文字で分割して、各セグメントの音声データをストリーミングする
  def self.text_to_speech_stream(text, speaker_id)
    # テキストを「、」や「。」で分割
    segments = text.split(/(?<=[、。])/)

    Enumerator.new do |y|
      segments.each do |segment|
        next if segment.blank?
        # audio_queryのエンドポイントにPOSTリクエストを送信する
        # CGI.escapeメソッドは、URLに含めるテキスト文字列を安全にエスケープするために使用される。
        # 各セグメントに対して音声合成を行い、結果をストリーミング
        query_response = post("/audio_query?text=#{CGI.escape(segment)}&speaker=#{speaker_id}")
        next unless query_response.code == 200

        synthesis_response = post("/synthesis?speaker=#{speaker_id}", body: query_response.body, headers: { 'Content-Type' => 'application/json' })
        next unless synthesis_response.code == 200

        # ストリーミングのためにチャンクをイテレータに渡す
        y.yield synthesis_response.body
      end
    end
  end
end
