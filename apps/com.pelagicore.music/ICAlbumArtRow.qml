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
import QtGraphicalEffects 1.0
import utils 1.0
import animations 1.0

Item {
    id: root

    property bool musicPlaying: false
    property real musicPosition: 0.0
    property bool mediaReady: false
    property alias coverSlide: coverslide
    property string currentAlbumArt
    property var songModel
    property alias currentIndex: coverslide.currentIndex
    property alias currentSongTitle: titleColumn.currentSongTitle
    property alias currentArtisName: titleColumn.currentArtisName
    property alias currentProgressLabel: musicProgress.progressText

    signal previousClicked()
    signal nextClicked()
    signal playClicked()

    signal favoriteClicked()
    signal shuffleClicked()
    signal repeatClicked()

    function populateModel() {
        coverSlide.model = root.songModel;
    }

    Component {
        id: albumArtDelegate

        Item {
            id: itemDelegated
            height: 320
            width: height
            layer.enabled: true
            opacity: PathView.iconOpacity !== undefined ? PathView.iconOpacity : 0.0

            property alias albumArtSource: albumArt.source

            Image {
                id: albumArtShadow
                anchors.centerIn: parent
                source: Style.gfx2("album-art-shadow")
                fillMode: Image.Pad
            }

            Image {
                id: albumArtUndefined
                anchors.centerIn: parent
                width: Style.hspan(180/45)
                height: width
                source: Style.gfx2("album-art-placeholder")
                fillMode: Image.PreserveAspectCrop
            }

            Image {
                id: albumArt
                anchors.centerIn: parent
                width: 180
                height: width
                source: model.item.coverArtUrl
                fillMode: Image.PreserveAspectCrop
            }
        }
    }


    Item {
        id: pathView

        width: root.width
        height: 180
        anchors.top: parent.top

        PathView {
            id: coverslide

            anchors.centerIn: parent
            width: parent.width
            height: parent.height
            preferredHighlightBegin: 0.5
            preferredHighlightEnd: 0.5
            snapMode: PathView.SnapOneItem
            highlightRangeMode: PathView.StrictlyEnforceRange
            highlightMoveDuration: 200
            model: 3
            delegate: albumArtDelegate
            pathItemCount: 3
            interactive: false
            cacheItemCount: 10

            onCurrentIndexChanged: {
                if (currentItem) {
                    root.currentAlbumArt = currentItem.albumArtSource
                } else {
                    root.currentAlbumArt = ""
                }
            }

            path: Path {
                startX: 0; startY: coverslide.height/2

                PathAttribute { name: "iconOpacity"; value: 0.02 }
                PathLine { x: coverslide.width/2; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 1 }
                PathLine { x: coverslide.width; y: coverslide.height/2 }
                PathAttribute { name: "iconOpacity"; value: 0.02 }
            }
        }
    }

    MusicProgress {
        id: musicProgress
        width: root.width
        height: 220
        anchors.top: pathView.bottom
        anchors.leftMargin: 40
        anchors.rightMargin: 40
        value: root.musicPosition
        onUpdatePosition: root.updatePosition(value)
        progressBarLabelLeftMargin: 3
    }

    TitleColumn {
        id: titleColumn
        anchors.left: parent.left
        anchors.leftMargin: 0
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: musicProgress.bottom
        anchors.topMargin: -80
    }
}
