import QtQuick 2.5
import QtQuick.Controls 2.0
import QtMultimedia 5.9

Item{
    id:r
    anchors.fill: parent
    property int mode: 0
    Item{
        id:ac
        anchors.centerIn: r
        width: r.width
        height: r.height
        Camera {
            id:  camera
            imageCapture {
                onImageCaptured: {
                    // Show the preview in an Image
                    //photoPreview.source = preview
                    //wsSqlClient.sendCode(unik.imageCameraCapturaToByteArray(preview))
                    //console.log('1--::>'+preview)
                    //console.log('2--::>'+requestId)
                    //console.log('3--::>'+capturedImagePath)

                    //console.log('--::>'+unik.imageCameraCapturaToByteArray(preview))
                    //camera.
                }
            }
            //imageProcessing.whiteBalanceMode: whiteBalanceMode: CameraImageProcessing.WhiteBalanceFlash
            exposure {
                //exposureCompensation: - -1.0
                //exposureMode:  Camera.ExposurePortrait
            }
            //flash.mode: mode: Camera.FlashRedEyeReduction
        }
        VideoOutput {
            enabled: r.mode===0
            visible:r.mode===0
            id:videoOutput
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

    Button{
        text: 'Enviar'
        onClicked: {
            //camera.imageCapture.capture();
            timer.running=!timer.running
            text=timer.running? 'Enviando' :'Enviar'
        }
        property var timer: tcap
        anchors.top: r.top
        anchors.topMargin: app.fs*0.1
        anchors.right: r.right
        anchors.rightMargin: app.fs*0.1
    }
    Timer{
        id:tcap
        repeat: true
        running: false
        interval: parseInt(1000/24)
        //interval: 1000
        property int v: 0
        onTriggered: {
            stop()
            if(r.mode===0){
                ac.grabToImage(function(result) {
                    wsSqlClient.sendCode(unik.itemToImageData(result))
                    start()
                });
            }else if(r.mode===1){
                ac.grabToImage(function(result) {
                    //console.log("-->"+unik.itemToImageData(result))
                    screen.source="image://unik/"+v
                    v++
                    start()
                });
            }else{
                wsSqlClient.sendCode(unik.screenImageData(0))
            }
        }
    }
    Timer{
        id:tSendAudioStream
        repeat: true
        running: false
        interval: 1000
        property int v: 0
        onTriggered: {
            audioRecorder.toggleRecord()
            sendAudioStream(v)
            v++
            if(v===0){
                //sendAudioStream()
            }
        }
    }
    property int uFileSize: 0
    Connections{
        target: audioRecorder
        onRecorded:{
            //sender.fileName=audioFile
        }
    }
    Timer{
        id: sender
        running: fileName!==''
        repeat: true
        interval: 1000
        property string fileName: ''
        onTriggered: {
            if(unik.fileExist(fileName)){

            }
        }
    }
    /*FolderListModel{
        id: fl
        folder: "file:///tmp/"
        showDirs: false
        showHidden: false
        showOnlyReadable: true
        nameFilters: "*.ogg"
        sortField: FolderListModel.Time
        onCountChanged: {
            var f="/tmp/"+fl.get(fl.count-1, "fileName")
            if(f.indexOf('--')>0){
                return
            }
            unik.log('Sending: '+f)
            var data=''+unik.sendAudioStreamWSS(f, 1024)
            unik.debugLog=true
            //unik.log('Sending: '+data)
            wsSqlClient.sendAudioStream(data)
            //unik.log()
        }
    }*/
    function sendAudioStream(v){

    }
}
