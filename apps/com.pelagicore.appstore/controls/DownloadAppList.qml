/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 IVI UI.
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
import QtQuick.Layouts 1.0

import controls 1.0
import utils 1.0
import com.pelagicore.styles.neptune 3.0

ListView {
    id: root

    property string appServerUrl
    property real installationProgress: 1.0
    property var installedApps: []
    signal toolClicked(var appId)

    onInstallationProgressChanged: {
        if (installationProgress === 1.0) {
            root.currentIndex = -1;
        }
    }

    currentIndex: -1

    delegate: ListItem {
        id: delegatedItem
        width: NeptuneStyle.dp(675)
        height: NeptuneStyle.dp(80)
        property bool isInstalled: root.installedApps.indexOf(model.id) !== -1

        icon.source: root.appServerUrl + "/app/icon?id=" + model.id
        text: model.name
        rightToolSymbol: delegatedItem.isInstalled ? "ic-close" : "ic-download_OFF"
        onRightToolClicked: {
            if (!delegatedItem.isInstalled) {
                root.currentIndex = index;
            }
            root.toolClicked(model.id);
        }

        ProgressBar {
            id: control

            height: NeptuneStyle.dp(8)
            anchors.bottom: parent.bottom
            value: root.installationProgress
            padding: 2
            visible: root.currentIndex === index && root.installationProgress < 1.0

            background: null

            contentItem: Item {
                implicitWidth: NeptuneStyle.dp(675)
                implicitHeight: NeptuneStyle.dp(4)

                Rectangle {
                    width: control.visualPosition * parent.width
                    height: parent.height
                    color: NeptuneStyle.accentColor
                }
            }
        }
    }
}
