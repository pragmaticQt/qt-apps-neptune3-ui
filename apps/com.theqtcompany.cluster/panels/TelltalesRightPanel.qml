/****************************************************************************
**
** Copyright (C) 2017 The Qt Company Ltd.
** Copyright (C) 2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune 3 Cluster UI.
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

import QtQuick 2.0
import QtQuick.Layouts 1.3
//import Qt.SafeRenderer 1.0
import controls 1.0
import helpers 1.0

Item {
    id: root
    width: 444
    height: 58

    //public
    property bool rightTurnOn: true
    property bool absFailureOn: true
    property bool parkingBrakeOn: true
    property bool lowTyrePressureOn: true
    property bool brakeFailureOn: true
    property bool airbagFailureOn: true

    //private
    QtObject {
        id: d
        property real scaleRatio: root.height / 58
    }

    // Uncomment below to render BG when safe renderer is in use
//    Image {
//        id: bg
//        anchors.fill: parent
//        source: "./img/telltales/telltale-bg-right.png"
//    }

    Blinker {
        id: blinker
        running: root.rightTurnOn
    }

    RowLayout {
        anchors.fill: parent
        spacing: root.width * 0.07

        Image {
            opacity: blinker.lit ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-right-turn")
            Layout.preferredWidth: 53 * d.scaleRatio
            Layout.preferredHeight: 48 * d.scaleRatio
        }

        Image {
            opacity: root.absFailureOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-abs-fault")
            Layout.preferredWidth: 40 * d.scaleRatio
            Layout.preferredHeight: 30 * d.scaleRatio
        }

        Image {
            opacity: root.parkingBrakeOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-parking-brake")
            Layout.preferredWidth: 40 * d.scaleRatio
            Layout.preferredHeight: 30 * d.scaleRatio
        }

        Image {
            opacity: root.lowTyrePressureOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-tire-pressure")
            Layout.preferredWidth: 34 * d.scaleRatio
            Layout.preferredHeight: 30 * d.scaleRatio
        }

        Image {
            opacity: root.brakeFailureOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("./telltales/ic-brake-fault")
            Layout.preferredWidth: 40 * d.scaleRatio
            Layout.preferredHeight: 30 * d.scaleRatio
        }

        Image {
            opacity: root.airbagFailureOn ? 1 : 0
            fillMode: Image.PreserveAspectFit
            source: Utils.localAsset("/telltales/ic-airbag")
            Layout.preferredWidth: 35 * d.scaleRatio
            Layout.preferredHeight: 34 * d.scaleRatio
        }
    }
}
