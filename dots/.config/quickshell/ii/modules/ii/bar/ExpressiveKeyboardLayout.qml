import qs.modules.common
import qs.modules.common.functions
import qs.modules.common.widgets
import qs.services
import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

MouseArea {
    id: root
    property bool vertical: false
    property bool isMaterial: true // Forced expressive

    readonly property bool hasMultipleLayouts: HyprlandXkb.layoutCodes.length > 1
    visible: HyprlandXkb.layoutCodes.length >= 1

    implicitWidth: vertical ? 40 : pill.implicitWidth
    implicitHeight: vertical ? pillVert.implicitHeight : Appearance.sizes.barHeight
    hoverEnabled: !Config.options.bar.tooltips.clickToShow
    cursorShape: Qt.PointingHandCursor

    function abbreviateLayoutCode(fullCode) {
        if (!fullCode) return "";
        return fullCode.split(':').map(layout => {
            const baseLayout = layout.split('-')[0];
            return baseLayout.slice(0, 2);
        }).join('\n').toUpperCase();
    }

    Process {
        id: switchProc
        command: ["bash", "-c", "hyprctl switchxkblayout all next"]
    }

    onClicked: {
        if (hasMultipleLayouts) {
            switchProc.running = false;
            switchProc.running = true;
        }
    }

    Rectangle {
        id: pill
        visible: !root.vertical
        anchors.centerIn: parent
        color: Appearance.colors.colSecondaryContainer
        radius: Appearance.rounding.full
        implicitWidth: layout.implicitWidth + 8
        implicitHeight: 30

        RowLayout {
            id: layout
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 2
            spacing: 6

            MaterialShape {
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colPrimary
                implicitSize: 26
                MaterialSymbol {
                    anchors.centerIn: parent
                    iconSize: 14
                    text: "keyboard"
                    color: Appearance.colors.colOnPrimary
                }
            }

            StyledText {
                id: layoutText
                text: root.abbreviateLayoutCode(HyprlandXkb.currentLayoutCode).replace(/\n/g, ' ')
                font.pixelSize: 10
                font.weight: Font.Black
                color: Appearance.colors.colPrimary
                animateChange: true
            }
        }
    }

    Rectangle {
        id: pillVert
        visible: root.vertical
        anchors.centerIn: parent
        color: Appearance.colors.colSecondaryContainer
        radius: Appearance.rounding.small
        implicitWidth: 32
        implicitHeight: layoutVert.implicitHeight + 8

        ColumnLayout {
            id: layoutVert
            anchors.centerIn: parent
            spacing: 4

            MaterialShape {
                Layout.alignment: Qt.AlignHCenter
                shapeString: "Cookie12Sided"
                color: Appearance.colors.colPrimary
                implicitSize: 26
                MaterialSymbol {
                    anchors.centerIn: parent
                    iconSize: 14
                    text: "keyboard"
                    color: Appearance.colors.colOnPrimary
                }
            }

            StyledText {
                id: layoutTextVert
                Layout.alignment: Qt.AlignHCenter
                text: root.abbreviateLayoutCode(HyprlandXkb.currentLayoutCode).replace(/\n/g, ' ')
                font.pixelSize: 9
                font.weight: Font.Black
                color: Appearance.colors.colPrimary
                animateChange: true
            }
        }
    }

    KeyboardLayoutPopup {
        id: popup
        hoverTarget: root
    }
}
