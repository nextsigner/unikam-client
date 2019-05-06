/*
Este codigo se enviara
al UnikWebSocketServerView{}
instanciado en Unikast Server
desde esta aplicacion UnikastClient
a la url ws://127.0.0.1 
o a la que se requiera.
*/

import QtQuick 2.0
Rectangle{
	width:parent.width
	height:parent.height
	color:"red"
	Rectangle{
		width:parent.width*0.4
		height:width
		anchors.centerIn: parent
		Text{
			text:"Este Rectangulo blanco fue enviado desde unikastclient"
			width:parent.width*0.9
			font.pixelSize: parent.width*0.1
			wrapMode: Text.WordWrap
			anchors.centerIn: parent
		}
	}
}
