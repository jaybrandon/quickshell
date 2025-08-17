pragma ComponentBehavior: Bound

import qs.components
import qs.services
import qs.config
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Column {
    id: root

    anchors.left: parent.left
    anchors.right: parent.right
    padding: Appearance.padding.large
    spacing: Appearance.spacing.small

    property date currentDate: new Date()

    RowLayout {
        id: monthNavigationRow

        width: parent.width - (root.padding * 2)
        spacing: Appearance.spacing.small

        Item {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30

            StyledText {
                id: previousMonthText
                anchors.centerIn: parent
                text: "<"
                color: Colours.palette.m3tertiary
                font.pointSize: Appearance.font.size.normal
                font.weight: 700
            }

            StateLayer {
                id: previousMonthMouseArea
                anchors.fill: parent
                hoverEnabled: true
                radius: Appearance.rounding.full
                onClicked: {
                    root.currentDate = new Date(root.currentDate.getFullYear(), root.currentDate.getMonth() - 1, 1);
                }
            }
        }

        StyledText {
            id: monthYearDisplay

            Layout.fillWidth: true
            horizontalAlignment: Text.AlignHCenter
            text: Qt.formatDateTime(root.currentDate, "MMMM yyyy")
            color: Colours.palette.m3tertiary
            font.pointSize: Appearance.font.size.normal
            font.weight: 500
        }

        Item {
            Layout.preferredWidth: 30
            Layout.preferredHeight: 30

            StyledText {
                id: nextMonthText
                anchors.centerIn: parent
                text: ">"
                color: Colours.palette.m3tertiary
                font.pointSize: Appearance.font.size.normal
                font.weight: 700
            }

            StateLayer {
                id: nextMonthMouseArea
                anchors.fill: parent
                hoverEnabled: true
                radius: Appearance.rounding.full
                onClicked: {
                    root.currentDate = new Date(root.currentDate.getFullYear(), root.currentDate.getMonth() + 1, 1);
                }
            }
        }
    }

    DayOfWeekRow {
        id: daysRow

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: parent.padding

        delegate: StyledText {
            required property var model

            horizontalAlignment: Text.AlignHCenter
            text: model.shortName
            font.family: Appearance.font.family.sans
            font.weight: 500
            color: (model.index === 5 || model.index === 6) ? Colours.palette.m3tertiary : Colours.palette.m3onSurfaceVariant
        }
    }

    MonthGrid {
        id: grid

        month: root.currentDate.getMonth()
        year: root.currentDate.getFullYear()

        anchors.left: parent.left
        anchors.right: parent.right
        anchors.margins: parent.padding

        spacing: 3

        delegate: Item {
            id: dayItem

            required property var model

            implicitWidth: implicitHeight
            implicitHeight: text.implicitHeight + Appearance.padding.small * 2

            StyledRect {
                anchors.centerIn: parent

                implicitWidth: parent.implicitHeight
                implicitHeight: parent.implicitHeight

                radius: Appearance.rounding.full
                color: Qt.alpha(Colours.palette.m3primary, dayItem.model.today ? 1 : 0)

                StyledText {
                    id: text

                    anchors.centerIn: parent

                    horizontalAlignment: Text.AlignHCenter
                    text: Qt.formatDate(dayItem.model.date, "d")
                    color: {
                        var dayOfWeek = dayItem.model.date.getDay();
                        if (dayItem.model.today) {
                            return Colours.palette.m3onPrimary;
                        } else if (dayOfWeek === 0 || dayOfWeek === 6) {
                            return Colours.palette.m3tertiary;
                        } else if (dayItem.model.month === grid.month) {
                            return Colours.palette.m3onSurfaceVariant;
                        } else {
                            return Colours.palette.m3outline;
                        }
                    }
                    opacity: dayItem.model.month === grid.month ? 1.0 : 0.4
                    font.pointSize: Appearance.font.size.normal
                    font.weight: 500
                }
            }
        }
    }
}
