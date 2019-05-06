import QtQuick 2.5
import QtQuick.Controls 2.0
import Qt.labs.settings 1.0
Item{
    id:r
    property alias textEditor: te
    property int modo: 1

    property int fs: 16
    property color color:'white'
    property color backgroundColor:'black'
    property string text:''
    property bool modificado: false

    property int col: 0
    property int lin: 0
    signal sendCode(string code)
    Settings{
        id: eSettings
        category: 'conf-unikeditor'

        property int fs
        property string currentFilePath
        property bool wordWrap
    }

    focus: true

    onWidthChanged: te.setPos()
    Flickable{
        id:flTE
        width: r.width
        height:r.height
        contentWidth: te.contentWidth*1.5
        contentHeight: te.contentHeight*1.5
        x:((''+te.lineCount).length)*r.fs
        enabled: r.modo===1
        Rectangle{
            id:xColNLI
            color:r.backgroundColor
            width: ((''+te.lineCount).length)*r.fs
            height: colNLI.height
            y:xTE.y
            anchors.right: xTE.left
            Rectangle{
                width: 1
                height: r.height
                anchors.right: parent.right
                color: r.color
            }

            Column{
                id:colNLI
                width: parent.width-2
                Repeater{
                    model:te.lineCount
                    Item{
                        id:xNlI
                        width:(nli.text.length-8)*r.fs
                        height: r.fs*1.2
                        anchors.right: parent.right
                        Text {
                            id:nli
                            text: '<b>'+parseInt(index+1)+'.</b>'
                            font.pixelSize: parent.height*0.8
                            anchors.bottom:parent.bottom
                            anchors.right: parent.right
                            color: 'white'
                        }
                        //Component.onCompleted: colNL.width=nl.contentWidth
                    }
                }
            }
        }
        Item{
            id:xTE
            width:te.text===''?1:te.contentWidth
            height: te.contentHeight
            x:r.width*0.5
            TextEdit{
                id:te
                text:r.text
                font.pixelSize: r.fs
                color: r.color
                property bool ins: false
                property string ccl: '.'
                property string ccl2: '.'
                cursorDelegate: Rectangle{
                    id:teCursor
                    width: tec.width;
                    height: r.fs
                    radius: width*0.5
                    color:'transparent'
                    Rectangle{
                        id:tec
                        width: cc.contentWidth;
                        height: r.fs
                        border.width: 2
                        border.color: 'red'
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: parent.left
                        color:'transparent'
                        visible:te.ccl!=='\n'
                        Text{
                            id:cc
                            text:te.ccl!==''&&te.ccl!=='\n'?te.ccl:' '
                            font.pixelSize: te.font.pixelSize
                            color: 'red'
                            anchors.centerIn: parent
                        }
                        Rectangle{
                            id:tecDer
                            width: ccDer.contentWidth;
                            height: r.fs
                            anchors.verticalCenter: parent.verticalCenter
                            anchors.left: parent.right
                            color: 'transparent'
                            border.color:te.color
                            border.width:v?1:0
                            property bool v: true
                            Timer{
                                running: true
                                repeat: true
                                interval: 500
                                onTriggered:tecDer.v=!tecDer.v
                            }
                            Text{
                                id:ccDer
                                text:te.ccl2!==''&&te.ccl2!=='\n'?te.ccl2:' '
                                font.pixelSize: te.font.pixelSize
                                color: 'red'
                                anchors.centerIn: parent
                            }
                        }

                    }
                    Item{
                        id:tecinit
                        width: ccinit.contentWidth;
                        height: r.fs
                        anchors.verticalCenter: parent.verticalCenter
                        anchors.right: tec.right
                        visible:te.ccl==='\n'
                        Text{
                            id:ccinit
                            text:'\uf061'
                            font.family: 'FontAwesome'
                            font.pixelSize: te.font.pixelSize
                            color: 'red'
                            anchors.centerIn: parent
                        }
                    }
                    SequentialAnimation{
                        id:san1
                        running: te.ins
                        onStopped: te.ins=false
                        NumberAnimation {
                            target: cc
                            property: "opacity"
                            from:1.0
                            to:0.0
                            duration: 1000
                            easing.type: Easing.InOutQuad
                        }
                    }
                }
                width: r.width
                height: r.fs*1.2
                wrapMode: eSettings.wordWrap?Text.WordWrap:Text.Normal
                property int vpe: 0
                Timer{
                    id:tvpe
                    running: false
                    repeat: false
                    interval: 250
                    onTriggered: {
                        if(te.vpe===2){
                            te.insert(te.cursorPosition, '\n')
                        }else{
                            r.modo=0
                            app.focus=true
                        }
                        te.vpe=0
                    }
                }
                onTextChanged: {
                    te.ins=true
                    te.setPos()
                    r.modificado=true
                }
                onCursorPositionChanged: te.setPos()
                function setPos(){
                    //console.log('LLLLL:-'+te.text.substring(te.cursorPosition-1,te.cursorPosition)+'-')
                    te.ccl=te.text.substring(te.cursorPosition-1,te.cursorPosition)
                    te.ccl2=te.text.substring(te.cursorPosition,te.cursorPosition+1)
                    flTE.contentX=(te.cursorRectangle.x)+r.fs+r.fs*0.5+te.cursorRectangle.width
                    flTE.contentY=(te.cursorRectangle.y-r.height/2)+r.fs*0.5+flTE.y
                    r.lin=parseInt(te.cursorRectangle.y/te.cursorRectangle.height)

                }
            }
        }

    }
    Rectangle{
        id:xColNL
        color:r.backgroundColor
        width: ((''+te.lineCount).length)*r.fs
        height: colNL.height
        y:0-flTE.contentY
        visible:flTE.contentX>r.width/2
        Rectangle{
            width: 1
            height: r.height
            anchors.right: parent.right
            color: r.color
        }

        Column{
            id:colNL
            width: parent.width-2
            Repeater{
                model:te.lineCount
                Item{
                    id:xNl
                    width:(nl.text.length-8)*r.fs
                    height: r.fs*1.2
                    anchors.right: parent.right
                    Text {
                        id:nl
                        text: '<b>'+parseInt(index+1)+'.</b>'
                        font.pixelSize: parent.height*0.8
                        anchors.bottom:parent.bottom
                        anchors.right: parent.right
                        color: 'white'
                    }
                    //Component.onCompleted: colNL.width=nl.contentWidth
                }
            }
        }
    }
    Rectangle{
        id:xCentro
        width: r.fs*5
        height: r.fs*2
        border.width: bw
        border.color: 'red'
        color:'transparent'
        anchors.centerIn: r
        visible: r.modo===1
        radius: r.modificado?r.fs:0
        property int bw: 5
        SequentialAnimation{
            running: !te.ins
            loops: Animation.Infinite
            onRunningChanged: xCentro.bw=1
            NumberAnimation {
                target: xCentro
                property: "bw"
                from:1
                to:4
                duration: 1000
                easing.type: Easing.InOutQuad
            }
        }
        Rectangle{
            width: r.fs*0.6
            height: width
            color:'red'
            anchors.centerIn: parent
            radius: width*0.5
            opacity: 0.0
        }
    }
    Rectangle{
        id:xTF
        color: r.backgroundColor
        width: r.width*0.8
        height: tf.contentHeight+r.fs
        border.width: 1
        border.color: confirmar===0?r.color:'red'
        anchors.centerIn: r
        visible:r.modo===2
        onVisibleChanged: {
            if(visible){
                tf.focus=true
                tf.cursorPosition=tf.text.length-1
                tf.focus=true
            }else{
                xTF.confirmar=0
                tf.color=r.color
                tf.focus=false
            }
        }
        property int modo: -1
        property int confirmar: 0
        Rectangle{
            id:xTFConfirm
            color: r.backgroundColor
            width: txtconf.contentWidth+r.fs
            height: r.fs*1.2
            border.width: 1
            border.color: confirmar===0?r.color:'red'
            anchors.bottom: parent.top
            visible: xTF.confirmar===1
            Text{
                id:txtconf
                text:'File exist! Press Return for save file.'
                font.pixelSize: r.fs
                color:tf.color
                anchors.centerIn: parent
            }
        }
        TextEdit{
            id:tf
            text:eSettings.currentFilePath
            width: parent.width-r.fs
            font.pixelSize: r.fs
            color: r.color
            anchors.verticalCenter: parent.verticalCenter
            x:r.fs*0.5
            cursorDelegate: Rectangle{
                id:tfCursor
                width: r.fs*0.5
                height: r.fs
                radius: width*0.5
                color:cv?r.color:'transparent'
                property bool cv: true
                Timer{
                    id:ttf
                    running: xTF.visible
                    repeat: true
                    interval: 650
                    property int v: 0
                    onTriggered: {
                        v++
                        tfCursor.cv=!tfCursor.cv
                        if(v===3){
                            tf.text=eSettings.currentFilePath
                        }
                    }
                }
            }
            height:contentHeight
            wrapMode: Text.WordWrap
            onTextChanged: {
                tf.color=unik.fileExist(tf.text)?r.color:'red'
            }
            focus: true
            Keys.onReturnPressed: {
                if(xTF.modo===1){//Open File
                    if(unik.fileExist(tf.text)){
                        ub.running=true
                        te.cursorPosition=0
                        eSettings.currentFilePath=tf.text
                        console.log('UnikEditor Loading: '+eSettings.currentFilePat)
                        r.text=unik.getFile(eSettings.currentFilePath)
                        r.modificado=false
                        xTF.confirmar=0
                        xTF.visible=false
                        r.modo=1
                        te.focus=true
                        te.setPos()
                    }else{
                        console.log('UnikEditor Error: File not exist!')
                        tf.text='File not exist'
                        ttf.v=0
                    }
                    ub.running=false
                }else if(xTF.modo===2){//Save
                    console.log('UnikEditor Saving...')
                    if(xTF.confirmar===0&&unik.fileExist(tf.text)){
                        xTF.confirmar=1
                        console.log('UnikEditor Question: Confirm save file?')
                    }else{
                        ub.running=true
                        if(!unik.fileExist(tf.text)){
                            var mf0=tf.text.split('/')
                            var folders=''
                            for(var i=0;i<mf0.length-1;i++){
                                folders+='/'+mf0[i]
                                if(!unik.fileExist(folders)){
                                    console.log('UnikEditor mkdir: '+folders)
                                    unik.mkdir(folders)
                                }
                            }
                        }
                        console.log('UnikEditor finishing ...')
                        timerSave.start()
                    }

                }else{
                    xTF.visible=false
                    ub.running=false
                }
            }
        }

    }

    Text{
        text:'mode: '+r.modo
        font.pixelSize: r.fs
        color: r.color
        anchors.bottom: r.bottom
        anchors.bottomMargin: r.fs*2
        anchors.right: r.right
        opacity: 0.65
    }

    Shortcut {
        sequence: "Esc"
        onActivated: {
            if(xTF.visible){
                xTF.visible=false
            }else{
                r.modo=0
            }

        }
    }
    Shortcut {
        sequence: "Ctrl+Shift+a"
        onActivated: {
            r.modo=2
            xTF.modo=1
            xTF.visible=true
        }
    }
    Shortcut {
        sequence: "Ctrl+s"
        onActivated: {
            unik.setFile(eSettings.currentFilePath, te.text)
            r.modificado=false
        }
    }
    Shortcut {
        sequence: "Ctrl+Shift+s"
        onActivated: {
            xTF.visible=true
            xTF.modo=2
        }
    }
    Shortcut {
        sequence: "Shift+Up"
        context: Qt.ApplicationShortcut
        onActivated: {
            if(appSettings.fs<100){
                appSettings.fs++
            }
        }
    }
    Shortcut {
        sequence: "Shift+Down"
        context: Qt.ApplicationShortcut
        onActivated: {
            if(appSettings.fs>8){
                appSettings.fs--
            }

        }
    }
    Shortcut {
        sequence: "Ctrl+r"
        context: Qt.ApplicationShortcut
        onActivated: {
            sendCode(te.text)
        }
    }
    Shortcut {
        sequence: "i"
        context: Qt.ApplicationShortcut
        onActivated: {
            r.modo=1
        }
    }
    Shortcut {
        sequence: "j"
        context: Qt.ApplicationShortcut
        onActivated: {
            te.cursorPosition--
        }
    }
    Shortcut {
        sequence: "l"
        context: Qt.ApplicationShortcut
        onActivated: {
            te.cursorPosition++
        }
    }
    Shortcut {
        sequence: "m"
        context: Qt.ApplicationShortcut
        onActivated: {
            var n0=te.cursorPosition
            var n=n0
            while(te.text.substring(n-1,n)!=='\n'){
                n--
                if(n<1){
                    break
                }
            }
            var caracteresAnteriores=te.cursorPosition-n
            //console.log('atras hay: '+caracteresAnteriores)
            var n1=n0
            var l=''
            while(l!=='\n'){
                l=''+te.text.substring(n1,n1+1)
                n1++
                if(n1>te.text.length-1){
                    break
                }
            }
            var caracteresPosteriores=n1-1
            var resCarPost=caracteresPosteriores-te.cursorPosition
            //console.log('adelante hay: '+resCarPost)
            var longProximaLinea=0
            var rec=''
            var n2=n0+resCarPost+1
            l=''
            while(l!=='\n'){
                l=''+te.text.substring(n2,n2+1)
                rec+=l
                n2++
                if(n2>te.text.length-1){
                    break
                }
            }
            longProximaLinea=rec.length-1
            if(caracteresAnteriores>longProximaLinea){
                te.cursorPosition=n0+resCarPost+longProximaLinea+1
            }else{
                te.cursorPosition=n0+resCarPost+caracteresAnteriores+1
            }
        }
    }
    Shortcut {
        sequence: "k"
        context: Qt.ApplicationShortcut
        onActivated: {
            var n0=te.cursorPosition
            var n=n0
            while(te.text.substring(n-1,n)!=='\n'){
                n--
                if(n<1){
                    break
                }
            }
            var caracteresAnteriores=te.cursorPosition-n
            var n1=n0
            var l=''
            while(l!=='\n'){
                l=''+te.text.substring(n1,n1+1)
                n1++
                if(n1>te.text.length-1){
                    break
                }
            }
            var caracteresPosteriores=n1-1
            var resCarPost=caracteresPosteriores-te.cursorPosition
            var longAnteriorLinea=0
            var rec=''
            var n2=n0-caracteresAnteriores-2
            l=''
            while(l!=='\n'){
                l=''+te.text.substring(n2,n2+1)
                rec+=l
                n2--
                if(n2<1){
                    break
                }
            }
            longAnteriorLinea=rec.length-1
            if(caracteresAnteriores<longAnteriorLinea){
                te.cursorPosition=n0-caracteresAnteriores-(longAnteriorLinea-caracteresAnteriores+1)
            }else{
                te.cursorPosition=n0-caracteresAnteriores-1
            }
        }
    }
    Timer{
        id:timerSave
        running: false
        repeat: false
        interval: 2000
        onTriggered: {
            te.cursorPosition=0
            eSettings.currentFilePath=tf.text
            unik.setFile(eSettings.currentFilePath, te.text)
            r.text=te.text
            xTF.confirmar=0
            xTF.visible=false
            r.modo=1
            r.modificado=false
            te.focus=true
            te.setPos()
            ub.running=false
        }
    }

    Component.onCompleted: {
        r.text=unik.getFile(eSettings.currentFilePath)
        te.focus=true
        te.cursorPosition=1
        te.setPos()
    }


}
/*
    Modos
    1=Insertar
    2=Abrir
*/
