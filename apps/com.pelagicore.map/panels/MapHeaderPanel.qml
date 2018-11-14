/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AB
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
import QtQuick.Controls 2.2
import QtQuick.Layouts 1.3
import QtPositioning 5.9

import shared.utils 1.0
import shared.Sizes 1.0
import shared.controls 1.0 as NeptuneControls
import shared.animations 1.0

Item {
    id: root

    implicitHeight: headerBackgroundFullscreen.height

    property bool offlineMapsEnabled
    property bool navigationMode
    property bool guidanceMode
    property var currentLocation

    property string destination: ""
    property string routeDistance: ""
    property string routeTime: ""
    property string homeRouteTime: ""
    property string workRouteTime: ""

    // TODO make the locations configurable and dynamic
    readonly property var homeAddressData: QtPositioning.coordinate(57.706436, 12.018661)
    readonly property var workAddressData: QtPositioning.coordinate(57.709545, 11.967005)

    readonly property int destinationButtonrowHeight: Sizes.dp(150)

    signal showRoute(var destCoord, string description)
    signal startNavigation()
    signal stopNavigation()
    signal openSearchTextInput()

    Loader {
        id: headerBackgroundFullscreen
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: Sizes.dp(210)
        active: root.state === "Maximized"
        sourceComponent: HeaderBackgroundMaximizedPanel {
            navigationMode: root.navigationMode
            guidanceMode: root.guidanceMode
            destinationButtonrowHeight: root.destinationButtonrowHeight
        }
    }

    Loader {
        id: headerBackgroundWidget
        anchors.left: parent.left
        anchors.right: parent.right
        anchors.top: parent.top
        active: root.state === "Widget2Rows" || root.state === "Widget3Rows"
        sourceComponent: HeaderBackgroundWidgetPanel {
            state: root.state
        }
    }

    Loader {
        id: navigationSearchButtonsFullscreen
        width: headerBackgroundFullscreen.width - Sizes.dp(90)
        height: headerBackgroundFullscreen.height
        active: headerBackgroundFullscreen.active && !root.navigationMode
        anchors.top: headerBackgroundFullscreen.top
        anchors.topMargin: Sizes.dp(112)
        anchors.horizontalCenter: headerBackgroundFullscreen.horizontalCenter
        sourceComponent: NavigationSearchPanel {
            offlineMapsEnabled: root.offlineMapsEnabled
            onOpenSearchTextInput: root.openSearchTextInput()
        }
    }

    Loader {
        id: navigationSearchButtonsWidget
        width: headerBackgroundWidget.width - Sizes.dp(184) // compensate for the "expand" button in the widget corner
        active: headerBackgroundWidget.active
        anchors.top: headerBackgroundWidget.top
        anchors.topMargin: Sizes.dp(48)
        anchors.horizontalCenter: headerBackgroundWidget.horizontalCenter
        sourceComponent: NavigationSearchPanel {
            offlineMapsEnabled: root.offlineMapsEnabled
            onOpenSearchTextInput: root.openSearchTextInput()
        }
    }

    Loader {
        id: navigationConfirmButtons
        anchors.fill: headerBackgroundFullscreen
        anchors.rightMargin: Sizes.dp(45 * .5)
        active: headerBackgroundFullscreen.active && root.navigationMode
        sourceComponent: NavigationConfirmPanel {
            guidanceMode: root.guidanceMode
            destination: root.destination
            routeDistance: root.routeDistance
            routeTime: root.routeTime
            onStartNavigation: root.startNavigation()
            onStopNavigation: root.stopNavigation()
        }

    }

    Loader {
        id: favoriteDestinationButtonsFullscreen
        anchors.top: headerBackgroundFullscreen.top
        anchors.topMargin: headerBackgroundFullscreen.height - height
        anchors.left: headerBackgroundFullscreen.left
        anchors.leftMargin: Sizes.dp(45)
        anchors.right: headerBackgroundFullscreen.right
        anchors.rightMargin: Sizes.dp(45 * 1.5)
        height: root.destinationButtonrowHeight
        active: headerBackgroundFullscreen.active && !root.navigationMode
        sourceComponent: FavDestinationButtonsPanel {
            offlineMapsEnabled: root.offlineMapsEnabled
            homeAddressData: root.homeAddressData
            workAddressData: root.workAddressData
            homeRouteTime: root.homeRouteTime
            workRouteTime: root.workRouteTime
            onShowRoute: root.showRoute(destCoord, description);
        }
    }

    Loader {
        id: favoriteDestinationButtonsWidget
        anchors.top: headerBackgroundWidget.top
        anchors.topMargin: Sizes.dp(130)
        anchors.left: headerBackgroundWidget.left
        anchors.leftMargin: Sizes.dp(45)
        anchors.right: headerBackgroundWidget.right
        anchors.rightMargin: Sizes.dp(45 * 1.5)
        height: root.destinationButtonrowHeight
        active: headerBackgroundWidget.active && root.state === "Widget3Rows"
        sourceComponent: FavDestinationButtonsPanel {
            offlineMapsEnabled: root.offlineMapsEnabled
            homeAddressData: root.homeAddressData
            workAddressData: root.workAddressData
            homeRouteTime: root.homeRouteTime
            workRouteTime: root.workRouteTime
            onShowRoute: root.showRoute(destCoord, description);
        }
    }
}
