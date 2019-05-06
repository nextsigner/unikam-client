import QtQuick 2.7
import QtQuick.Controls 1.4
import QtQuick.Controls.Styles 1.4
import QtGraphicalEffects 1.0
Item {
    id: r
    property alias running: b.running
    width: app.fs*4
    height: width
    anchors.centerIn: parent
    BusyIndicator {
        id:b
        running:true
        style: BusyIndicatorStyle {
            indicator: Image {
                id:bi
                visible: control.running
                width: r.width
                height: r.width
                source: "unikbusy.png"
                RotationAnimator on rotation {
                    running: control.running
                    loops: Animation.Infinite
                    duration: 2000
                    from: 0 ; to: 360
                }
                ColorOverlay {
                    anchors.fill: bi
                    source: bi
                    color: app.c2
                }
                Timer{
                    running: true
                    repeat: true
                    interval: 500
                    onTriggered: {
                        bi.width=r.width
                        bi.height=r.width
                    }
                }
            }
        }
    }

}

