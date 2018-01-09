/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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
import QtQuick 2.9
import QtGraphicalEffects 1.0
import QtQuick.Controls 2.3

Item {
    id: root

    ListView {
        width: 820
        height: (spacing + 50) * 7

        spacing: 44
        orientation: Qt.Vertical
        interactive: false
        model: VehicleControlModel
        delegate: Item {
            width: parent.width * 0.9
            height: 50

            Image {
                id: supportDelegateIconImage
                anchors.left: parent.left
                anchors.leftMargin: 30
                source: "assets/images/" + icon
            }

            ColorOverlay {
                anchors.fill: supportDelegateIconImage
                source: supportDelegateIconImage
                color: "#171717"
            }

            Text {
                text: qsTranslate("VehicleControlModel", name)
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: supportDelegateIconImage.right
                anchors.leftMargin: 28

                font {
                    pixelSize: 26
                    family: "Open Sans"
                    weight: Font.Light
                }
                opacity: 0.94
                color: "#171717"
            }

            Switch {
                anchors.top: parent.top
                anchors.topMargin: 2
                anchors.right: parent.right
                anchors.rightMargin: 2
                checked: active
            }

            Rectangle {
                height: 1
                width: parent.width
                color: "#bfbbb9"
                anchors.bottom: parent.bottom
                anchors.bottomMargin: -18
                anchors.left: parent.left
                anchors.leftMargin: 20
            }
        }
    }
}