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

import QtQuick 2.6
import QtQuick.Controls 2.2
import QtQml.Models 2.1
import QtQuick.Layouts 1.0
import controls 1.0
import utils 1.0

import models.application 1.0

Item {
    id: root

    Layout.fillWidth: true
    height: Style.hspan(4.5) * Math.ceil(model.count/root.numIconsPerRow)

    property alias gridEditMode: grid.editMode
    property alias model: visualModel.model
    property alias gridCellWidth: grid.cellWidth
    readonly property int numIconsPerRow: 4

    property bool gridOpen: false
    onGridOpenChanged: {
        if (!root.gridOpen) {
            grid.editMode = false
        }
    }

    signal buttonCreated(var button)
    signal buttonRemoved(var button)
    signal appButtonClicked(var applicationId)

    DelegateModel {
        id: visualModel
        delegate: MouseArea {
            id: delegateRoot

            property int visualIndex: DelegateModel.itemsIndex

            width: grid.cellWidth
            height: width

            AppButton {
                id: appButton
                width: root.gridOpen ? Style.hspan(4) : Style.hspan(1.5)
                height: root.gridOpen ? width : Style.vspan(1.4)

                Behavior on height {
                    NumberAnimation {
                        duration: 200
                    }
                }

                anchors.horizontalCenter: parent.horizontalCenter;
                anchors.verticalCenter: parent.verticalCenter;

                property var appInfo: ApplicationManagerModel.application(model.applicationId)
                Connections {
                    target: appButton.appInfo
                    onActiveChanged: {
                        if (appButton.appInfo.active) {
                            appButton.checked = true;
                        } else {
                            appButton.checked = false;
                        }
                    }
                }

                opacity: {
                    if (delegateRoot.visualIndex > (root.numIconsPerRow - 1)) {
                        if (root.gridOpen) {
                            return 1.0
                        } else {
                            return 0.0
                        }
                    }
                    return 1.0
                }
                Behavior on opacity {
                    NumberAnimation {
                        duration: 200
                    }
                }

                editModeBgOpacity: Drag.active ? 0.8 : grid.editMode ? 0.2 : 0.0
                editModeBgColor: Drag.active ? "#404142" : "#F1EFED"

                iconSource: model.icon
                labelText: model.name
                gridOpen: root.gridOpen

                Drag.active: delegateRoot.drag.active
                Drag.source: delegateRoot
                Drag.hotSpot.x: width / 2
                Drag.hotSpot.y: height / 2

                states: [
                    State {
                        when: appButton.Drag.active
                        ParentChange {
                            target: appButton
                            parent: grid
                        }

                        AnchorChanges {
                            target: appButton;
                            anchors.horizontalCenter: undefined;
                            anchors.verticalCenter: undefined
                        }
                    }
                ]

                Component.onCompleted: root.buttonCreated(appButton)
                Component.onDestruction: root.buttonRemoved(appButton)
            }

            DropArea {
                anchors { fill: parent; }
                onEntered: visualModel.items.move(drag.source.visualIndex, delegateRoot.visualIndex)
            }

            onClicked: {
                if (!grid.editMode) {
                    root.appButtonClicked(model.applicationId);
                }
            }

            onPressed: {
                if (grid.editMode) {
                    drag.target = appButton;
                }
            }

            onPressAndHold: {
                if (root.gridOpen) {
                    grid.editMode = true;
                    drag.target = appButton;
                }
            }
            onReleased: {
                drag.target = undefined;
            }
        }
    }

    GridView {
        id: grid

        Layout.alignment: Qt.AlignTop
        anchors.fill: parent

        property bool editMode: false

        interactive: false
        model: visualModel
        cellWidth: width / root.numIconsPerRow
        cellHeight: cellWidth

        displaced: Transition {
            NumberAnimation { properties: "x,y"; easing.type: Easing.OutQuad }
        }
    }

    ToolButton {
        id: exitEditMode
        width: root.width
        height: Style.vspan(1)
        opacity: grid.editMode ? 1.0 : 0.0
        Behavior on opacity {
            NumberAnimation {
                duration: 200
            }
        }
        anchors.top: grid.bottom
        anchors.topMargin: 30

        background: Rectangle {
            width: root.width
            height: Style.vspan(1)
            color: "#1c1a18"
        }

        contentItem: Label {
            text: exitEditMode.text
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
        }

        text: "Finish Editing"
        onClicked: grid.editMode = false
    }
}