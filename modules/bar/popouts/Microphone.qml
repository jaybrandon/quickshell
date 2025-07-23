import qs.widgets
import qs.services
import qs.config
import QtQuick

VerticalSlider {
        icon: {
            if (Microphone.muted)
                return "";
            if (Microphone.volume > 0)
                return "";
            return "";
        }
        value: Microphone.volume
        onMoved: Microphone.setVolume(value)

        implicitWidth: Config.osd.sizes.sliderWidth
        implicitHeight: Config.osd.sizes.sliderHeight
}

