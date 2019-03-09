/**
 * Filename: Settings.hpp
 *
 * XCITE is a secure platform utilizing the XTRABYTES Proof of Signature
 * blockchain protocol to host decentralized applications
 *
 * Copyright (c) 2017-2018 Zoltan Szabo & XTRABYTES developers
 *
 * This file is part of an XTRABYTES Ltd. project.
 *
 */

#ifndef SETTINGS_HPP
#define SETTINGS_HPP

#include <QObject>
#include <QTranslator>
#include <QCoreApplication>
#include <QQmlApplicationEngine>
#include <QSettings>
#include <QtSql>
#include <QDateTime>
#include <QNetworkReply>
#include "qaesencryption.h"
#include <openssl/rsa.h>
#include <string>
#include <iostream>



class Settings : public QObject
{
    Q_OBJECT

public:
    Settings(QObject *parent = 0);
    Settings(QQmlApplicationEngine *engine, QSettings *settings, QObject *parent = 0);
    void setLocale(QString);
    QString CheckStatusCode(QString);
    void SaveFile(QString, QString);
    QString LoadFile(QString);
    std::pair<QByteArray, QByteArray> createKeyPair();
    int rsaEncrypt(const unsigned char *message, size_t messageLength, unsigned char **encryptedMessage, unsigned char **encryptedKey,
          size_t *encryptedKeyLength, unsigned char **iv, size_t *ivLength);

    std::pair<int, QByteArray> encryptAes(QString text, unsigned char *key, unsigned char *iv);
    RSA * createRSA(unsigned char * key,int public1);
    QString createRandNum();







public slots:
    void onLocaleChange(QString);
    void onClearAllSettings();
    void login(QString username, QString password);
    bool SaveSettings();
    void LoadSettings(QByteArray settings);
    bool UserExists(QString username);
    void CreateUser(QString username, QString password);
    void SaveAddresses(QString addresslist);
    void SaveContacts(QString contactlist);
    void SaveWallet(QString walletlist, QString addresslist);
    void UpdateAccount(QString addresslist, QString contactlist, QString walletlist);

    void onSavePincode(QString pincode);
    bool checkPincode(QString pincode);
    QString RestAPIPostCall(QString apiURL, QByteArray payload);
    QString RestAPIPostCall2(QString apiURL, QByteArray payload);
//    RSA * createRSA(unsigned char * key,int publi);


    QString RestAPIPutCall(QString apiURL, QByteArray payload);
    QByteArray RestAPIGetCall(QString apiURL);


signals:
    void loginSucceededChanged();
    void loginFailedChanged();
    void userCreationSucceeded();
    void userCreationFailed();
    void userAlreadyExists();
    void usernameAvailable();
    void settingsServerError();
    void contactsLoaded(const QString &contacts);
    void addressesLoaded(const QString &addresses);
    void settingsLoaded(const QVariantMap &settings);
    void walletLoaded(const QString &wallets);
    void clearSettings();
    void pincodeCorrect();
    void pincodeFalse();
    void saveSucceeded();
    void saveFailed();
    void saveFileSucceeded();
    void saveFileFailed();



private:
    QTranslator m_translator;
    QQmlApplicationEngine *m_engine;
    QSettings *m_settings;
    QString m_addresses;
    QString m_contacts;
    QString m_wallet;
    QString m_pincode;
    QString m_username;
    QString m_password;
    QString sessionId;
    std::pair<QByteArray,QByteArray> keyPair;
    unsigned char backendKey[32];
    unsigned char iiiv[16];

};

#endif // SETTINGS_HPP
