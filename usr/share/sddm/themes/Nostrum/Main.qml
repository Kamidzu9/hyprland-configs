import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Effects
import SddmComponents 2.0
import "."

Rectangle {
    id: container
    LayoutMirroring.enabled: Qt.locale().textDirection === Qt.RightToLeft
    LayoutMirroring.childrenInherit: true
    property int sessionIndex: session.index
    property date dateTime: new Date()

    TextConstants {
        id: textConstants
    }

    Connections {
        target: sddm
        function onLoginSucceeded() {
            errorMessage.text = textConstants.loginSucceeded
        }
        function onLoginFailed() {
            password.text = ""
            errorMessage.color = "#ffff33"
            errorMessage.text = textConstants.loginFailed
        }
    }

    color: "#1e1c2c"
    anchors.fill: parent

    Image {
        id: behind
        anchors.fill: parent
        source: config.background
        fillMode: Image.Stretch
        onStatusChanged: {
            if (config.type === "color") {
                source = config.defaultBackground
            }
        }
    }

    MultiEffect {
        source: behind
        anchors.fill: behind
        brightness: -0.15
        contrast: -0.4
        blurEnabled: true
        blurMax: 48
        blur: 0.5
    }

    Rectangle {
        id: rightblob
        color: "transparent"
        anchors.top: parent.top
        anchors.right: parent.right
        height: parent.height
        width: parent.width / 3

        Column {
            id: inputstack
            anchors.left: parent.left
            anchors.verticalCenter: parent.verticalCenter
            spacing: 6

            Text {
                id: userlabel
                font.pointSize: 10
                text: textConstants.userName
                color: "#f8f8f8"
            }

            Image {
                source: "assets/input.svg"
                width: 280
                height: 28

                TextField {
                    id: nameinput
                    focus: true
                    anchors.fill: parent
                    text: userModel.lastUser
                    font.pointSize: 10
                    leftPadding: 12
                    color: "white"
                    background: Image {
                        id: textback
                        source: "assets/inputhi.svg"

                        states: [
                            State {
                                name: "yay"
                                PropertyChanges {
                                    target: textback
                                    opacity: 1
                                }
                            },
                            State {
                                name: "nay"
                                PropertyChanges {
                                    target: textback
                                    opacity: 0
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                to: "yay"
                                NumberAnimation {
                                    target: textback
                                    property: "opacity"
                                    from: 0
                                    to: 1
                                    duration: 200
                                }
                            },

                            Transition {
                                to: "nay"
                                NumberAnimation {
                                    target: textback
                                    property: "opacity"
                                    from: 1
                                    to: 0
                                    duration: 200
                                }
                            }
                        ]
                    }

                    KeyNavigation.tab: password
                    KeyNavigation.backtab: session

                    Keys.onPressed: (event)=> {
                        if (event.key === Qt.Key_Return
                                || event.key === Qt.Key_Enter) {
                            password.focus = true
                        }
                    }

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            textback.state = "yay"
                        } else {
                            textback.state = "nay"
                        }
                    }
                }
            }

            Text {
                id: passwordlabel
                text: textConstants.password
                color: "#f8f8f8"
                font.pointSize: 10
            }

            Image {
                source: "assets/input.svg"
                width: 280
                height: 28
                TextField {
                    id: password
                    anchors.fill: parent
                    font.pointSize: 10
                    leftPadding: 12
                    echoMode: TextInput.Password
                    color: "white"

                    background: Image {
                        id: textback1
                        source: "assets/inputhi.svg"

                        states: [
                            State {
                                name: "yay1"
                                PropertyChanges {
                                    target: textback1
                                    opacity: 1
                                }
                            },
                            State {
                                name: "nay1"
                                PropertyChanges {
                                    target: textback1
                                    opacity: 0
                                }
                            }
                        ]

                        transitions: [
                            Transition {
                                to: "yay1"
                                NumberAnimation {
                                    target: textback1
                                    property: "opacity"
                                    from: 0
                                    to: 1
                                    duration: 200
                                }
                            },

                            Transition {
                                to: "nay1"
                                NumberAnimation {
                                    target: textback1
                                    property: "opacity"
                                    from: 1
                                    to: 0
                                    duration: 200
                                }
                            }
                        ]
                    }

                    KeyNavigation.tab: session
                    KeyNavigation.backtab: nameinput

                    Keys.onPressed: (event)=> {
                        if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                            sddm.login(nameinput.text, password.text, sessionIndex)
                            event.accepted = true
                        }
                    }

                    onActiveFocusChanged: {
                        if (activeFocus) {
                            textback1.state = "yay1"
                        } else {
                            textback1.state = "nay1"
                        }
                    }
                }
            }
        }

        Image {
            id: loginButton
            source: "assets/buttonup.svg"
            anchors.right: inputstack.right
            anchors.top: inputstack.bottom
            anchors.topMargin: 32
            width: 84
            height: 28

            MouseArea {
                anchors.fill: parent
                hoverEnabled: true
                onEntered: {
                    parent.source = "assets/buttonhover.svg"
                }
                onExited: {
                    parent.source = "assets/buttonup.svg"
                }
                onPressed: {
                    parent.source = "assets/buttondown.svg"
                    sddm.login(nameinput.text, password.text, sessionIndex)
                }
                onReleased: {
                    parent.source = "assets/buttonup.svg"
                }
            }

            Text {
                text: textConstants.login
                anchors.centerIn: parent
                font.pointSize:  8
                font.bold: true
                color: "white"
            }
        }
    }

    Rectangle {
        id: leftblob
        color: "transparent"
        anchors.top: parent.top
        anchors.left: parent.left
        height: parent.height
        width: parent.width / 3

        Column {
            id: leftstack
            anchors.right: parent.right
            anchors.verticalCenter: parent.verticalCenter
            spacing: 1
            Timer {
                interval: 100; running: true; repeat: true;
                onTriggered: container.dateTime = new Date()
            }

            Text {
                    id : time
                    anchors.right : parent.right
                    color : "#f8f8f8"
                    text: Qt.formatDateTime(container.dateTime, "h:mm ap")
                    font.pointSize: 28
                    font.bold: false
                }
            Text {
                    id : time2
                    anchors.right : parent.right
                    color : "#cdcdcd"
                    text: Qt.formatDateTime(container.dateTime, "dddd MMMM d")
                    font.pointSize: 10
                    font.bold: false
                }
            Rectangle {
                width: 16
                height: 12
                color: "transparent"
            }

            ComboBox {
                id: session
                anchors.right: parent.right
                color: "#3b3749"
                // borderColor: "#575268"
                hoverColor: "#fe7551"
                // focusColor: "#f8724f"
                textColor: "#f8f8f8"
                menuColor: "#3b3749"
                // arrowColor: "#3b3749"
                // borderWidth: 1
                width: 252
                height: 28
                font.pointSize: 10
                // font.family: "Noto Sans"
                arrowBox: "assets/comboarrow.svg"
                backgroundNormal: "assets/cbox.svg"
                backgroundHover: "assets/cboxhover.svg"
                backgroundPressed: "assets/cbox.svg"
                model: sessionModel
                index: sessionModel.lastIndex
                KeyNavigation.backtab: password
                KeyNavigation.tab: nameinput
            }
        }
    }

    Rectangle {
        id: buttonHolder
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: 150
        height: parent.height / 6
        color: "transparent"

        Column {
            anchors.left: parent.left
            anchors.top: parent.top

            Image {
                id: shutdownButton
                source: "assets/shutdown.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                // anchors.left: parent.left
                // anchors.top: parent.top
                height: 32
                width: 32

                property string toolTipText1: textConstants.shutdown
                ToolTip.text: toolTipText1
                ToolTip.delay: 500
                ToolTip.visible: toolTipText1 ? ma1.containsMouse : false

                MouseArea {
                    id: ma1
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "assets/shutdownhover.svg"
                    }
                    onExited: {
                        parent.source = "assets/shutdown.svg"
                    }
                    onPressed: {
                        parent.source = "assets/shutdownpressed.svg"
                        sddm.powerOff()
                    }
                    onReleased: {
                        parent.source = "assets/shutdown.svg"
                    }
                }
            }

            Text {
                color: "#cecece"
                font.pointSize: 8
                text: textConstants.shutdown
            }
        }

        Column {
            anchors.right: parent.right
            anchors.top: parent.top

            Image {
                id: rebootButton
                source: "assets/reboot.svg"
                anchors.horizontalCenter: parent.horizontalCenter
                height: 32
                width: 32

                property string toolTipText2: textConstants.reboot
                ToolTip.text: toolTipText2
                ToolTip.delay: 500
                ToolTip.visible: toolTipText2 ? ma2.containsMouse : false

                MouseArea {
                    id: ma2
                    anchors.fill: parent
                    hoverEnabled: true
                    onEntered: {
                        parent.source = "assets/reboothover.svg"
                    }
                    onExited: {
                        parent.source = "assets/reboot.svg"
                    }
                    onPressed: {
                        parent.source = "assets/rebootpressed.svg"
                        sddm.reboot()
                    }
                    onReleased: {
                        parent.source = "assets/reboot.svg"
                    }
                }
            }

            Text {
                color: "#cecece"
                font.pointSize: 8
                text: textConstants.reboot
            }
        }
    }

    Rectangle {
        id: titleblob
        color: "transparent"
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        height: parent.height / 3
        width: parent.width

        Column {
            id: headingstack
            anchors.bottom: parent.bottom
            anchors.horizontalCenter: parent.horizontalCenter
            spacing: 7

            Text {
                id: lblSession
                anchors.horizontalCenter: parent.horizontalCenter
                text: textConstants.welcomeText.arg(sddm.hostName)
                font.pointSize: 28
                color: "#f8f8f8"
            }

            Text {
                id: errorMessage
                anchors.horizontalCenter: parent.horizontalCenter
                text: textConstants.prompt
                font.pixelSize: 11
                color: "#cecece"
            }
        }
    }

    Component.onCompleted: {
        nameinput.focus = true
        textback1.state = "nay1" //dunno why both inputs get focused
    }
}
