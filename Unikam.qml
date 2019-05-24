import QtQuick 2.5
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
import Qt.labs.platform 1.0
import QtMultimedia 5.5
import Qt.labs.folderlistmodel 2.1
Item{
    id:r
    anchors.fill: parent
    property int mode: 0
    property bool wsActive
    onWsActiveChanged: {
        if(!wsActive){
            tcap.stop()
        }

    }
    Item{
        id:ac
        anchors.centerIn: r
        width: r.width
        height: r.height
        Button{
            text: 'Reload Camera'
            visible:r.mode===0
            onClicked: {
                camera.start()
                videoOutput.source=camera
                videoOutput.update()
            }
            anchors.centerIn: videoOutput
        }
        VideoOutput {
            id:videoOutput
            visible:r.mode===0
            source:  camera
            anchors.fill:  parent
            //focus : visible // to receive focus and capture key events when visible
            //Còdigo Ffmpeg Linux de Camara Virtual con Escritorio
            //sudo modprobe v4l2loopback
            //ffmpeg -f x11grab -r 15 -s 1280x720 -i :0.0+0,0 -vcodec rawvideo -pix_fmt yuv420p -threads 0 -f v4l2 /dev/video0
        }
        Image {
            id: screen;
            visible:r.mode===1
            width: parent.width
            height: parent.height
            fillMode: Image.PreserveAspectCrop
            property int screenFillMode: 0
            onScreenFillModeChanged: {
                if(screenFillMode===0){
                    screen.fillMode=Image.PreserveAspectCrop
                }
                if(screenFillMode===1){
                    screen.fillMode=Image.PreserveAspectFit
                }
            }
        }

        Button{
            visible: video.visible
            text: 'Load Video'
            onClicked: {
                fileDialogOpen.visible=true
            }
            anchors.centerIn: video
        }
        Video{
            id:video
            visible:r.mode===2
            width: r.width
            height: r.width/16*9
            //source: '/media/nextsigner/ZONA-A1/nsp/rec/video.mkv'
            autoLoad: true
            autoPlay: true
            volume: 0
        }
    }
    Camera {
        id:  camera

        //imageProcessing.whiteBalanceMode: whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash

        exposure {
            exposureCompensation: - -1.0
            exposureMode:  Camera.ExposurePortrait
        }
        //flash.mode: mode: Camera.FlashRedEyeReduction

    }
    Boton{
        w:app.fs
        h:w
        tp:3
        d:'ScreenCast'
        c:app.c3
        b:app.c2
        t:'\uf1eb'
        visible: Qt.platform.os!=='android'
        opacity: tcap.running?1.0:0.65
        anchors.top: r.top
        anchors.topMargin: app.fs*0.1
        anchors.right: r.right
        anchors.rightMargin: app.fs*0.1
        onClicking: {
           d=d==='Enviar'? 'Enviando' :'Enviar'
            timer.running=!timer.running
        }
        property var timer: tcap
    }
    Timer{
        id:tcap
        repeat: true
        running: false
        interval: parseInt(1000/24)
        //interval: 1000
        property int v: 0
        onTriggered: {
            //stop()
            if(r.mode===0){
                ac.grabToImage(function(result) {
                    //console.log("-->"+unik.itemToImageData(result))
                    wsSqlClient.sendCode(unik.itemToImageData(result))
                    start()
                });
            }else{
                screen.source="image://unik/"+v
                v++
                wsSqlClient.sendCode(unik.screenImageData(0))
            }
        }
    }
    FileDialog {
        id: fileDialogOpen
        folder: StandardPaths.writableLocation(StandardPaths.DocumentsLocation)
        nameFilters: ["*.mp4", "*.mov", "*.avi", "*.mpeg", "*.flv", "*.webm", "*.mkv"]
        onAccepted: {
            var fs=''+fileDialogOpen.files[0]
            var fs2=fs.replace('file://', '')
            video.source=fs2
        }
    }
}
