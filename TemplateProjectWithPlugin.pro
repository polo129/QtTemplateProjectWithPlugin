# allows to add DEPLOYMENTFOLDERS and links to the Felgo library and QtCreator auto-completion
CONFIG += felgo

# uncomment this line to add the Live Client Module and use live reloading with your custom C++ code
# for the remaining steps to build a custom Live Code Reload app see here: https://felgo.com/custom-code-reload-app/
# CONFIG += felgo-live

# Project identifier and version
# More information: https://felgo.com/doc/felgo-publishing/#project-configuration
PRODUCT_IDENTIFIER = com.yourcompany.wizardEVAP.TemplateProjectWithPlugin
PRODUCT_VERSION_NAME = 1.0.0
PRODUCT_VERSION_CODE = 1

# Optionally set a license key that is used instead of the license key from
# main.qml file (App::licenseKey for your app or GameWindow::licenseKey for your game)
# Only used for local builds and Felgo Cloud Builds (https://felgo.com/cloud-builds)
# Not used if using Felgo Live
PRODUCT_LICENSE_KEY = "B646E060B0E5C2A2C6343829D978D9C564276D6155EBF21B2B9A914A7484EEB268E52968AA21C96D06E382504C822E663628D22174D07699A0218B00D2A05B69D0EE4DA94D93F49944DF5116CC1FD32BA427C6B177C7A73AB8C3FAA399AB9C09FC82207527CEA1FB85A5941AEC5525A3E2A97EC058B346D283D4F258E27ADB3AE1165F947960EC269C2E06A06EF14CDB7163C4CA5FF489DD7540B7FAD1A26D630612EB61243E59B9006C4C72EE6C2E97486B49F350CD3E5A03758760116C87264D4577A9BEB6FB4482A8354903ED74E6C3906386DC655611B32E9E7CAD201D0E73D81809B330F96A0F00C327CB6659F657113AF2203D78255F96C19B8F29210DF09413B34CE9F26EB896DC25209B54541F7035BD6F7B2D00BCFFD1684B7A701E1890A43927EBD5180FCA489FE58785B41160AFB73C8A748EE47E9D9A87574DDF1C0B27181F0D5817F08FE51BB336155708CBEB4D02F2C3D3E9C1962A059F74A649D3C719DD024FA59A9C2799A7D99431272832715894E70BCEAB69C25EA348971FD26244DC718BE91C001798BB51DDAA"

qmlFolder.source = qml
DEPLOYMENTFOLDERS += qmlFolder # comment for publishing

assetsFolder.source = assets
DEPLOYMENTFOLDERS += assetsFolder

# Add more folders to ship with the application here

RESOURCES += #    resources.qrc # uncomment for publishing

# NOTE: for PUBLISHING, perform the following steps:
# 1. comment the DEPLOYMENTFOLDERS += qmlFolder line above, to avoid shipping your qml files with the application (instead they get compiled to the app binary)
# 2. uncomment the resources.qrc file inclusion and add any qml subfolders to the .qrc file; this compiles your qml files and js files to the app binary and protects your source code
# 3. change the setMainQmlFile() call in main.cpp to the one starting with "qrc:/" - this loads the qml files from the resources
# for more details see the "Deployment Guides" in the Felgo Documentation

# during development, use the qmlFolder deployment because you then get shorter compilation times (the qml files do not need to be compiled to the binary but are just copied)
# also, for quickest deployment on Desktop disable the "Shadow Build" option in Projects/Builds - you can then select "Run Without Deployment" from the Build menu in Qt Creator if you only changed QML files; this speeds up application start, because your app is not copied & re-compiled but just re-interpreted


# The .cpp file which was generated for your project. Feel free to hack it.
SOURCES += main.cpp

FELGO_PLUGINS += admob
FELGO_PLUGINS += chartboost
FELGO_PLUGINS += soomla

android {
    ANDROID_PACKAGE_SOURCE_DIR = $$PWD/android
    OTHER_FILES += android/AndroidManifest.xml       android/build.gradle
}

ios {
    QMAKE_INFO_PLIST = ios/Project-Info.plist
    OTHER_FILES += $$QMAKE_INFO_PLIST
}

# set application icons for win and macx
win32 {
    RC_FILE += win/app_icon.rc
}
macx {
    ICON = macx/app_icon.icns
}
