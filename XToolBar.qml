import QtQuick 2.0

Item{
    id:r
    width: app.fs*2
    height: colbots.height+app.fs
    x:opacity!==0.0?app.fs*0.25:0-width
    anchors.verticalCenter: parent.verticalCenter
    opacity:0.0
    enabled:r.opacity>0.0
    property int botSize: Qt.platform.os==='android'?app.fs*2:app.fs
    signal pressed
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
                r.opacity=1.0
            }
        }
        onTriggered: {
            r.opacity=0.0
        }
    }
    Rectangle{
        width: r.width*2
        height: r.height+app.fs
        color: app.c3
        opacity: 0.5
        anchors.verticalCenter: r.verticalCenter
        anchors.right: r.right
        anchors.rightMargin: 0-app.fs*0.5
    }
    MouseArea{
        anchors.fill: r
        enabled: r.opacity===1.0
        hoverEnabled: true
        onEntered: r.opacity=1.0
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
            d:'Indice'
            c:app.c3
            b:app.c2
            t:'\uf0c9'
            visible:app.mod===0&&app.s===1?false:true
            onClicking: {
                r.pressed()
                trb2.restart()
                app.mod=0
                if(app.s!==1){
                    app.s=1
                }else{
                    app.s=1
                    app.prepMod()
                }
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
            onClicking: {
                r.pressed()
                xC.visible=!xC.visible
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
