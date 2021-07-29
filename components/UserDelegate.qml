import QtQuick 2.4
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

Item {
    id: wrapper

    property bool isCurrent: true

    readonly property var m: model
    property string name
    property string userName
    property string avatarPath
    property string iconSource
    property bool constrainText: true
    signal clicked()

    property real faceSize: config.AvatarPixelSize ? config.AvatarPixelSize : Math.min(width, height - usernameDelegate.height - units.smallSpacing)

    opacity: isCurrent ? 1.0 : 0.3

    Behavior on opacity {
        OpacityAnimator {
            duration: units.longDuration
        }
    }

    Item {
        id: imageSource
        width: faceSize
        height: faceSize
        anchors {
            bottom: usernameDelegate.top
            horizontalCenter: parent.horizontalCenter
        }
        anchors.bottomMargin: usernameDelegate.height * 0.5

        Rectangle {
            id: outline
            anchors.fill: parent
            anchors.margins: -(config.AvatarOutlineWidth) || -2
            color: "transparent"
            border.width: config.AvatarOutlineWidth || 2
            border.color: config.AvatarOutlineColor || "white"
            radius: 1000
            visible: config.AvatarOutline == "true" ? true : false
        }
        Image {
            id: face
            source: wrapper.avatarPath
            sourceSize: Qt.size(faceSize, faceSize)
            smooth: true
            fillMode: Image.PreserveAspectCrop
            anchors.fill: parent
            visible: false
        }
        Image {
            id: mask
            source: config.UsePngInsteadOfMask == "true" ? "" : "artwork/mask.svgz"
            sourceSize: Qt.size(faceSize, faceSize)
            smooth: true
        }
        OpacityMask {
            anchors.fill: face
            source: face
            maskSource: mask
            cached: true
        }

        PlasmaCore.IconItem {
            id: faceIcon
            source: iconSource
            visible: (face.status == Image.Error || face.status == Image.Null)
            anchors.fill: parent
            anchors.margins: units.gridUnit * 0.5
            colorGroup: PlasmaCore.ColorScope.colorGroup
        }
    }

    PlasmaComponents.Label {
        id: usernameDelegate
        font.family: config.Font || "Noto Sans"
        font.pointSize: config.FontPointSize ? config.FontPointSize * 1.2 : root.height / 80 * 1.2
        renderType: Text.QtRendering
        font.capitalization: Font.Capitalize
        anchors {
            bottom: parent.bottom
            horizontalCenter: parent.horizontalCenter
        }
        height: implicitHeight
        text: wrapper.name
        horizontalAlignment: Text.AlignHCenter
        font.underline: wrapper.activeFocus
    }

    MouseArea {
        anchors.fill: parent
        hoverEnabled: true
        onClicked: wrapper.clicked();
    }

    Accessible.name: name
    Accessible.role: Accessible.Button
    function accessiblePressAction() { wrapper.clicked() }
}
