#ifndef CONFIGURATION_H
#define CONFIGURATION_H

#include <QObject>
#include <QSettings>

class Configuration : public QObject
{
    Q_OBJECT
    Q_PROPERTY(double basicScale READ getBasicScale WRITE setBasicScale)
public:
    static const QString CONF_NAME;
    static const QString BASIC_SCALE_KEYNAME;

    explicit Configuration(QObject *parent = 0);
    Q_INVOKABLE double getBasicScale() const;
    Q_INVOKABLE void setBasicScale(double newScale);
    Q_INVOKABLE void changeBasicScale(double times);
signals:

public slots:

private:
    double basicScale;
};

#endif // CONFIGURATION_H
