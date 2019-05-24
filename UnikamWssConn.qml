import QtQuick 2.0
import QtQuick.Controls 2.0

Rectangle {
    id: r
    color: app.color
    anchors.fill: parent
    property alias url: tiUrl.text
    property alias statusText: status.text
    signal connecting(string url)
    Column{
        spacing: app.fs*0.5
        anchors.top: r.top
        anchors.topMargin: app.fs*0.1
        anchors.horizontalCenter: r.horizontalCenter
        Text{
            text: 'Url WebSockets Connection '
            font.pixelSize: app.fs
            color:app.c2
        }
        Item {width: 2;height: app.fs}
        Row{
            spacing: app.fs*0.5
            Text{
                text: 'WebSockets Url: '
                font.pixelSize: app.fs
                color:app.c2
            }
            TextInput{
                id:tiUrl
                width: r.width*0.5
                height: app.fs*1.2
                font.pixelSize: app.fs
                color:app.c2
                anchors.verticalCenter: parent.verticalCenter
                cursorDelegate: Rectangle{
                    id:cte2
                    width: app.fs*0.25
                    height: app.fs
                    color:v?app.c2:'transparent'
                    property bool v: true
                 }
                //Keys.onReturnPressed:r.url=tiWebSocketUrl.text
                Rectangle{
                    width: parent.width+app.fs*0.25
                    height: parent.height+app.fs*0.25
                    color: 'transparent'
                    anchors.centerIn: parent
                    border.width: 1
                    border.color: app.c2
                }
            }
        }
        Text{
            id: status
            font.pixelSize: app.fs
            color:app.c2
        }
        Button{
            text: 'Iniciar '+app.moduleName
            font.pixelSize: app.fs
            anchors.right: parent.right
            onClicked: {
                r.connecting(tiUrl.text)
                r.visible=false
            }
        }
    }
    Component.onCompleted: {

    }
}
