import QtQuick 2.0

Item{
    id:r
    width: app.fs*2
    height: parent.height
    property int botSize: Qt.platform.os==='android'?app.fs*2:app.fs
    property int area
    signal pressed

    Item{
        id:xBM
        width: xM.botSize
        height: width
        anchors.top: parent.top
        anchors.topMargin: app.fs*0.1
        anchors.left: parent.left
        anchors.leftMargin: xM.botSize*0.1
        opacity: 0.3
        Behavior on opacity{NumberAnimation{duration:750}}
        Timer{
            running: xBM.opacity<1.0
            repeat: false
            interval: 5000
            onTriggered: xBM.opacity=0.3
        }
        Boton{
            w:xM.botSize
            h:w
            tp:3
            d:'Menu'
            c:app.c3
            b:app.c2
            t:'\uf142'
        }
        MouseArea{
            anchors.fill: parent
            hoverEnabled: true
            onEntered:{
                xBM.opacity=1.0
                r2.opacity=1.0
            }
            onClicked: {
                xBM.opacity=1.0
                r2.opacity=xM.opacity===0.0?1.0:0.0
            }
        }
    }

    Item{
        id: r2
        anchors.fill: r
        x:opacity!==0.0?app.fs*0.25:0-width
        anchors.verticalCenter: parent.verticalCenter
        opacity:0.0
        enabled:r2.opacity>0.0
        Behavior on opacity{NumberAnimation{duration:250}}
        Behavior on x{NumberAnimation{duration:250}}
        onOpacityChanged: {
            if(opacity===1.0){
                trb2.restart()
            }
        }
        Timer{
            id:trb2
            running: false
            repeat: true
            interval: 5000
            onRunningChanged: {
                if(running){
                    r2.opacity=1.0
                }
            }
            onTriggered: {
                r2.opacity=0.0
            }
        }
        Rectangle{
            width: r2.width*2
            height: r2.height+app.fs
            color: app.c3
            opacity: 0.5
            anchors.verticalCenter: r2.verticalCenter
            anchors.right: r2.right
            anchors.rightMargin: 0-app.fs*0.5
        }
        MouseArea{
            anchors.fill: r2
            enabled: r2.opacity===1.0
            hoverEnabled: true
            onEntered: r2.opacity=1.0
            onPositionChanged: trb2.restart()
        }
        Column{
            id:colbots
            anchors.centerIn: parent
            spacing: app.fs*0.5
            Boton{
                w:r.botSize
                h:w
                tp:0
                d:'Conectar'
                c:app.c3
                b:app.c2
                t:'\uf0c1'
                opacity: wsClient.conected?1.0:0.65
               // visible:app.mod===0&&app.s===1?false:true
                onClicking: {
                    r.pressed()
                    trb2.restart()
                    wsClient.swichConnect()
                }
            }
            Boton{
                w:r.botSize
                h:w
                tp:0
                d:'Camara'
                c:app.c3
                b:app.c2
                t:'\uf030'
                opacity: r.area===0?1.0:0.65
               // visible:app.mod===0&&app.s===1?false:true
                onClicking: {
                    r.pressed()
                    trb2.restart()
                    r.area=0
                }
            }
            Boton{
                w:r.botSize
                h:w
                tp:0
                d:'Video'
                c:app.c3
                b:app.c2
                t:'\uf03d'
                opacity: r.area===1?1.0:0.65
                onClicking: {
                    r.pressed()
                    trb2.restart()
                    r.area=1
                }
            }
            Boton{
                w:r.botSize
                h:w
                tp:0
                d:'ScreenCast'
                c:app.c3
                b:app.c2
                t:'\uf108'
                visible: Qt.platform.os!=='android'
                opacity: r.area===2?1.0:0.65
                onClicking: {
                    r.pressed()
                    trb2.restart()
                    r.area=2
                }
            }
            Boton{
                w:r.botSize
                h:w
                tp:0
                d:'Confugurar'
                c:app.c3
                b:app.c2
                t:'\uf013'
                visible: false
                onClicking: {
                    r.pressed()
                    //xC.visible=!xC.visible
                    trb2.restart()
                }
            }
            Boton{
                w:r.botSize
                h:w
                tp:0
                d:'Ver LogView'
                c:app.c3
                b:app.c2
                t:''
                onClicking: {
                    r.pressed()
                    trb2.restart()
                    appSettings.logViewVisible=!appSettings.logViewVisible
                }
                Text {
                    id: txtb100
                    text: '\uf188'
                    font.pixelSize: r.botSize*0.7
                    color:appSettings.logViewVisible?'red':app.c3
                    font.family: 'FontAwesome'
                    anchors.centerIn: parent
                }
            }
            Boton{
                w:r.botSize
                h:w
                tp:0
                d:'Actualizaciòn '+app.moduleName
                c:app.c3
                b:app.c2
                t:'\uf021'
                onClicking: {
                    r.pressed()
                    unik.clearComponentCache()
                    var f=app.qlandPath+'/'+xP.am[app.mod]+'/'+xP.ars[app.s]
                    var fms=''+f+'/fms'
                    var afms=(''+unik.getFile(fms)).replace(/\n/g, '')
                    var nfms=parseInt(afms)+(1000*60*60*24)
                    var fms2=Qt.platform.os==='android'?fms.replace('file:///', ''):fms.replace('file://', '')
                    var commit=f+'/commit'
                    var commit2=Qt.platform.os==='android'?commit.replace('file:///', ''):commit.replace('file://', '')

                    var cl=''
                    cl+='\n\n\n\n\nActualizando Secciòn'
                    cl+='\n\nfms: '+fms2
                    cl+='\n\ncommit: '+commit2
                    cl+='\n\nafms: '+afms
                    cl+='\n\nnfms: '+nfms
                    cl+='\n\n\n\n'
                    console.log(cl)
                    unik.setFile(fms2, ''+nfms)
                    unik.setFile(commit2, 'clean')
                    prepMod()
                }
            }
            Boton{
                w:r.botSize
                h:w
                tp:0
                d:'Apagar'
                c:app.c3
                b:app.c2
                t:'\uf011'
                onClicking: {
                    r.pressed()
                    Qt.quit()
                }
            }
        }
    }
}
