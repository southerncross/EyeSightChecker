#include <QApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <iostream>

#include "configuration.h"

using namespace std;

int main(int argc, char *argv[])
{
    QApplication app(argc, argv);


    QQmlApplicationEngine engine;

    Configuration conf;
    engine.rootContext()->setContextProperty("configuration", &conf);

    engine.load(QUrl(QStringLiteral("qrc:/main.qml")));

    return app.exec();
}
