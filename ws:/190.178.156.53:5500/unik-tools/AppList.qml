import QtQuick 2.7
import QtQuick.Controls 2.0

Rectangle {
    id: raiz
    color: app.c5
    signal loaded
    ListView{
        id: lv
        width: raiz.width*0.9
        height: raiz.height
        spacing: app.fs*0.5
        delegate: del
        anchors.horizontalCenter: parent.horizontalCenter
        clip:true
        Component{
            id:del
            Rectangle{
                id: xC
                width: lv.width-app.fs
                height: visible?lv.width*0.2:0
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                color: app.c1
                opacity: nom!=='spacer'?1.0:0.0
                border.width: 2
                border.color: app.c2
                radius: app.fs*0.5
                visible: (''+tipo).indexOf(''+Qt.platform.os)!==-1
                Image {
                    id: imagen
                    source: img2
                    //width:
                    height: xC.height-app.fs*0.4
                    anchors.verticalCenter: parent.verticalCenter
                    anchors.left: parent.left
                    anchors.leftMargin: app.fs*0.5
                    //cache:false
                    fillMode: Image.PreserveAspectFit
                }
                Column{
                    //visible:parent.color!=='transparent'
                    anchors.left: imagen.right
                    anchors.leftMargin: app.fs*0.5
                    anchors.verticalCenter: parent.verticalCenter
                    Rectangle{
                        id: xNom
                        width:xC.width-imagen.width-app.fs*1.5
                        height: xC.height*0.15
                        clip: true
                        color: "transparent"
                        Text {
                            id: lnom
                            text: '<b>'+nom+'</b>'
                            font.pixelSize: app.fs
                            width: parent.width-app.fs
                            anchors.centerIn: parent
                        }
                    }
                    Rectangle{
                        id:xDes
                        width:xNom.width
                        height: xC.height*0.6
                        anchors.horizontalCenter: xNom.horizontalCenter
                        clip: true
                        color: "transparent"
                        Text {
                            id: ldes
                            text: des
                            font.pixelSize: app.fs*0.6
                            anchors.centerIn: parent
                            width: parent.width-app.fs*0.8
                            wrapMode: Text.WordWrap
                        }
                    }
                    Rectangle{
                        id:xDevYBotInst
                        width:xNom.width
                        height: xC.height*0.15
                        clip: true
                        color: "transparent"
                        anchors.horizontalCenter: xNom.horizontalCenter
                        Text {
                            id: ldev
                            text: '<b>Desarrollador: </b>'+dev+''
                            font.pixelSize: app.fs*0.8
                            width: contentWidth+app.fs
                            anchors.left: parent.left
                            anchors.leftMargin: app.fs*0.5
                            anchors.verticalCenter: parent.verticalCenter
                        }
                        Rectangle{
                            id:botInstalarApp
                            width:lBotInst.contentWidth+app.fs
                            height: xC.height*0.15
                            clip: true
                            color: 'black'
                            anchors.right: parent.right
                            radius: app.fs*0.5
                            Text {
                                id: lBotInst
                                color: app.c2
                                text: "Instalar"
                                font.pixelSize: app.fs*0.8
                                anchors.centerIn: parent
                            }
                            MouseArea{
                                anchors.fill: parent
                                hoverEnabled: true
                                onEntered: {
                                    botInstalarApp.color = app.c2
                                    lBotInst.color = 'black'
                                }
                                onExited:  {
                                    botInstalarApp.color = 'black'
                                    lBotInst.color = app.c2
                                }
                                onPressed: {
                                    lBotInst.text='<b>'+"Instalar"+'</b>'
                                }
                                onReleased: {
                                    lBotInst.text="Instalar"
                                }
                                onClicked: {
                                    var uklData=''
                                    var uklFile=''
                                    var uklFileUp=''
                                    if((''+urlgit).indexOf('.upk')<0){
                                        var carpetaLocal=appsDir
                                        //console.log('Descargando  '+urlgit)
                                        //var downloaded = unik.downloadGit(urlgit, carpetaLocal)
                                        //var fd = appsDir
                                        //var m0= (''+urlgit).split('/')
                                        //var s0=''+m0[m0.length-1]
                                        //var s1=s0.replace('.git', '')
                                        var nclink
                                        if(Qt.platform.os==='linux'){
                                            var nct2

                                            var par=('-git='+urlgit)
                                            var m0=(''+par).split('/')
                                            var s1=(''+m0[m0.length-1]).replace('.git', '')
                                            par+=",-folder="+pws+"/"+s1
                                            par+=",-dir="+pws+"/"+s1
                                            if(''+s1==='unikast'){
                                                par+=",-wss"
                                            }
                                            unik.setUnikStartSettings(par)
                                            console.log('New USS params: '+par)
                                            unik.restartApp("")
                                        }else if(Qt.platform.os==='osx'){
                                            par=('-git='+urlgit)
                                            m0=(''+par).split('/')
                                            s1=(''+m0[m0.length-1]).replace('.git', '')
                                            par+=",-folder="+pws+"/"+s1
                                            par+=",-dir="+pws+"/"+s1
                                            if(''+s1==='unikast'||(''+s1).indexOf('wss')>=1){
                                                par+=",-wss"
                                                uklData+='-wss '
                                            }

                                            //Setting restart unik args
                                            unik.setUnikStartSettings(par)

                                            //Making ukl link file data for Unik Launcher Application
                                            uklData+="-folder="+pws+"/"+s1
                                            uklFile=''+pws+'/link_'+s1+'.ukl'
                                            //Write ukl file data for launch with out update
                                            unik.setFile(uklFile, uklData)
                                            uklData=' -git='+urlgit
                                            uklFileUp=''+pws+'/link_update-'+s1+'.ukl'
                                            //Write ukl file data for launch with git update
                                            unik.setFile(uklFileUp, uklData)
                                            console.log('New UKL File: '+uklFile)
                                            console.log('New UKL Data: '+uklData)


                                            console.log('New USS params: '+par)
                                            unik.ejecutarLineaDeComandoAparte('"'+appExec+'"')

                                        }else if(Qt.platform.os==='windows'){
                                            par=('-git='+urlgit)
                                            m0=(''+par).split('/')
                                            s1=(''+m0[m0.length-1]).replace('.git', '')
                                            par+=",-folder="+pws+"/"+s1
                                            par+=",-dir="+pws+"/"+s1
                                            if(''+s1==='unikast'){
                                                par+=",-wss"
                                            }
                                            unik.setUnikStartSettings(par)
                                            console.log('New USS params: '+par)
                                            unik.ejecutarLineaDeComandoAparte('"'+appExec+'"')
                                        }else{
                                            par=('-git='+urlgit)
                                            m0=(''+par).split('/')
                                            s1=(''+m0[m0.length-1]).replace('.git', '')
                                            par+=",-folder="+pws+"/"+s1
                                            par+=",-dir="+pws+"/"+s1
                                            if(''+s1==='unikast'){
                                                par+=",-wss"
                                            }
                                            unik.setUnikStartSettings(par)
                                            console.log('New USS params: '+par)
                                            unik.ejecutarLineaDeComandoAparte('"'+appExec+'"')
                                        }
                                    }else{
                                        if(Qt.platform.os==='osx'){
                                            appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
                                        }
                                        if(Qt.platform.os==='windows'){
                                            appPath = '"'+unik.getPath(1)+'/'+unik.getPath(0)+'"'
                                        }
                                        if(Qt.platform.os==='linux'){
                                            appPath = '"'+appExec+'"'
                                        }
                                        var cl = '-folder='
                                        m0=(''+urlgit).split('/')
                                        var m1=''+m0[m0.length-1]
                                        var upkData=unik.getHttpFile(urlgit)
                                        var upkFileName=appsDir+'/'+m1
                                        unik.setFile(upkFileName, upkData)
                                        var d = new Date(Date.now())
                                        var t = unik.getPath(2)+'/t'+d.getTime()
                                        unik.mkdir(t)
                                        var upkToFolder = unik.upkToFolder(upkFileName, "unik-free", "free", t)
                                        if(upkToFolder){
                                            cl +=''+t+' -cfg'
                                            unik.log('Running: '+appPath+' '+cl)
                                            unik.ejecutarLineaDeComandoAparte(appPath+' '+cl)
                                        }

                                        //var c='{"mode":"-upk", "arg1": "'+upkFileName+'", "arg2":"-user=unik-free", "arg3":"-key=free"}'
                                        //unik.setFile(appsDir+'/config.json', c)
                                        //unik.restartApp()

                                    }


                                }

                            }

                        }
                    }
                }
            }
        }
    }


    Rectangle{
        width: txtEstado.contentWidth*1.2
        height: txtEstado.contentHeight*1.2
        color: app.c5
        border.width: 2
        border.color: app.c2
        radius: app.fs
        anchors.centerIn: raiz
        visible:lv.model.count<1//(lv.model&&lv.model.count<1)!==undefined

        Text{
            id:txtEstado
            font.pixelSize: app.fs
            anchors.centerIn: parent
            color: app.c2
            text: '<b>Cargando lista de aplicaciones...</b>'
        }
        MouseArea{
            anchors.fill: parent
            onClicked: act()
        }
    }

    function act(){
        var d = new Date(Date.now())
        var dm1='The document has moved'
        //var c = ''+unik.getHttpFile('https://nsdocs.blogspot.com.ar/p/app-list.html')
        var url='https://github.com/nextsigner/unik/wiki/Unik-Apps'
        var c = ''+unik.getHttpFile(url)
        if(c.indexOf(dm1)>0){
            console.log('Reading AppList for Unik Qml Engine from www.unikode.org')
            c = ''+unik.getHttpFile(url)
        }else{
            console.log('Reading AppList for Unik Qml Engine from '+url)
        }
        //console.log(c)
        //return
        var m0=c.split('<div class="markdown-body">')
        var s0
        if(m0.length>1){
            s0=''+m0[1]


            var m1=s0.split('<div id="wiki-rightbar"')
            var s1=''+m1[0]
            //console.log(s1)

            var m2=s1.split('<h1>')

            var nlm='import QtQuick 2.0\n'
            nlm+='ListModel{\n'

            for(var i=1;i<m2.length;i++){
                //console.log('-------->'+m2[i])
                var ss0=''+m2[i]
                var mm0=ss0.split("</h1>")
                var mm1=mm0[0].split("</h1>")
                var mm2=mm1[0].split(">")
                var nom=''+mm2[mm2.length-1]

                var mm3=mm0[1].split("</h3>")
                var mm4=mm3[0].split(":")
                var autor=mm4[1]

                var mm5=mm3[1].split(":")
                var compatibilidad=mm5[1]

                var mm6=mm3[2].split("src=\"")
                if(mm6.length>1){
                    var mm7=mm6[1].split("\"")
                    var imagen=mm7[0]
                    //console.log(i+':-------->'+imagen)

                    var mm8=mm3[3].split("href=\"")
                    var mm9=mm8[1].split("\"")
                    var urlGit=mm9[0]
                    //console.log(i+':-------->'+urlGit)

                    var mm10=mm3[2].split("</p>")
                    var mm11=mm10[0].split("\">")
                    var des=mm11[1]
                    //console.log(i+':-------->'+des)
                    nlm+='ListElement{
nom: "'+nom+'"
des: "'+des+'"
dev: "'+autor+'"
urlgit: "'+urlGit+'"
img2: "'+imagen+'"
tipo: "'+compatibilidad+'"
}'
                }
            }//ff
            nlm+='ListElement{nom: "spacer";des:"";dev:"";img2:"";tipo: "linux-osx-windows-android"}'
            nlm+='}\n'
            var nLm=Qt.createQmlObject(nlm, raiz, 'qmlNLM')
            lv.model = nLm
        }else{
            txtEstado.text= '<b>Error</b> Fallò la conexiòn o descarga de lista.<br>Click para Actualizar lista de Aplicaciones.'
        }
        loaded()
    }

}
