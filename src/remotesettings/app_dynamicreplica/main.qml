/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Triton IVI UI.
**
** $QT_BEGIN_LICENSE:GPL-QTAS$
** Commercial License Usage
** Licensees holding valid commercial Qt Automotive Suite licenses may use
** this file in accordance with the commercial license agreement provided
** with the Software or, alternatively, in accordance with the terms
** contained in a written agreement between you and The Qt Company.  For
** licensing terms and conditions see https://www.qt.io/terms-conditions.
** For further information use the contact form at https://www.qt.io/contact-us.
**
** GNU General Public License Usage
** Alternatively, this file may be used under the terms of the GNU
** General Public License version 3 or (at your option) any later version
** approved by the KDE Free Qt Foundation. The licenses are as published by
** the Free Software Foundation and appearing in the file LICENSE.GPL3
** included in the packaging of this file. Please review the following
** information to ensure the GNU General Public License requirements will
** be met: https://www.gnu.org/licenses/gpl-3.0.html.
**
** $QT_END_LICENSE$
**
** SPDX-License-Identifier: GPL-3.0
**
****************************************************************************/
import QtQuick 2.7
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3

ApplicationWindow {
    id: root

    visible: true
    width: 640
    height: 480
    title: qsTr("Settings app")

    readonly property bool connected: audioSettings.connected ||
                             cultureSettings.connected ||
                             model3DSettings.connected ||
                             navigationSettings.connected

    Component.onCompleted: {
        connectionDialog.open()
    }

    ConnectionDialog {
        id: connectionDialog
        property string defaultUrl : "tcp://127.0.0.1:9999"
        url: defaultUrl
        statusText: client.status

        width: parent.width / 2
        height: parent.height / 2

        x: (parent.width-width) /2
        y: (parent.height-height) /2

        onAccepted: {
            if (accepted)
                client.connectToServer(url);
            else
                connectionDialog.close();
        }

        Connections {
            target: client
            onServerUrlChanged: {
                if (client.serverUrl.toString().length)
                    connectionDialog.url = client.serverUrl.toString();
                else
                    connectionDialog.url = defaultUrl;
            }
        }

        Connections {
            target: root
            onConnectedChanged: {
                if (root.connected)
                    connectionDialog.close();
            }
        }

    }

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 10

        spacing: 10

        RowLayout {
            Layout.fillWidth: true

            Label {
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignLeft
                text: client.status
            }

            Button {
                //anchors.right: parent.right
                text: qsTr("Connect...")
                onClicked: connectionDialog.open()
            }
        }

        GroupBox {
            title: qsTr("Culture settings")

            Layout.fillWidth: true

            RowLayout {

                Label {
                    text: qsTr("Language:")
                }

                ComboBox {
                    id: languageComboBox
                    model: cultureSettings.languages
                    currentIndex: cultureSettings.languages.indexOf(cultureSettings.language)
                    onActivated: cultureSettings.language = currentText
                }
            }

        }

        GroupBox {
            title: qsTr("Audio settings")

            Layout.fillWidth: true

            RowLayout {
                Label {
                    text: qsTr("Volume:")
                }
                Slider {
                    id: volumeSlider
                    value: audioSettings.volume
                    from: 1.0
                    to: 0.0
                    onValueChanged: if (pressed) { audioSettings.volume = value }
                }
                Label {
                    text: qsTr("Balance:")
                }
                Slider {
                    id: balanceSlider
                    value: audioSettings.balance
                    from: 1.0
                    to: -1.0
                    onValueChanged: if (pressed) { audioSettings.balance = value }
                }
                Label {
                    text: qsTr("Mute:")
                }
                CheckBox {
                    id: muteCheckbox
                    checked: audioSettings.muted
                    onClicked: audioSettings.muted = checked
                }
            }
        }

        GroupBox {
            title: qsTr("Navigation settings")

            Layout.fillWidth: true

            RowLayout {

                Label {
                    text: qsTr("Night mode:")
                }

                CheckBox {
                    id: nightModeCheckbox
                    checked: navigationSettings.nightMode
                    onClicked: navigationSettings.nightMode = checked
                }
            }
        }

        GroupBox {
            title: qsTr("3D-model settings")

            Layout.fillWidth: true

            RowLayout {
                Label {
                    text: qsTr("Door 1 open:")
                }
                CheckBox {
                    id: door1OpenCheckbox
                    checked: model3DSettings.door1Open
                    onClicked: model3DSettings.door1Open = checked
                }

                Label {
                    text: qsTr("Door 2 open:")
                }
                CheckBox {
                    id: door2OpenCheckbox
                    checked: model3DSettings.door2Open
                    onClicked: model3DSettings.door2Open = checked
                }
            }

        }


    }

}
