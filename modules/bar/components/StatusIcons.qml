import qs.widgets
import qs.services
import qs.utils
import qs.config
import Quickshell
import Quickshell.Bluetooth
import Quickshell.Services.UPower
import QtQuick
import Quickshell.Io

Item {
    id: root

    property color colour: Colours.palette.m3secondary

    readonly property Item network: network
    readonly property real bs: bluetooth.y
    readonly property real be: repeater.count > 0 ? devices.y + devices.implicitHeight : bluetooth.y + bluetooth.implicitHeight
    readonly property Item battery: battery
    readonly property Item audio: audio
    readonly property Item microphone: microphone

    clip: false
    implicitWidth: Math.max(network.implicitWidth, bluetooth.implicitWidth, devices.implicitWidth, battery.implicitWidth, audio.implicitWidth)
    implicitHeight: audio.implicitHeight + microphone.implicitHeight + microphone.anchors.topMargin + network.implicitHeight + network.anchors.topMargin + bluetooth.implicitHeight + bluetooth.anchors.topMargin + (repeater.count > 0 ? devices.implicitHeight + devices.anchors.topMargin : 0) + battery.implicitHeight + battery.anchors.topMargin

    MaterialIcon {
        id: audio

        animate: true
        text: {
            if (Audio.muted)
                return "no_sound";
            if (Audio.volume >= 0.5)
                return "volume_up";
            if (Audio.volume > 0)
                return "volume_down";
            return "volume_mute";
        }
        color: root.colour

        anchors.horizontalCenter: parent.horizontalCenter

        StateLayer {
            anchors.fill: undefined
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 1

            implicitWidth: parent.implicitHeight + Appearance.padding.small * 2
            implicitHeight: implicitWidth

            radius: Appearance.rounding.full

            hoverEnabled: false

            function onClicked(): void {
                Audio.toggleMute();
            }
        }
    }

    MaterialIcon {
        id: microphone

        animate: true
        text: {
            if (Microphone.muted)
                return "";
            if (Microphone.volume > 0)
                return "";
            return "";
        }
        color: root.colour

        anchors.horizontalCenter: audio.horizontalCenter
        anchors.top: audio.bottom
        anchors.topMargin: Appearance.spacing.smaller / 2

        StateLayer {
            anchors.fill: undefined
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 1

            implicitWidth: parent.implicitHeight + Appearance.padding.small * 2
            implicitHeight: implicitWidth

            radius: Appearance.rounding.full

            hoverEnabled: false

            function onClicked(): void {
                Microphone.toggleMute()
            }
        }
    }

    MaterialIcon {
        id: network

        animate: true
        text: Network.active ? Icons.getNetworkIcon(Network.active.strength ?? 0) : "wifi_off"
        color: root.colour

        anchors.horizontalCenter: microphone.horizontalCenter
        anchors.top: microphone.bottom
        anchors.topMargin: Appearance.spacing.smaller / 2

        StateLayer {
            anchors.fill: undefined
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 1

            implicitWidth: parent.implicitHeight + Appearance.padding.small * 2
            implicitHeight: implicitWidth

            radius: Appearance.rounding.full

            hoverEnabled: false

            function onClicked(): void {
                Quickshell.execDetached(["app2unit", "--", "/home/jayh/.config/rofi/applets/wifimenu", "--rofi", "-s"]);
            }
        }
    }

    MaterialIcon {
        id: bluetooth

        anchors.horizontalCenter: network.horizontalCenter
        anchors.top: network.bottom
        anchors.topMargin: Appearance.spacing.smaller / 2

        animate: true
        text: Bluetooth.defaultAdapter.enabled ? "bluetooth" : "bluetooth_disabled"
        color: root.colour

        StateLayer {
            anchors.fill: undefined
            anchors.centerIn: parent
            anchors.horizontalCenterOffset: 1

            implicitWidth: parent.implicitHeight + Appearance.padding.small * 2
            implicitHeight: implicitWidth

            radius: Appearance.rounding.full

            hoverEnabled: false

            function onClicked(): void {
                Quickshell.execDetached(["app2unit", "--", "blueman-manager"]);
            }
        }
    }

    Column {
        id: devices

        anchors.horizontalCenter: bluetooth.horizontalCenter
        anchors.top: bluetooth.bottom
        anchors.topMargin: Appearance.spacing.smaller / 2

        spacing: Appearance.spacing.smaller / 2

        Repeater {
            id: repeater

            model: ScriptModel {
                values: Bluetooth.devices.values.filter(d => d.state !== BluetoothDeviceState.Disconnected)
            }

            MaterialIcon {
                id: device

                required property BluetoothDevice modelData

                animate: true
                text: Icons.getBluetoothIcon(modelData.icon)
                color: root.colour
                fill: 1

                SequentialAnimation on opacity {
                    running: device.modelData.state !== BluetoothDeviceState.Connected
                    alwaysRunToEnd: true
                    loops: Animation.Infinite

                    Anim {
                        from: 1
                        to: 0
                        easing.bezierCurve: Appearance.anim.curves.standardAccel
                    }
                    Anim {
                        from: 0
                        to: 1
                        easing.bezierCurve: Appearance.anim.curves.standardDecel
                    }
                }
            }
        }
    }

    MaterialIcon {
        id: battery

        anchors.horizontalCenter: devices.horizontalCenter
        anchors.top: repeater.count > 0 ? devices.bottom : bluetooth.bottom
        anchors.topMargin: Appearance.spacing.smaller / 2

        animate: true
        text: {
            if (!UPower.displayDevice.isLaptopBattery) {
                if (PowerProfiles.profile === PowerProfile.PowerSaver)
                    return "energy_savings_leaf";
                if (PowerProfiles.profile === PowerProfile.Performance)
                    return "rocket_launch";
                return "balance";
            }

            const perc = UPower.displayDevice.percentage;
            const charging = !UPower.onBattery;
            if (perc === 1)
                return charging ? "battery_charging_full" : "battery_full";
            let level = Math.floor(perc * 7);
            if (charging && (level === 4 || level === 1))
                level--;
            return charging ? `battery_charging_${(level + 3) * 10}` : `battery_${level}_bar`;
        }
        color: !UPower.onBattery || UPower.displayDevice.percentage > 0.2 ? root.colour : Colours.palette.m3error
        fill: 1
    }

    Behavior on implicitHeight {
        Anim {}
    }

    component Anim: NumberAnimation {
        duration: Appearance.anim.durations.large
        easing.type: Easing.BezierSpline
        easing.bezierCurve: Appearance.anim.curves.emphasized
    }
}
