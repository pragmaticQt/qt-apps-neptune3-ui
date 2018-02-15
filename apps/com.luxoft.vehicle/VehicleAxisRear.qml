/****************************************************************************
**
** Copyright (C) 2017 Pelagicore AB
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
import QtQuick 2.0
import Qt3D.Core 2.0
import Qt3D.Render 2.9
import Qt3D.Extras 2.9
import Qt3D.Input 2.0
import QtQuick.Scene3D 2.0

Entity {
    id: root

    function animate() {
        rotationAnimation.start()
    }

    Transform {
        id: transform
        property real userAngle: 0.0
        matrix: {
            var m = Qt.matrix4x4()
            var yOffset = 6
            var zOffset = -30
            m.scale(vehicle3DView.scaleFactor)
            m.translate(Qt.vector3d(0, yOffset, zOffset))
            m.rotate(userAngle, Qt.vector3d(1, 0, 0))
            m.translate(Qt.vector3d(0, -yOffset, -zOffset))
            return m
        }
        scale: vehicle3DView.scaleFactor
    }

    Mesh {
        id: rear_tires
        source: "assets/models/rear_tires.stl"
    }

    NormalDiffuseMapAlphaMaterial {
        id: rearTiresMaterial
        diffuse: rear_tires_texture
    }

    Texture2D {
        id: rear_tires_texture
        format: Texture.SRGB8_Alpha8
        TextureImage {
            source: "assets/textures/rear_tires.png"
        }
    }

    Entity {
        id: chromeWheel
        Mesh {
            id: wheelMesh
            meshName: "^rear_wheel_chrome_1$"
            source: "assets/models/rear_wheel_chrome_1.stl"
        }
        components: [transform, wheelMesh, chromeMaterial]
    }

    Entity {
        components: [transform, rear_tires, rearTiresMaterial]
    }

    NumberAnimation {
        id: rotationAnimation
        target: transform
        property: "userAngle"
        duration: 1000
        from: transform.userAngle
        to: 360
        loops: Animation.Infinite
    }
}
