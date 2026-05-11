import qs.modules.common
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts

Item {
    id: root
    property bool vertical: false
    property bool borderless: Config.options.bar.borderless
    property bool showDate: Config.options.bar.verbose
    property bool isMaterial: true

    implicitWidth: vertical ? Appearance.sizes.verticalBarWidth : (rowLoader.item?.implicitWidth ?? 0) + 8
    implicitHeight: vertical ? (colLoader.item?.implicitHeight ?? 0) + 8 : Appearance.sizes.barHeight

    width: implicitWidth
    height: implicitHeight

    // Vertical
    Loader {
        id: colLoader
        active: root.vertical
        visible: active
        anchors.centerIn: parent
        sourceComponent: ColumnLayout {
            spacing: 4
            property var timeParts: DateTime.time.split(/[: ]/)
            property string hours: timeParts[0] ?? "00"
            property string minutes: timeParts[1] ?? "00"
            property string ampm: timeParts[2] ?? ""

            MaterialShape {
                Layout.alignment: Qt.AlignHCenter
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colPrimary
                implicitSize: 28
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.weight: Font.Black
                    color: Appearance.colors.colOnPrimary
                    text: parent.parent.hours.padStart(2, "0")
                    font.features: { "tnum": 1 }
                }
            }

            MaterialShape {
                Layout.alignment: Qt.AlignHCenter
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colSecondaryContainer
                implicitSize: 28
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.weight: Font.Black
                    color: Appearance.colors.colPrimary
                    text: parent.parent.minutes.padStart(2, "0")
                    font.features: { "tnum": 1 }
                }
            }

            MaterialShape {
                visible: parent.ampm !== ""
                Layout.alignment: Qt.AlignHCenter
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colTertiaryContainer
                implicitSize: 24
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    font.weight: Font.Black
                    color: Appearance.colors.colPrimary
                    text: parent.parent.ampm
                }
            }
        }
    }

    // Horizontal
    Loader {
        id: rowLoader
        active: !root.vertical
        visible: active
        anchors.centerIn: parent
        sourceComponent: RowLayout {
            spacing: 4
            property var timeParts: DateTime.time.split(/[: ]/)
            property string hours: timeParts[0] ?? "00"
            property string minutes: timeParts[1] ?? "00"
            property string ampm: timeParts[2] ?? ""

            MaterialShape {
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colPrimary
                implicitSize: 28
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.weight: Font.Black
                    color: Appearance.colors.colOnPrimary
                    text: parent.parent.hours.padStart(2, "0")
                    font.features: { "tnum": 1 }
                }
            }

            StyledText {
                text: ":"
                color: Appearance.colors.colPrimary
                font.pixelSize: Appearance.font.pixelSize.large
                font.weight: Font.Black
                Layout.alignment: Qt.AlignVCenter
            }

            MaterialShape {
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colSecondaryContainer
                implicitSize: 28
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.small
                    font.weight: Font.Black
                    color: Appearance.colors.colPrimary
                    text: parent.parent.minutes.padStart(2, "0")
                    font.features: { "tnum": 1 }
                }
            }

            MaterialShape {
                visible: parent.ampm !== ""
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colTertiaryContainer
                implicitSize: 24
                StyledText {
                    anchors.centerIn: parent
                    font.pixelSize: Appearance.font.pixelSize.smaller
                    font.weight: Font.Black
                    color: Appearance.colors.colPrimary
                    text: parent.parent.ampm
                }
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: !Config.options.bar.tooltips.clickToShow
        ClockWidgetPopup {
            hoverTarget: mouseArea
        }
    }
}