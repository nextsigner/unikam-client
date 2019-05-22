import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.2
import QtQuick.Window 2.0
import Qt.labs.settings 1.0

ApplicationWindow {
    id: app
    visible: true
    width: Qt.platform.os!=='android'?parseInt(Screen.width/2):Screen.width
    height: Qt.platform.os!=='android'?Screen.desktopAvailableHeight:Screen.height
    x:Qt.platform.os!=='android'?parseInt(Screen.width/2):0
    title: app.moduleName+" by nextsigner"
    color: 'black'
    visibility:Qt.platform.os!=='android'?'Windowed':'FullScreen'
    property string moduleName: 'unikam-client'
    property int altoBarra: 0

    property int fs: appSettings.fs

    property color c1: "#62DA06"
    property color c2: "#8DF73B"
    property color c3: "black"
    property color c4: "white"

    Settings{
        id: appSettings
        category: 'conf-'+app.moduleName
        property int cantRun
        property bool fullScreen
        property bool logViewVisible
        property int fs
        property int lvh
    }

    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}

    Item{
        id:xApp
        width: app.width
        height: app.height
        anchors.centerIn: parent
        Unikam{
            id:unikam
            anchors.fill: parent
        }
        WsClient{
            id:wsClient
            onLoguinSucess: {
                focus=false
                visible=false
            }
            onErrorSucess: {
                console.log('WebSockets Error success...')
                focus=true
                visible=true
            }
            onVisibleChanged: {
                if(!visible){
                    focus=false
                }else{
                    //unikTextEditor.visible=true
                }
            }
        }
        LogView{
            width: parent.width
            height: appSettings.lvh
            fontSize: app.fs
            topHandlerHeight: Qt.platform.os!=='android'?app.fs*0.25:app.fs*0.75
            showUnikControls: true
            anchors.bottom: parent.bottom
            visible: appSettings.logViewVisible
        }
        Xm{id: xM; area: unikam.mode;onAreaChanged: unikam.mode=area;}
        UnikBusy{id:ub;running: false}
    }
    Shortcut {
        sequence: "Shift+Left"
        onActivated: {

        }
    }
    Shortcut {
        sequence: "Shift+Return"
        onActivated: {
            if(app.visibility!==Window.Maximized){
                app.visibility='Maximized'
            }else{
                app.visibility='Windowed'
            }
        }
    }
    Shortcut {
        sequence: "Ctrl+Shift+q"
        onActivated: {
            Qt.quit()
        }
    }
    Component.onCompleted: {
        var ukldata='-folder='+appsDir+'/'+app.moduleName
        var ukl=appsDir+'/link_'+app.moduleName+'.ukl'
        unik.setFile(ukl, ukldata)
        if(appSettings.lvh<=0){
            appSettings.lvh=100
        }
        if(appSettings.fs<=0){
            appSettings.fs=20
        }
        appSettings.logViewVisible=true
        if(Qt.platform.os==='windows'){
            var anchoBorde=(unik.frameWidth(app)-app.width)/2
            var anBarraTitulo=(unik.frameHeight(app)-app.height)-anchoBorde
            altoBarra=anBarraTitulo
            app.y=altoBarra
            app.height-=altoBarra
        }
    }
}

