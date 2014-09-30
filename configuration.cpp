#include "configuration.h"

const QString Configuration::CONF_NAME = "eyesight_option";
const QString Configuration::BASIC_SCALE_KEYNAME = "basic_scale";

Configuration::Configuration(QObject *parent) :
    QObject(parent)
{
    basicScale = getBasicScale();
}

double Configuration::getBasicScale() const
{
    QSettings settings(CONF_NAME, QSettings::IniFormat);
    double basicScale = -1;

    basicScale = settings.value(BASIC_SCALE_KEYNAME).toDouble();
    basicScale = basicScale <= 0 ? 1 : basicScale;
    return basicScale;
}

void Configuration::setBasicScale(double newScale)
{
    QSettings settings(CONF_NAME, QSettings::IniFormat);

    settings.setValue(BASIC_SCALE_KEYNAME, newScale);
    basicScale = newScale;
}

void Configuration::changeBasicScale(double times)
{
    setBasicScale(basicScale * times);
}
