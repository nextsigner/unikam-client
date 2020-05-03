import QtQuick 2.0
import QtQuick.Controls 2.0
import QtQuick.Controls.Styles 1.4
Rectangle{
    id:r
    width: parent.width
    height:  parent.height
    clip: true
    property int topHandlerHeight: 30
    /*color: r.scrollBarBgColor
    border.width: 1
    border.color: r.scrollBarHandlerColor
    property string bodyText: ''
    property var handlerSB

    property bool showUnikControls: false
    property bool showUnikInitMessages: unik.debugLog
    property int fontSize:14
    property string fontFamily: 'Arial'

    property int maxLength: 1000*50*5
    property int topHandlerHeight:0
    property color handlerColor: '#ccc'
    property color fontColor: "#1fbc05"
    property color bgColor: "#000000"

    property int scrollBarWidth:12
    property color scrollBarHandlerColor: r.fontColor
    property color scrollBarBgColor: r.bgColor

    property bool showPlainText: false
    property bool enableAutoToBottom: true

    property bool showCommandsLineInput: false
    property int commandsLineInputHeight: r.fontSize*2

    property string help: ''


    FontLoader {name: "FontAwesome";source: "qrc:/fontawesome-webfont.ttf";}
    Connections {target: unik;onUkStdChanged: log((''+unik.ukStd).replace(/\n/g, '<br />'));}
    Connections {target: unik;onStdErrChanged: log((''+unik.ukStd).replace(/\n/g, '<br />'));}
    Timer{
        running: r.height<=0&&r.topHandlerHeight<=0
        repeat: false
        interval: 500
        onTriggered: {
            r.topHandlerHeight=4
            r.height=4
        }
    }
    Flickable{
        id:fk
        width: r.width
        height: r.showUnikControls ? parent.height-lineRTop.height-xBtns.height : parent.height-lineRTop.height
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        contentWidth: r.width
        contentHeight: logTxt.height
        boundsBehavior: Flickable.StopAtBounds
        onDragStarted:  draged=true

        property bool draged: false
        property int uh:0
        property int ucy:0
        onContentYChanged: {
            if(fk.contentY>fk.contentHeight-fk.height-(fk.height/16)&&draged){
                draged=false
            }
            if(contentY!==0&&contentY<=ucy){
                draged=true
            }
            ucy=contentY
        }
        ScrollBar.vertical: ScrollBar {
            parent: fk.parent
            anchors.top: fk.top
            anchors.left: fk.right
            anchors.bottom: fk.bottom
            width: fontSize
        }
        Text {
            id: logTxt
            width: r.width.width-fontSize*2
            height: contentHeight
            font.pixelSize: fontSize
            color: fontColor
            wrapMode: Text.WordWrap
            textFormat: showPlainText ? Text.Normal : Text.RichText            
        }
    }
    LineResizeTop{
        id:lineRTop;
        width: r.width
        height: r.topHandlerHeight
        color: r.handlerColor
        minY: 0-r.y
        maxY: height
        onEnabledChanged: r.height+=10
        onYChanged: {
            r.height-=y;lineRTop.y=0;
            if(r.height<=r.topHandlerHeight){
                r.height=r.topHandlerHeight
                lineRTop.y=0;
            }
        }
        onProcesar: {
            r.height-=y;lineRTop.y=0;
        }
        onLineReleased: {
            r.height-=y;lineRTop.y=0;
            if(r.height<=r.topHandlerHeight){
                r.height=r.topHandlerHeight
                lineRTop.y=0;
            }
        }
    }
    Rectangle{
        id: xBtns
        width: r.width
        height: r.showUnikControls?r.fontSize*2:0
        color: r.fontColor
        anchors.top: lineRTop.bottom
        Row{
            visible: parent.height!==0
            anchors.right: parent.right
            anchors.rightMargin: r.fontSize*0.2
            anchors.verticalCenter: parent.verticalCenter
            height: r.fontSize*1.6
            spacing: r.fontSize
            Boton{
                id:btnDown
                w:parent.height
                h: w
                t: '\uf063'
                b: r.bgColor
                c: r.fontColor
                d:'Reducir LogView hacia abajo'
                tp:1
                onClicking: {
                    r.height=0+lineRTop.height
                }
            }
            Boton{
                id:btnTextType
                w:parent.height
                h: w
                t: ''
                b: r.bgColor
                c: r.fontColor
                d:r.showPlainText?'LogView a HTML':'LogView a TXT'
                tp:1
                onClicking: {
                    r.showPlainText=!r.showPlainText
                }
                Text {
                    id: txtTT1
                    text: r.showPlainText?'<b>TXT<b>':'<b>HTML<b>'
                    anchors.centerIn: parent
                    font.pixelSize: parent.width*0.3
                    color: r.fontColor
                }
            }
            Boton{
                id:btnClear
                w:parent.height
                h: w
                t: '\uf12d'
                b: r.bgColor
                c: r.fontColor
                d:'Limpiar LogView'
                tp:1
                onClicking: {
                    logTxt.text=''
                }
            }
            Boton{
                id:btnHelp
                w:parent.height
                h: w
                t: '<b>?</b>'
                b: r.bgColor
                c: r.fontColor
                d:'Acerca de Unikast'
                tp:1
                onClicking: {
                   showInfo()
                }
            }
            Item{
                width: parent.height
                height: width
            }
            Boton{//a unik-tools
                w:parent.height
                h: w
                t: '\uf015'
                b: r.bgColor
                c: r.fontColor
                d:'Iniciar Unik-Tools'
                tp:1
                visible: !r.enUnikTools
                onClicking: {
                    unik.ejecutarLineaDeComandoAparte(appExec+' -folder='+appsDir+'/unik-tools  -cfg')
                }
            }
            Boton{
                id:btnFS
                w:parent.height
                h: w
                t: '\uf0b2'
                b: r.bgColor
                c: r.fontColor
                d:'FullScreen'
                tp:1
                onClicking: {
                    if(app.visibility===Window.FullScreen){
                        app.visibility='Windowed'
                    }else{
                        app.visibility='FullScreen'
                    }
                }
            }
            Boton{//Restart
                w:parent.height
                h: w
                t: '\uf021'
                b: r.bgColor
                c: r.fontColor
                d:'Reiniciar'
                tp:1
                visible: !r.enUnikTools
                onClicking: {
                    unik.restartApp()
                }
                Text {
                    text: "\uf011"
                    font.family: "FontAwesome"
                    font.pixelSize: parent.height*0.3
                    anchors.centerIn: parent
                    color: r.fontColor
                }
            }
            Boton{//Quit
                w:parent.height
                h: w
                t: "\uf011"
                b: r.bgColor
                c: r.fontColor
                d:'Apagar'
                tp:1
                visible: !r.enUnikTools
                onClicking: {
                    Qt.quit()
                }
            }
        }

    }

    onHeightChanged: appSettings.lvh=height
    Component.onCompleted: {
        if(r.showUnikInitMessages){
            var s=(''+unik.initStdString).replace(/\n/g, '<br />')
            var stdinit='<b>Start Unik Init Message:</b>\u21b4<br />'+s+'<br /><b>End Unik Init Message.</b><br />\n'
            var txt =''

            txt += "<b>OS: </b>"+Qt.platform.os

            var s2=(''+unikError).replace(/\n/g, '<br />')
            txt+=s2
            txt += '<b>unik version: </b>'+version+'<br />\n'
            txt += '<b>AppName: </b>'+appName+'<br />\n'
            var e;
            if(unikError!==''){
                txt += '\n<b>Unik Errors:</b>\n'+unikError+'<br />\n'
            }else{
                txt += '\n<b>Unik Errors:</b>none<br />\n'
            }
            txt += 'Doc location: '+appsDir+'/<br />\n'
            txt += 'host: '+host+'<br />\n'
            txt += 'user: '+ukuser+'<br />\n'
            if(ukuser==='unik-free'){
                txt += 'key: '+ukkey+'<br />\n'
            }else{
                txt += 'key: '
                var k= (''+ukkey).split('')
                for(var i=0;i<k.length;i++){
                    txt += '*'
                }
                txt += '<br />\n'
            }
            txt += 'sourcePath: '+sourcePath+'<br />\n'
            txt += '\n<b>config.json:</b>\n'+unik.getFile(appsDir+'/config.json')+'<br />\n'
            bodyText+=txt+'<br />'+stdinit
            logTxt.text+=bodyText
        }
        //unik.setProperty("setInitString", true)
        if(r.fontSize<=0){
            r.fontSize = 14
        }
    }
    function log(l){
        if((''+l).indexOf('QSslSocket')>-1){
            return
        }
        if(logTxt.text.length>r.maxLength){
            logTxt.text=''
        }
        logTxt.text+=l
        if(fk.contentHeight>=r.height&&!fk.draged){
            fk.contentY=fk.contentHeight-fk.height
        }
    }
    function clear(){
        logTxt.text=''
    }
    function showInfo(){
        var data=''+unik.getFile(appsDir+'/'+app.moduleName+'/README.md')
        var m0=data.split('\n')
        var nd=''
        for(var i=0;i<m0.length;i++){
            var l=''+m0[i]
            if(l.substring(0,1)==='#'){
                nd+='<h1>'+l.substring(1,l.length)+'</h1>'
            }else if(l.substring(0,2)==='##'){
                    nd+='<h2>'+l.substring(3,l.length)+'</h2>'
            }else{
                nd+=l+'<br />'
            }
        }
        log(nd)
        if(r.height<400){
            r.height=400
        }
    }
*/
}
