import QtQuick 2.9
import QtQuick.Controls 2.0
import QtQuick.Dialogs 1.2
import Qt.WebSockets 1.0
import Qt.labs.settings 1.0
import "qwebchannel.js" as WebChannel

Rectangle {
    id: r
    anchors.fill: parent
    color:app?app.c3:'gray'
    property string wsModuleName: 'wscli'
    property int fs: app && app.fs ? app.fs:r.width*0.03
    property var channel
    property var listView

    //Default
    property url url: "ws://127.0.0.1:12345"

    //Envia a Android Samsung J7
    //property url url: "ws://192.168.1.64:5500"


    //Envia a Linux
    //property url url: "ws://192.168.1.61:12345"


    property var arrayUserList: []
    property string loginUserName
    signal loguinSucess()
    signal errorSucess()
    signal keepAliveSuccess()
    Settings{
        id: wscliSettings
        category: 'conf-'+r.wsModuleName+app.moduleName
        property string uUrl
        onUUrlChanged: {
            socket.url=uUrl
            xWsUrl.visible=false
            xUserName.visible=false
        }
    }
    WebSocket {
        id: socket
        property var send: function(arg) {
            sendTextMessage(arg);
        }
        onTextMessageReceived: {
            onmessage({data: message});
        }
        property var onmessage
        active: true
        url: r.url
        onStatusChanged: {
            switch (socket.status) {
            case WebSocket.Error:
                errorSucess()
                errorDialog.text = "Error: " + socket.errorString;
                errorDialog.visible = true;
                break;
            case WebSocket.Closed:
                errorDialog.text = "Error: Socket at " + url + " closed.";
                errorDialog.visible = true;
                break;
            case WebSocket.Open:
                //open the webchannel with the socket as transport
                new WebChannel.QWebChannel(socket, function(ch) {
                    r.channel = ch;
                    //connect to the changed signal of the userList property
                    ch.objects.chatserver.userListChanged.connect(function(args) {
                        r.arrayUserList=ch.objects.chatserver.userList
                        var d = new Date(Date.now())
                        var ul = r.arrayUserList
                        for(var i=0; i < ul.length; i++){
                            if(''+ul[i]===tiUserName.text){
                                //xUserName.visible=false
                            }
                        }
                    });
                    //connect to the newMessage signal
                    ch.objects.chatserver.newMessage.connect(function(time, user, message) {
                        var d = new Date(Date.now())
                        //console.log('Unik WsSql: Addign QmlCode: '+message)
                    });
                    //connect to the keep alive signal
                    ch.objects.chatserver.keepAlive.connect(function(args) {
                        if (r.loginUserName !== '')
                            //and call the keep alive response method as an answer
                            ch.objects.chatserver.keepAliveResponse(r.loginUserName);
                        keepAliveSuccess()
                    });
                });
                xUserName.visible=true;
                break;
            }
        }
    }

    ListModel{
        id: listModelUser
        property var arrayUserList: []
        function createElement(u){
            return {
                user: u
            }
        }
        function updateUserList(){
            console.log('Unik WsClient: Updating User List...')
            clear()
            var ul = arrayUserList;
            for(var i=0; i < ul.length; i++){
                append(createElement(ul[i]))
                console.log('Unik WsClient: Addign User: '+ul[i])
            }
        }
    }
    ListModel{
        id: listModelMsg
        function createElement(m){
            return {
                msg: m
            }
        }
        function addMsg(msg){
            append(createElement(msg))
        }
    }

    Rectangle {
        id: xUserName
        width: rowUN.width+app.fs
        height:r.fs*1.6
        color:app.c3
        visible:false
        //anchors.centerIn: parent
        onVisibleChanged: {
            if(visible){
                tiUserName.focus=true
            }
        }
        Column{
            spacing: r.fs*0.5
            Row{
                id:rowUN
                spacing: r.fs*0.5
                Text{
                    text: 'User Name: '
                    font.pixelSize: r.fs
                    color:app.c2
                }
                TextEdit{
                    id:tiUserName
                    width: r.width*0.5
                    height: r.fs*1.2
                    font.pixelSize: r.fs
                    color:app.c2
                    anchors.verticalCenter: parent.verticalCenter
                    cursorDelegate: Rectangle{
                        id:cte
                        width: app.fs*0.25
                        height: app.fs
                        color:v?app.c2:'transparent'
                        property bool v: true
                        Timer{
                            running: xUserName.visible
                            repeat: true
                            interval: 650
                            onTriggered: cte.v=!cte.v
                        }
                    }
                    Keys.onReturnPressed: {
                        xUserName.loguin()
                    }
                    Rectangle{
                        width: parent.width+r.fs*0.25
                        height: parent.height+r.fs*0.25
                        color: 'transparent'
                        anchors.centerIn: parent
                        border.width: 1
                        border.color: app.c2
                    }
                }
            }
            Button{
                text: 'Conectar'
                font.pixelSize: r.fs
                anchors.right: parent.right
                onClicked: {
                    xUserName.loguin()
                }
            }
        }
        function loguin(){
            r.channel.objects.chatserver.login(tiUserName.text, function(arg) {
                //check the return value for success
                if (arg === true) {
                    r.loginUserName=tiUserName.text
                    xUserName.visible=false
                    tiUserName.focus=false
                    r.focus=false
                    loguinSucess()
                } else {
                    tiUserName.color='red'
                }
            });
        }

    }


    Rectangle {
        id: xWsUrl
        width: r.width*0.8
        height: r.width*0.02
        color:app.c3
        anchors.centerIn: parent
        visible:false
        onVisibleChanged: {
            if(visible){
                //socket.close()
                tiWebSocketUrl.text=wscliSettings.uUrl
                tiWebSocketUrl.focus=true
            }
        }
        Column{
            spacing: r.fs*0.5
            Row{
                spacing: r.fs*0.5
                Text{
                    text: 'WebSockets Url: '
                    font.pixelSize: r.fs
                    color:app.c2
                }
                TextInput{
                    id:tiWebSocketUrl
                    width: r.width*0.5
                    height: r.fs*1.2
                    font.pixelSize: r.fs
                    color:app.c2
                    anchors.verticalCenter: parent.verticalCenter
                    cursorDelegate: Rectangle{
                        id:cte2
                        width: app.fs*0.25
                        height: app.fs
                        color:v?app.c2:'transparent'
                        property bool v: true
                        Timer{
                            running: xWsUrl.visible
                            repeat: true
                            interval: 650
                            onTriggered: cte2.v=!cte2.v
                        }
                    }
                    Keys.onReturnPressed:r.url=tiWebSocketUrl.text
                    Rectangle{
                        width: parent.width+r.fs*0.25
                        height: parent.height+r.fs*0.25
                        color: 'transparent'
                        anchors.centerIn: parent
                        border.width: 1
                        border.color: app.c2
                    }
                }

            }
            Button{
                text: 'Conectar'
                font.pixelSize: r.fs
                anchors.right: parent.right
                onClicked: {
                    xWsUrl.visible=false
                    wscliSettings.uUrl=tiWebSocketUrl.text
                }
            }
        }
    }


    Rectangle {
        id: errorDialog
        width: r.width*0.96
        height: msg.contentHeight+r.fs*8
        color: app.c3
        border.width: 1
        border.color: app.c2
        anchors.centerIn: r
        visible:false
        property alias text: msg.text
        onVisibleChanged: {
            if(visible){
                errorSucess()
            }
        }
        Text {
            text: '<b>WebSocket Error</b>'
            font.pixelSize: r.fs
            color:app.c2
            width: errorDialog.width-r.fs
            wrapMode: Text.WordWrap
            anchors.left: parent.left
            anchors.leftMargin: r.fs*0.5
            anchors.top: parent.top
            anchors.topMargin: r.fs*0.5
        }
        Text {
            id: msg
            text: 'Error!'
            font.pixelSize: r.fs
            color:app.c2
            width: errorDialog.width-r.fs
            wrapMode: Text.WordWrap
            anchors.centerIn: parent
        }
        Button{
            text:'Aceptar'
            font.pixelSize: r.fs
            anchors.right: parent.right
            anchors.rightMargin: r.fs*0.5
            anchors.bottom: parent.bottom
            anchors.bottomMargin: r.fs*0.5
            onClicked: {
                errorDialog.visible=false
                xUserName.visible=false
                tiWebSocketUrl.text=wscliSettings.uUrl
                r.url=''
                xWsUrl.visible=true
            }
        }
    }
    Component.onCompleted: {
        if(wscliSettings.uUrl===''){
            wscliSettings.uUrl=r.url
        }
    }

    function sendCode(c){
        //console.log("WsSql sending "+r.loginUserName+" "+c)

        //Funciona sin comprimir
        r.channel.objects.chatserver.sendMessage(r.loginUserName,"\""+c+"\"");

        //Probando compresion
        //r.channel.objects.chatserver.sendMessage(r.loginUserName,c);
    }
    function sendAudioStream(d){
        //r.channel.objects.chatserver.sendMessage(r.loginUserName, "audio"+d+"");
        r.channel.objects.chatserver.sendMessage(r.loginUserName, d);
    }
}
