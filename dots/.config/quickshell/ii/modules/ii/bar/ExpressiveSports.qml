import QtQuick
import QtQuick.Layouts
import qs.modules.common
import qs.modules.common.widgets
import qs.services
import Quickshell

MouseArea {
    id: root
    property bool vertical: false

    readonly property bool shouldBeVisible: Config.options.bar.sports.enable && SportsService.currentGame !== null
    property var displayGame: SportsService.currentGame
    visible: shouldBeVisible || opacity > 0

    // Animation offsets
    property real verticalOffset: 0
    property real horizontalOffset: 0

    implicitWidth: vertical ? 40 : layout.implicitWidth + 8
    implicitHeight: vertical ? layout.implicitHeight + 8 : Appearance.sizes.barHeight
    width: implicitWidth
    height: implicitHeight
    hoverEnabled: true

    onClicked: SportsService.nextGame()

    // Connections for switch animation
    Connections {
        target: SportsService
        function onCurrentGameChanged() {
            if (shouldBeVisible && displayGame !== SportsService.currentGame) {
                if (displayGame && SportsService.currentGame && displayGame.id === SportsService.currentGame.id) {
                    displayGame = SportsService.currentGame;
                } else {
                    switchAnim.restart();
                }
            }
        }
    }

    SequentialAnimation {
        id: switchAnim
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 0; duration: 150; easing.type: Easing.InSine }
            NumberAnimation { target: root; property: "verticalOffset"; to: vertical ? 0 : 8; duration: 150; easing.type: Easing.InSine }
            NumberAnimation { target: root; property: "horizontalOffset"; to: vertical ? 8 : 0; duration: 150; easing.type: Easing.InSine }
        }
        ScriptAction {
            script: {
                if (SportsService.currentGame) displayGame = SportsService.currentGame;
            }
        }
        PropertyAction { target: root; property: "verticalOffset"; value: vertical ? 0 : -8 }
        PropertyAction { target: root; property: "horizontalOffset"; value: vertical ? -8 : 0 }
        ParallelAnimation {
            NumberAnimation { target: root; property: "opacity"; to: 1; duration: 150; easing.type: Easing.OutSine }
            NumberAnimation { target: root; property: "verticalOffset"; to: 0; duration: 150; easing.type: Easing.OutSine }
            NumberAnimation { target: root; property: "horizontalOffset"; to: 0; duration: 150; easing.type: Easing.OutSine }
        }
    }

    RowLayout {
        id: layout
        visible: !root.vertical
        anchors.centerIn: parent
        spacing: 4
        transform: Translate { x: root.horizontalOffset; y: root.verticalOffset }

        MaterialShape {
            shapeString: "Cookie7Sided"
            color: Appearance.colors.colSecondaryContainer
            implicitSize: 30
            StyledImage {
                anchors.centerIn: parent
                width: 18
                height: 18
                source: root.displayGame ? root.displayGame.home.logo : ""
            }
        }

        Rectangle {
            id: statusPill
            Layout.preferredHeight: 22
            Layout.preferredWidth: Math.max(statusText.implicitWidth + 16, 30)
            radius: Appearance.rounding.full
            color: Appearance.colors.colPrimary
            
            StyledText {
                id: statusText
                anchors.centerIn: parent
                // If game state is "in" (active), show score. Otherwise show full status (time/date)
                text: root.displayGame ? (root.displayGame.state === "in" ? `${root.displayGame.home.score} - ${root.displayGame.away.score}` : root.displayGame.status) : ""
                font.pixelSize: 10
                font.weight: Font.Black
                color: Appearance.colors.colOnPrimary
                animateChange: true
            }
        }

        MaterialShape {
            shapeString: "Cookie7Sided"
            color: Appearance.colors.colSecondaryContainer
            implicitSize: 30
            StyledImage {
                anchors.centerIn: parent
                width: 18
                height: 18
                source: root.displayGame ? root.displayGame.away.logo : ""
            }
        }
    }

    ColumnLayout {
        id: layoutVert
        visible: root.vertical
        anchors.centerIn: parent
        spacing: 4
        transform: Translate { x: root.horizontalOffset; y: root.verticalOffset }

        MaterialShape {
            Layout.alignment: Qt.AlignHCenter
            shapeString: "Cookie7Sided"
            color: Appearance.colors.colSecondaryContainer
            implicitSize: 30
            StyledImage {
                anchors.centerIn: parent
                width: 18
                height: 18
                source: root.displayGame ? root.displayGame.home.logo : ""
            }
        }

        Rectangle {
            Layout.alignment: Qt.AlignHCenter
            Layout.preferredWidth: 30
            Layout.preferredHeight: statusTextVert.implicitHeight + 8
            radius: Appearance.rounding.small
            color: Appearance.colors.colPrimary
            
            StyledText {
                id: statusTextVert
                anchors.centerIn: parent
                text: root.displayGame ? (root.displayGame.state === "in" ? `${root.displayGame.home.score}\n${root.displayGame.away.score}` : root.displayGame.status) : ""
                font.pixelSize: 9
                font.weight: Font.Black
                color: Appearance.colors.colOnPrimary
                horizontalAlignment: Text.AlignHCenter
                animateChange: true
            }
        }

        MaterialShape {
            Layout.alignment: Qt.AlignHCenter
            shapeString: "Cookie7Sided"
            color: Appearance.colors.colSecondaryContainer
            implicitSize: 30
            StyledImage {
                anchors.centerIn: parent
                width: 18
                height: 18
                source: root.displayGame ? root.displayGame.away.logo : ""
            }
        }
    }

    SportsPopup {
        hoverTarget: root
    }
}
