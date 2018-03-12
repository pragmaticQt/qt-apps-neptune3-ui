/****************************************************************************
**
** Copyright (C) 2018 Pelagicore AG
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
import QtApplicationManager 1.0 as AM

/*
  A list of ApplicationInfo objects.
*/
ListModel {
    id: root

    // The currently active application. The active application should be displayed in a maximized state.
    readonly property var activeAppInfo: d.activeAppInfo

    // The instrument cluster application.
    readonly property var instrumentClusterAppInfo: d.instrumentClusterAppInfo

    // Used to calculate Style.hspan() and Style.vspan() in client apps
    // Theses values change at runtime as the system ui gets resized and rotated in the display
    property real cellWidth
    property real cellHeight

    // The locale code (eg: "en_US") that is passed down to applications
    property string localeCode

    // Whether the model is still being populated. It's true during start up.
    readonly property bool populating: d.populating

    // Returns an ApplicationInfo given its index
    function application(index) {
        return get(index).appInfo;
    }

    // Returns an ApplicationInfo given its id
    function applicationFromId(appId) {
        for (var i = 0; i < count; i++) {
            var appInfo = get(i).appInfo;
            if (appInfo.id === appId) {
                return appInfo;
            }
        }
        return null;
    }

    // Go back to the home screen.
    //
    // It deactivates the currently active application, if any.
    // When there is no active application the home screen should be
    // seen instead, hence the name.
    function goHome() {
        if (d.activeAppInfo) {
            d.activeAppInfo.priv.active = false;
            d.activeAppInfo = null;
            console.log(d.logCat, "activeAppId=<empty>");
        }
    }

    property var priv: QtObject {
        id: d
        property var activeAppInfo: null
        property var instrumentClusterAppInfo: null
        property var populating: true

        readonly property var logCat: LoggingCategory {
            name: "applicationmodel"
        }

        function reactOnAppActivation(appId) {
            if (d.activeAppInfo && appId === d.activeAppInfo.id)
                return;

            var appInfo = root.applicationFromId(appId);
            if (!appInfo || !appInfo.canBeActive)
                return;

            appInfo.priv.active = true;

            if (d.activeAppInfo) {
                d.activeAppInfo.priv.active = false;
            }

            d.activeAppInfo = appInfo;
            console.log(d.logCat, "activeAppId=" + d.activeAppInfo.id);
        }

        function isInstrumentClusterApp(app)
        {
            return app.categories.indexOf("cluster") >= 0;
        }

        property Component appInfoComponent: Component { ApplicationInfo{} }
        function appendApplication(app) {
            var appInfo = appInfoComponent.createObject(root, {"application":app});
            appInfo.localeCode = Qt.binding(function() { return root.localeCode; });

            if (d.isInstrumentClusterApp(app)) {
                d.instrumentClusterAppInfo = appInfo;
                appInfo.start();
            } else {
                root.append({"appInfo":appInfo});
            }
        }

        // TODO: Load the widget configuration from some database or file
        function configureApps()
        {
            var appInfo = root.applicationFromId("com.pelagicore.calendar");
            appInfo.asWidget = true;
            appInfo.heightRows = 2;

            appInfo = root.applicationFromId("com.pelagicore.phone");
            appInfo.asWidget = true;
            appInfo.heightRows = 2;

            appInfo = root.applicationFromId("com.pelagicore.music");
            appInfo.asWidget = true;
        }
    }


    Component.onCompleted: {
        var i;
        for (i = 0; i < AM.ApplicationManager.count; i++) {
            var app = AM.ApplicationManager.application(i);
            d.appendApplication(app);
        }
        d.configureApps();
        d.populating = false;
    }

    property var appManConns: Connections {
        target: AM.ApplicationManager

        onApplicationWasActivated: d.reactOnAppActivation(id);

        onApplicationRunStateChanged: {
            var appInfo = root.applicationFromId(id);
            if (!appInfo) {
                return;
            }

            if (runState === AM.Application.NotRunning) {
                if (appInfo === d.activeAppInfo) {
                    root.goHome();
                }
                if (appInfo.asWidget) {
                    // otherwise the widget would get maximized once restarted.
                    appInfo.canBeActive = false;

                    // Application was killed or crashed while being displayed as a widget.
                    // Remove it from the widget list
                    appInfo.asWidget = false;
                }
            }
        }

        onApplicationAdded: {
            var app = AM.ApplicationManager.application(id);
            d.appendApplication(app);
        }

        onApplicationAboutToBeRemoved: {
            var appInfo = null;
            var index;

            for (index = 0; index < count; index++) {
                var someAppInfo = get(index).appInfo;
                if (someAppInfo.id === id) {
                    appInfo = someAppInfo;
                    break;
                }
            }

            console.assert(!!appInfo);

            if (d.ActiveAppInfo === appInfo) {
                root.goHome();
            }
            if (appInfo.asWidget) {
                appInfo.asWidget = false;
            }

            root.remove(index);
        }
    }

    property var winManConns: Connections {
        target: AM.WindowManager

        onWindowReady: {
            var appID = AM.WindowManager.get(index).applicationId;
            var appInfo = applicationFromId(appID);

            var isRegularApp = !!appInfo;

            AM.WindowManager.setWindowProperty(window, "cellWidth", root.cellWidth);
            AM.WindowManager.setWindowProperty(window, "cellHeight", root.cellHeight);

            if (isRegularApp) {
                var isSecondaryWindow = AM.WindowManager.windowProperty(window, "windowType") == "secondary";

                if (isSecondaryWindow) {
                    appInfo.priv.secondaryWindow = window;
                } else {
                    appInfo.priv.window = window;
                    appInfo.canBeActive = true;
                }
            } else {
                // must be the instrument cluster, which is set apart
                console.assert(!!d.instrumentClusterAppInfo, "Didn't find an Instrument Cluster application!");
                d.instrumentClusterAppInfo.priv.window = window;
            }
        }

        onWindowLost: {
            var appID = AM.WindowManager.get(index).applicationId;

            var appInfo = applicationFromId(appID);
            if (!appInfo) {
                // must be the instrument cluster, which is set apart
                console.assert(d.instrumentClusterAppInfo && d.instrumentClusterAppInfo.id === appID);
                appInfo = d.instrumentClusterAppInfo;
            }

            if (appInfo.priv.window === window) {
                appInfo.priv.window = null;
            } else if (appInfo.priv.secondaryWindow === window) {
                appInfo.priv.secondaryWindow = null;
            }

            // TODO care about animating before releasing
            AM.WindowManager.releaseWindow(window);
        }

        onWindowPropertyChanged: {
            if (name === "activationCount") {
                var appId = AM.WindowManager.get(AM.WindowManager.indexOfWindow(window)).applicationId;
                AM.ApplicationManager.application(appId).activated();
                d.reactOnAppActivation(appId);
            }
        }
    }

    onCellWidthChanged: {
        for (var i = 0; i < AM.WindowManager.count; i++) {
            var window = AM.WindowManager.get(i).windowItem;
            AM.WindowManager.setWindowProperty(window, "cellWidth", root.cellWidth);
        }
    }

    onCellHeightChanged: {
        for (var i = 0; i < AM.WindowManager.count; i++) {
            var window = AM.WindowManager.get(i).windowItem;
            AM.WindowManager.setWindowProperty(window, "cellHeight", root.cellHeight);
        }
    }
}