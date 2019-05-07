import QtQuick 2.5
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import QtMultimedia 5.5
Item{
    id:r
    anchors.fill: parent
    Video{
        width: r.width
        height: r.height
        source: '/media/nextsigner/ZONA-A1/nsp/rec/video.mkv'
        autoLoad: true
        autoPlay: true
        onStateChanged: {
            if(state===MediaPlayer.PlayingState){
                sendAudioStream()
            }
        }
       // volume: 0.1
    }
    /*Camera {
        id:  camera

        //imageProcessing.whiteBalanceMode: whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: - -1.0
            exposureMode:  Camera.ExposurePortrait
        }
        //flash.mode: mode: Camera.FlashRedEyeReduction

    }

    VideoOutput {
        source:  camera
        anchors.fill:  r
        //focus : visible // to receive focus and capture key events when visible
    }*/
    /*Image{
      anchors.fill: r
      anchors.centerIn: r
      source: '/home/nextsigner/Descargas/gatita.jpg'
    }*/
    MouseArea{
        anchors.fill: r
        onClicked: {
            //tcap.running=!tcap.running
            /*r.grabToImage(function(result) {
                wsSqlClient.sendCode(unik.itemToImageData(result))
            });*/
        }
    }
    Button{
        text: tSendAudioStream.running? 'Grabando' :'Enviar Audio'
        onClicked: tSendAudioStream.running=!tSendAudioStream.running
        anchors.centerIn: r
    }
    Timer{
       id:tcap
        repeat: true
        running: true
        interval: parseInt(1000/64)
        onTriggered: {
            stop()
            r.grabToImage(function(result) {
                wsSqlClient.sendCode(unik.itemToImageData(result))
                start()
            });
        }
    }
    Timer{
       id:tSendAudioStream
        repeat: true
        running: false
        interval: 4000
        onTriggered: {
            audioRecorder.toggleRecord()
            tStartRecordAudio
            //sendAudioStream()
        }
    }
    Timer{
       id:tStartRecordAudio
        repeat: false
        running: false
        interval: 1
        onTriggered: {
            audioRecorder.toggleRecord()
        }
    }
    property int uFileSize: 0
    function sendAudioStream(){
        var data=''+unik.sendAudioStreamWSS('/tmp/stream.ogg', 1024)
        wsSqlClient.sendAudioStream(data)
    }
}
