import qs.components
import qs.components.controls
import qs.services
import qs.config
import QtQuick
import Quickshell

Item {
    id: root

    required property var wrapper

    implicitWidth: Math.max(volumeSlider.implicitWidth, pavuButton.implicitWidth) + rotatedText.width + Appearance.spacing.normal
    implicitHeight: volumeSlider.implicitHeight + pavuButton.implicitHeight + Appearance.spacing.normal

    VerticalSlider {
        id: volumeSlider

        anchors.left: parent.left

        icon: {
            if (Audio.muted)
                return "no_sound";
            if (value >= 0.5)
                return "volume_up";
            if (value > 0)
                return "volume_down";
            return "volume_mute";
        }

        value: Audio.volume
        onMoved: Audio.setVolume(value)

        implicitWidth: Math.max(Config.osd.sizes.sliderWidth, pavuButton.implicitWidth)
        implicitHeight: Config.osd.sizes.sliderHeight
    }

    StyledRect {
        id: pavuButton

        anchors.left: parent.left
        anchors.top: volumeSlider.bottom
        anchors.topMargin: Appearance.spacing.normal
        
        implicitWidth: implicitHeight
        implicitHeight: icon.implicitHeight + Appearance.padding.small * 2

        radius: Appearance.rounding.normal
        color: Colours.palette.m3surfaceContainer

        StateLayer {
            function onClicked(): void {
                root.wrapper.hasCurrent = false;
                Quickshell.execDetached(["app2unit", "--", ...Config.general.apps.audio]);
            }
        }

        MaterialIcon {
            id: icon

            anchors.centerIn: parent
            text: "settings"
        }
    }
    
    Item {
        id: rotatedText
        implicitWidth: device.implicitHeight
        implicitHeight: volumeSlider.implicitHeight + pavuButton.implicitHeight

        anchors.left: volumeSlider.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Appearance.spacing.normal

        StyledText {
            id: device
            text: qsTr(Audio.device)
            elide: Text.ElideMiddle
            wrapMode: Text.NoWrap
            maximumLineCount: 2
            horizontalAlignment: Text.AlignHCenter

            width: parent.height

            anchors.centerIn: parent

            transform: Rotation {
                origin.x: device.width / 2
                origin.y: device.height / 2
                angle: 90
            }
        }
    } 
}
