VERSION  = 5.11.0
TEMPLATE = app
TARGET   = neptune3-ui

include(../../config.pri)

macos:CONFIG -= app_bundle
CONFIG *= no_private_qt_headers_warning link_pkgconfig

QT *= appman_main-private testlib gui-private

unix:exists($$SOURCE_DIR/.git):GIT_REVISION=$$system(cd "$$SOURCE_DIR" && git describe --tags --always 2>/dev/null)

isEmpty(GIT_REVISION) {
    GIT_REVISION="unknown revision"
    GIT_COMMITTER_DATE="no date"
} else {
    GIT_COMMITTER_DATE=$$system(cd "$$SOURCE_DIR" && git show "$$GIT_REVISION" --pretty=format:"%ci" --no-patch 2>/dev/null)
}

DEFINES *= "NEPTUNE_VERSION=$$VERSION"

DEFINES *= NEPTUNE_INFO=\""\\\"$$GIT_REVISION, $$GIT_COMMITTER_DATE\\\""\"

SOURCES = main.cpp

DESTDIR = $$OUT_PWD/../../

target.path = $$INSTALL_PREFIX/neptune3
INSTALLS += target

win32 {
    wrapper.files = neptune3-ui_wrapper.bat
    wrapper.path = $$INSTALL_PREFIX/neptune3
    INSTALLS += wrapper
}
