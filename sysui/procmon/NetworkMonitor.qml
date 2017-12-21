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

import QtQuick 2.8
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3

import utils 1.0
import com.pelagicore.systeminfo 1.0
import com.pelagicore.styles.triton 1.0

Item {
    id: root
    width: 640
    height: 400

    SystemInfo {
        id: info
    }

    property var model: info.addressList

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 16
        Label {
            id: descriptionText
            Layout.fillWidth: true
            font.pixelSize: Style.fontSizeL
            text: qsTr("Network")
        }
        ListView {
            id: view
            clip: true
            Layout.fillWidth: true
            Layout.fillHeight: true
            model: root.model
            delegate: ItemDelegate {
                width: ListView.view.width
                text: modelData
                font.pixelSize: Style.fontSizeM
            }
            ScrollBar.vertical: ScrollBar { }
        }
    }
}