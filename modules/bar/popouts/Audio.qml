import qs.widgets
import qs.services
import qs.config
import QtQuick

Item {

    implicitWidth: slider.implicitWidth + rotatedText.width + Appearance.spacing.smaller
    implicitHeight: slider.implicitHeight

    VerticalSlider {
        id: slider

        anchors.left: parent.left
        anchors.verticalCenter: parent.verticalCenter

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

        implicitWidth: Config.osd.sizes.sliderWidth
        implicitHeight: Config.osd.sizes.sliderHeight
}

    Item {
        id: rotatedText
        implicitWidth: device.implicitHeight
        implicitHeight: slider.implicitHeight

        anchors.left: slider.right
        anchors.verticalCenter: parent.verticalCenter
        anchors.leftMargin: Appearance.spacing.smaller

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

