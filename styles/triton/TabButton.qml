/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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

import QtQuick 2.10
import QtQuick.Controls 2.3
import QtQuick.Controls.impl 2.3
import QtQuick.Templates 2.3 as T

import com.pelagicore.styles.triton 1.0
import utils 1.0

T.TabButton {
    id: control

    font.pixelSize: TritonStyle.fontSizeS

    implicitWidth: Math.max(background ? background.implicitWidth : 0,
                            contentItem.implicitWidth + leftPadding + rightPadding)
    implicitHeight: Math.max(background ? background.implicitHeight : 0,
                             contentItem.implicitHeight + topPadding + bottomPadding)
    baselineOffset: contentItem.y + contentItem.baselineOffset

    contentItem: IconLabel {
        spacing: control.spacing
        mirrored: control.mirrored
        display: control.display

        icon: control.icon
        text: control.text
        font: control.font
        color: TritonStyle.mainColor
    }

    readonly property string positionState: {
        if (TabBar.index == 0) {
            return "left";
        } else if (TabBar.index ==  TabBar.tabBar.contentModel.count -1) {
            return "right";
        } else {
            return "middle";
        }
    }

    readonly property bool selected: TabBar.tabBar.currentIndex == TabBar.index

    background: BorderImage {
        id: borderImage
        anchors.fill: parent
        source: Style.gfx2("tabbar-bg-" + control.positionState, TritonStyle.theme)

        opacity: (control.selected ? 0.7 : 0.3) + (control.pressed ? 0.1 : 0)

        state: control.positionState
        states: [
            State {
                name: "left"
                PropertyChanges {
                    target: borderImage
                    border.left: 26
                    border.right: 0
                    border.top: 22
                    border.bottom: 48 - 25
                }
            },
            State {
                name: "right"
                PropertyChanges {
                    target: borderImage
                    border.left: 0
                    border.right: 30 - 5
                    border.top: 22
                    border.bottom: 48 - 25
                }
            }
        ]
        horizontalTileMode: BorderImage.Stretch
        verticalTileMode: BorderImage.Stretch
    }
}
