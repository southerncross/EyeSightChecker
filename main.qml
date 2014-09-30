import QtQuick 2.3
import QtQuick.Controls 1.2
import 'secret.js' as Secret

ApplicationWindow {
    id: root
    visible: true
    title: qsTr("EyeSight")
    width: 640
    height: 480

    property int sightLevel: 53
    property int displayLevel: 93 - sightLevel
    property int maxSightLevel: 53
    property int minSightLevel: 40
    property real imgScale: calculateScale()
    property int imgAngle: 0
    property bool displayState: true

    function calculateScale() {
        return configuration.basicScale * Math.pow(10.0, (sightLevel - minSightLevel) / 10.0)
    }

    function changeBasicScale(times) {
        configuration.changeBasicScale(times);
        changeSightLevel(0)
    }

    function changeSightLevel(step) {
        sightLevel += step;
        if (sightLevel > maxSightLevel) sightLevel = maxSightLevel;
        if (sightLevel < minSightLevel) sightLevel = minSightLevel;
        imgScale = calculateScale();
    }

    function nextImgSight() {
        sightChange.start();
    }

    function toConfigUI() {
        displayState = false;
        sightLevel = maxSightLevel;
        imgScale = calculateScale();
        intoConfigMode.start();
        imgSightBehavior.enabled = false;
    }

    function toDisplayUI() {
        displayState = true;
        intoDisplayMode.start();
        imgSightBehavior.enabled = true;
    }

    Rectangle {
        id: rect
        focus: true
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Keys.onPressed: {
            if (displayState) {
                if (Secret.succeedp(event.key))
                    toConfigUI();
                else if (event.key === Qt.Key_Up)
                    changeSightLevel(1);
                else if (event.key === Qt.Key_Down)
                    changeSightLevel(-1);
                else if (event.key === Qt.Key_Left || event.key === Qt.Key_Right)
                    nextImgSight();
            }
            else {
                if (event.key === Qt.Key_Enter || event.key === Qt.Key_Return)
                    toDisplayUI();
                else if (event.key === Qt.Key_Up)
                    changeBasicScale(1.05);
                else if (event.key === Qt.Key_Down)
                    changeBasicScale(0.95);
            }
        }

        Image {
            id: imgSight
            smooth: false
            source: "sight.svg"
            scale: imgScale
            rotation: imgAngle
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            Behavior on scale {
                id: imgSightBehavior
                enabled: true
                PropertyAnimation {
                    duration: 100
                }
            }
        }

        Image {
            id: imgSightBackup
            anchors.horizontalCenter: imgSight.horizontalCenter
            anchors.verticalCenter: imgSight.verticalCenter
            smooth: false
            source: "sight.svg"
            visible: false
        }
    }

    Text {
        id: txtSight
        y: rect.y + 50 + imgSight.paintedHeight * imgScale / 2
        text: qsTr(String(Math.floor(displayLevel / 10)) + '.' + String(displayLevel % 10))
        font.pointSize: 20
        anchors.horizontalCenter: rect.horizontalCenter
        Behavior on y {
            enabled: true
            PropertyAnimation {
                duration: 100
            }
        }
    }

    Rectangle {
        id: verticalRule
        width: imgSight.paintedWidth * imgScale
        height: parent.height + 2
        color: "transparent"
        anchors.verticalCenter: rect.verticalCenter
        anchors.horizontalCenter: rect.horizontalCenter
        border.width: 1
        opacity: 0
        z: 0
    }

    Rectangle {
        id: horizontalRule
        width: parent.width + 2
        height: imgSight.paintedHeight * imgScale
        color: "transparent"
        anchors.verticalCenter: rect.verticalCenter
        anchors.horizontalCenter: rect.horizontalCenter
        border.width: 1
        opacity: 0
        z: 0
    }

    SequentialAnimation {
        id: sightChange
        ScriptAction {
            script: {
                imgSightBackup.visible = true;
                imgSight.visible = false;
                imgSightBackup.scale = imgSight.scale;
                imgSightBackup.rotation = imgSight.rotation;
                imgAngle = 90 * (Math.floor(Math.random() * 10) % 4);
            }
        }
        ParallelAnimation {
            PropertyAnimation {
                target: imgSightBackup
                property: "scale"
                easing.type: "InExpo"
                to: 10
                duration: 300
            }
            PropertyAnimation {
                target: imgSightBackup
                property: "opacity"
                easing.type: "InExpo"
                to: 0
                duration: 300
            }
        }
        ScriptAction {
            script: {
                imgSightBackup.scale = 0;
                imgSightBackup.rotation = imgAngle;
            }
        }
        ParallelAnimation {
            PropertyAnimation {
                target: imgSightBackup
                property: "scale"
                easing.type: "OutExpo"
                to: imgSight.scale
                duration: 200
            }
            PropertyAnimation {
                target: imgSightBackup
                property: "opacity"
                easing.type: "OutExpo"
                to: 1
                duration: 200
            }
        }
        ScriptAction {
            script: {
                imgSight.visible = true;
                imgSightBackup.visible = false
            }
        }
    }

    ParallelAnimation {
        id: intoConfigMode
        SequentialAnimation {
            PropertyAnimation {
                target: imgSight
                properties: "opacity"
                to: 0
                duration: 500
                easing.type: "OutCubic"
            }
            PropertyAnimation {
                target: imgSight
                properties: "opacity"
                to: 1
                duration: 500
                easing.type: "InCubic"
            }
        }
        PropertyAnimation {
            target: verticalRule
            properties: "opacity"
            to: 1
            duration: 500
        }
        PropertyAnimation {
            target: horizontalRule
            properties: "opacity"
            to: 1
            duration: 500
        }
    }

    ParallelAnimation {
        id: intoDisplayMode
        PropertyAnimation {
            target: verticalRule
            properties: "opacity"
            to: 0
            duration: 500
        }
        PropertyAnimation {
            target: horizontalRule
            properties: "opacity"
            to: 0
            duration: 500
        }
    }
}
