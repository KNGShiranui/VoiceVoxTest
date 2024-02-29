// Configure your import map in config/importmap.rb. Read more: https://github.com/rails/importmap-rails
import "@hotwired/turbo-rails"
import "controllers"

document.addEventListener('DOMContentLoaded', function() {
    const audioPlayButton = document.getElementById('audio-play-button'); // 再生ボタンのIDを適宜設定
    audioPlayButton.addEventListener('click', function() {
        const audioContext = new (window.AudioContext || window.webkitAudioContext)();
        const source = audioContext.createBufferSource();

        fetch('<%= audio_stream_path(@blog) %>')
            .then(response => {
                if (!response.body) {
                    throw new Error('Your browser does not support ReadableStream...');
                }
                const reader = response.body.getReader();
                return new ReadableStream({
                    start(controller) {
                        function push() {
                            reader.read().then(({ done, value }) => {
                                if (done) {
                                    controller.close();
                                    return;
                                }
                                // ここで取得したvalue（音声データのチャンク）をAudioContextで再生
                                // 注意: 実際にはvalueを直接AudioContextに渡すのではなく、適切に処理する必要があります。
                                controller.enqueue(value);
                                push();
                            });
                        }
                        push();
                    }
                });
            })
            .then(stream => new Response(stream))
            .then(response => response.blob())
            .then(blob => createAudioElement(blob))
            .catch(err => console.error(err));
    });

    function createAudioElement(blob) {
        const url = URL.createObjectURL(blob);
        const audio = new Audio(url);
        audio.play();
    }
});

