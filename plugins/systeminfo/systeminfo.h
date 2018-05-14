/****************************************************************************
**
** Copyright (C) 2017-2018 Pelagicore AG
** Contact: https://www.qt.io/licensing/
**
** This file is part of the Neptune IVI UI.
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

#ifndef SYSTEMINFO_H
#define SYSTEMINFO_H

#include <QtCore/QObject>
#include <QtCore/QTimer>
#include <QtQml/QQmlParserStatus>
#include <QProcess>
#include <QVariant>

class SystemInfo : public QObject, public QQmlParserStatus
{
    Q_OBJECT
    Q_INTERFACES(QQmlParserStatus)

    Q_PROPERTY(QStringList addressList READ addressList NOTIFY addressListChanged)
    Q_PROPERTY(bool online READ online NOTIFY onlineChanged)
    Q_PROPERTY(QString productName READ productName CONSTANT)
    Q_PROPERTY(QString cpu READ cpu CONSTANT)
    Q_PROPERTY(QString kernel READ kernel CONSTANT)
    Q_PROPERTY(QString qtVersion READ qtVersion CONSTANT)
    Q_PROPERTY(QString qtDiag READ qtDiag NOTIFY qtDiagChanged)

public:
    explicit SystemInfo(QObject *parent = nullptr);
    ~SystemInfo() override;
    QStringList addressList() const;
    bool online() const;
    QString qtVersion() const;
    QString productName() const;
    QString cpu() const;
    QString kernel() const;
    QString qtDiag() const;

public slots:
    void init();

signals:
    void addressListChanged();
    void onlineChanged();
    void qtDiagChanged();

protected:
    void classBegin() override;
    void componentComplete() override;

private slots:
    void updateOnlineStatusNm(quint32 state);
    void updateOnlineStatusSd(const QVariant &state);
    void updateOnlineStatusSdPropChange(const QString &interface, const QVariantMap &changedprop, const QStringList &invalidated_properties);

private:
    void getAddress();
    void getQtDiagInfo();
    QStringList m_addressList;
    bool m_online{false};
    QString m_qtDiagContents;
    QProcess *m_diagProc{nullptr};
};

#endif // SYSTEMINFO_H
