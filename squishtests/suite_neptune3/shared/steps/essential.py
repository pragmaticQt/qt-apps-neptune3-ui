# -*- coding: utf-8 -*-

############################################################################
##
## Copyright (C) 2018 Luxoft GmbH
## Contact: https://www.qt.io/licensing/
##
## This file is part of the Neptune 3 IVI UI.
##
## $QT_BEGIN_LICENSE:GPL-QTAS$
## Commercial License Usage
## Licensees holding valid commercial Qt Automotive Suite licenses may use
## this file in accordance with the commercial license agreement provided
## with the Software or, alternatively, in accordance with the terms
## contained in a written agreement between you and The Qt Company.  For
## licensing terms and conditions see https://www.qt.io/terms-conditions.
## For further information use the contact form at https://www.qt.io/contact-us.
##
## GNU General Public License Usage
## Alternatively, this file may be used under the terms of the GNU
## General Public License version 3 or (at your option) any later version
## approved by the KDE Free Qt Foundation. The licenses are as published by
## the Free Software Foundation and appearing in the file LICENSE.GPL3
## included in the packaging of this file. Please review the following
## information to ensure the GNU General Public License requirements will
## be met: https://www.gnu.org/licenses/gpl-3.0.html.
##
## $QT_END_LICENSE$
##
## SPDX-License-Identifier: GPL-3.0
##
#############################################################################

import names
import common.settings as settings  # some test setting vars
import common.app as app

# coordinate
from math import sin, cos, floor


def coord_up_px(in_pix):
    up = QPoint(0, -in_pix)
    transf = coord_transform2DReal(up)
    return transf


def coord_down_px(in_pix):
    return coord_up_px(-in_pix)


def coord_right_px(in_pix):
    right = QPoint(in_pix, 0)
    transf = coord_transform2DReal(right)
    return transf


def coord_left_px(in_pix):
    return coord_right_px(-in_pix)


def coord_addQPoints(a, b):
    return QPoint(a.x + b.x, a.y + b.y)


def coord_transform2DReal(src_point):
    ti = QPoint(src_point.x, src_point.y)
    if settings.SCREEN_LANDSCAPE:
        ti.x = -src_point.x
        ti.y = src_point.y
    return ti


def coord_transform2D(src_point):
    ti = QPoint(0, 0)

    rotation = float(0)
    if settings.SCREEN_LANDSCAPE:
            rotation = math.pi * 0.75

    scale_x = float(settings.SCREEN_WIDTH * 0.01)
    scale_y = float(settings.SCREEN_HEIGHT * 0.01)

    r_sin_rho = sin(rotation)
    r_cos_rho = cos(rotation)

    # not fully tested!!!!
    tx = float((r_cos_rho * src_point.x * scale_x)
               - (r_sin_rho * src_point.y * scale_y))
    ty = float((r_sin_rho * src_point.x * scale_x)
               + (r_cos_rho * src_point.y * scale_y))

    # do a geometric translation (after so no rotation in a point)
    ti.x = floor(tx) + settings.SCREEN_SHIFT_X_px
    ti.y = floor(ty) + settings.SCREEN_SHIFT_Y_px
    return ti


@Given("main menu is open")
def step(context):
    snooze(settings.G_WAIT_SYSTEM_READY_SEC)
    test.compare(True, True, "Main menu is open... still fake")


@Given("main menu is focused")
def step(context):
    worked, _obj = focus_window("console")
    test.compare(True, worked)


@When("nothing")
def step(context):
    test.compare(True, True)


@Given("nothing")
def step(context):
    pass


@Then("nothing")
def step(context):
    pass


@Then("after some '|integer|' seconds")
def step(context, seconds):
    snooze(seconds)


@When("after some '|integer|' seconds")
def step(context, seconds):
    snooze(seconds)


# --------------------- specific not yet clear, where to put it
def click_popup_close(context):
    popup_close_button = waitForObject(names.neptune_3_UI_Center_Console_popupClose_ToolButton)
    mouseClick(popup_close_button)
    is_still_there = is_squish_object_there(popup_close_button, 1)
    test.compare(True, not is_still_there, "popup should be closed by now")


@Then("click the popup close button")
def step(context):
    # this button exists only in main app
    app.switch_to_main_app()

    click_popup_close(context)


@When("the popup close button is clicked")
def step(context):
    click_popup_close(context)


def is_squish_object_there(object, seconds):
    snooze(seconds)
    is_there = True
    try:
        waitForObjectExists(object, settings.G_WAIT_FOR_INEXISTANCE_MS)
    except Exception:
        is_there = False
    return is_there

# -------------------------------------------------------
