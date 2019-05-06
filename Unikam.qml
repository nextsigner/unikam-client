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
        source: '/home/nextsigner/BigBuckBunny.mp4'
        autoLoad: true
        autoPlay: true
        onStateChanged: {
            if(state===MediaPlayer.PlayingState){
                sendAudioStream()
            }
        }
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
        running: true
        interval: 1000
        onTriggered: {
            sendAudioStream()
        }
    }
    property int uFileSize: 0
    function sendAudioStream(){
        var data=''+unik.sendAudioStreamWSS('/tmp/stream.ogg', 1024)
        wsSqlClient.sendAudioStream(data)
    }
}
