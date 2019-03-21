/**
 * Filename: main.qml
 *
 * XCITE is a secure platform utilizing the XTRABYTES Proof of Signature
 * blockchain protocol to host decentralized applications
 *
 * Copyright (c) 2017-2018 Zoltan Szabo & XTRABYTES developers
 *
 * This file is part of an XTRABYTES Ltd. project.
 *
 */

import QtQuick 2.7
import QtQuick.Controls 2.3
import QtQuick.Layouts 1.3
import QtQuick.Window 2.2
import Clipboard 1.0
import Qt.labs.settings 1.0
import Qt.labs.folderlistmodel 2.11
import QtMultimedia 5.8
import QtGraphicalEffects 1.0

ApplicationWindow {
    property bool isNetworkActive: false

    id: xcite

    visible: true

    width: Screen.width
    height: Screen.height
    title: qsTr("XCITE")
    color: "#14161B"

    Label {
        id:helloModalLabel
        text: "HELLO"
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter
        font.pixelSize: 20
        font.family: "Brandon Grotesque"
        color: "#F2F2F2"
        font.letterSpacing: 2
    }

    Component.onCompleted: {
        clearAllSettings()

        contactID = 1
        addressID = 1
        walletID = 1
        txID = 1
        pictureID = 0
        walletIndex = 1

        profilePictures.setProperty(0, "photo", 'qrc:/icons/icon-profile_01.svg');
        profilePictures.setProperty(0, "pictureNR", pictureID);
        pictureID = pictureID +1;
        profilePictures.append({"photo": 'qrc:/icons/icon-profile_02.svg', "pictureNR": pictureID});
        pictureID = pictureID +1;
        profilePictures.append({"photo": 'qrc:/icons/icon-profile_03.svg', "pictureNR": pictureID});
        pictureID = pictureID +1;
        profilePictures.append({"photo": 'qrc:/icons/icon-profile_04.svg', "pictureNR": pictureID});
        pictureID = pictureID +1;

        fiatCurrencies.setProperty(0, "currency", "USD");
        fiatCurrencies.setProperty(0, "ticker", "$");
        fiatCurrencies.setProperty(0, "currencyNR", 0);
        fiatCurrencies.append({"currency": "EUR", "ticker": "€", "currencyNR": 1});
        fiatCurrencies.append({"currency": "GBP", "ticker": "£", "currencyNR": 2});
        //fiatCurrencies.append({"currency": "BTC", "ticker": "₿", "currencyNR": 3});

        coinList.setProperty(0, "name", nameXFUEL);
        coinList.setProperty(0, "fullname", "xfuel");
        coinList.setProperty(0, "logo", 'qrc:/icons/XFUEL_card_logo_01.svg');
        coinList.setProperty(0, "logoBig", 'qrc:/icons/XFUEL_logo_big.svg');
        coinList.setProperty(0, "coinValueBTC", btcValueXFUEL);
        coinList.setProperty(0, "percentage", percentageXFUEL);
        coinList.setProperty(0, "totalBalance", 0);
        coinList.setProperty(0, "active", true);
        coinList.setProperty(0, "testnet", false );
        coinList.setProperty(0, "coinID", 0);
        coinList.append({"name": nameXBY, "fullname": "xtrabytes", "logo": 'qrc:/icons/XBY_card_logo_01.svg', "logoBig": 'qrc:/icons/XBY_logo_big.svg', "coinValueBTC": btcValueXBY, "percentage": percentageXBY, "totalBalance": 0, "active": true, "testnet" : false, "coinID": 1});
        coinList.append({"name": "XFUEL-TEST", "fullname": "xfuel", "logo": 'qrc:/icons/TESTNET_card_logo_01.svg', "logoBig": 'qrc:/icons/TESTNET_logo_big.svg', "coinValueBTC": 0, "percentage": 0, "totalBalance": 0, "active": true, "testnet" : true, "coinID": 2});
        coinList.append({"name": "XBY-TEST", "fullname": "xtrabytes", "logo": 'qrc:/icons/TESTNET_card_logo_01.svg', "logoBig": 'qrc:/icons/TESTNET_logo_big.svg', "coinValueBTC": 0, "percentage": 0, "totalBalance": 0, "active": true, "testnet" : true, "coinID": 3});

        marketValueChangedSignal("btcusd");
        marketValueChangedSignal("btceur");
        marketValueChangedSignal("btcgbp");
        marketValueChangedSignal("xbybtc");
        marketValueChangedSignal("xbycha");

        mainRoot.push("../Onboarding.qml")
    }



    onBtcValueXBYChanged: {
        coinList.setProperty(1, "coinValueBTC", btcValueXBY);
        coinList.setProperty(1, "fiatValue", btcValueXBY * valueBTC);
    }

    onPercentageXBYChanged: {
        coinList.setProperty(1, "percentage", percentageXBY);
    }

    onBtcValueXFUELChanged: {
        coinList.setProperty(0, "coinValueBTC", btcValueXFUEL);
        coinList.setProperty(0, "fiatValue", btcValueXFUEL * valueBTC);
    }

    onPercentageXFUELChanged: {
        coinList.setProperty(0, "percentage", percentageXFUEL);
    }


    // Place holder values for wallets
    property string receivingAddressXBY1: "BiJeija103JfjQWpdkl230fjFEI3019JKl"
    property string nameXBY1: nameXBY
    property string labelXBY1: "Main"
    property real balanceXBY1: wallet.balance
    property real unconfirmedXBY1: 0

    property string receivingAddressXFUEL1: "F6xCY2wNyE7KwkWcUqeZVTy6WvciHYb5Eq"
    property string nameXFUEL1: nameXFUEL
    property string labelXFUEL1: "Main"
    property real balanceXFUEL1: 1465078.00000000 // xfuelwallet.balance
    property real unconfirmedXFUEL1: 0

    property string receivingAddressXFUEL2: "FAQbF9wCFPgE37PrNHeCU4KXpHezQrgUDu"
    property string nameXFUEL2: nameXFUEL
    property string labelXFUEL2: "Test"
    property real balanceXFUEL2: 1358832.85000000 // xfuelwallet.balance
    property real unconfirmedXFUEL2: 0

    // BTC information
    property real btcValueBTC: 1
    property real valueBTCUSD
    property real valueBTCEUR
    property real valueBTCGBP
    property real valueBTC: userSettings.defaultCurrency == 0? valueBTCUSD : userSettings.defaultCurrency == 1? valueBTCEUR : userSettings.defaultCurrency == 2? valueBTCGBP : btcValueBTC

    // Coin info, retrieved from server
    property string nameXBY: "XBY"
    property real btcValueXBY
    property real valueXBY: btcValueXBY * valueBTC
    property real percentageXBY

    property string nameXFUEL: "XFUEL"
    property real btcValueXFUEL
    property real valueXFUEL: btcValueXFUEL * valueBTC
    property real percentageXFUEL

    // Global theme settings, non-editable
    property color maincolor: "#0ED8D2"
    property color themecolor: darktheme == true? "#F2F2F2" : "#2A2C31"
    property color bgcolor: darktheme == true? "#14161B" : "#FDFDFD"
    property real doubbleButtonWidth: Screen.width - 56

    // Global setting, editable
    property bool darktheme: userSettings.theme == "dark"? true : false
    property string fiatTicker: fiatCurrencies.get(userSettings.defaultCurrency).ticker
    property string username: ""
    property string selectedPage: ""

    // Trackers
    property int interactionTracker: 0
    property int loginTracker: 0
    property int logoutTracker: 0
    property int addWalletTracker: 0
    property int createWalletTracker: 0
    property int viewOnlyTracker: 0
    property int importKeyTracker: 0
    property int appsTracker: 0
    property int coinTracker: 0
    property int walletTracker: 0
    property int transferTracker: 0
    property int historyTracker: 0
    property int addressTracker: 0
    property int contactTracker: 0
    property int addAddressTracker: 0
    property int addCoinTracker: 0
    property int addContactTracker: 0
    property int editContactTracker: 0
    property int coinListTracker: 0
    property int walletListTracker: 0
    property int addressbookTracker: 0
    property int scanQRTracker: 0
    property int tradingTracker: 0
    property int balanceTracker: 0
    property int calculatorTracker: 0
    property int addressQRTracker: 0
    property int pictureTracker: 0
    property int cellTracker: 0
    property int currencyTracker: 0
    property int pincodeTracker: 0
    property int debugTracker: 0
    property int backupTracker: 0
    property int screenshotTracker: 0
    property int walletDetailTracker: 0
    property int portfolioTracker: 0
    property int transactionDetailTracker: 0

    // Global variables
    property int sessionStart: 0
    property int sessionTime: 0
    property int sessionClosed: 0
    property int autoLogout: 0
    property int manualLogout: 0
    property int networkLogout: 0
    property int requestedLogout: 0
    property int pinLogout: 0
    property int goodbey: 0
    property int networkAvailable: 0
    property int networkError: 0
    property int photoSelect: 0
    property int newCoinPicklist: 0
    property int newCoinSelect: 0
    property int newWalletPicklist: 0
    property int newWalletSelect: 0
    property int switchState: 0
    property string scannedAddress: ""
    property string selectedAddress: ""
    property string currentAddress: ""
    property var calculatedAmount: ""
    property string scanningKey: ""
    property string scanning: "scanning..."
    property string addressbookName: ""
    property string addressbookHash: ""
    property int addressIndex: 0
    property int contactIndex: 0
    property int walletIndex: 1
    property int coinIndex: 0
    property int pictureIndex: 0
    property int totalLines: 4
    property int totalAddresses: countAddresses()
    property int totalWallets: countWallets()
    property int totalCoinWallets: 0
    property real totalBalance: 0
    property int contactID: 1
    property int addressID: 1
    property int walletID: 1
    property int txID: 1
    property int selectAddressIndex: 0
    property int pictureID: 0
    property int currencyID: 0
    property int createPin: 0
    property int changePin: 0
    property int unlockPin: 0
    property bool pinClearInitiated: false
    property int clearAll: 0
    property int pinOK: 0
    property int pinError: 0
    property int requestSend: 0
    property bool newAccount: false
    property real changeBalance: 0
    property string notificationDate: ""
    property bool walletAdded: false
    property bool alert: false
    property bool testNet: false
    property bool saveCurrency: false
    property int oldCurrency: 0
    property int currencyChangeFailed: 0
    property string oldLocale: ""
    property int oldDefaultCurrency: 0
    property string oldTheme: ""
    property bool oldPinlock: false
    property bool oldLocalKeys: false
    property string selectedCoin: "XFUEL"
    property real totalXBY: 0
    property real totalXFUEL: 0
    property real totalXBYTest: 0
    property real totalXFUELTest: 0
    property real totalXBYFiat: totalXBY * valueXBY
    property real totalXFUELFiat: totalXFUEL * valueXFUEL
    property string historyCoin: ""
    property int transactionPages: 0
    property int currentPage: 0
    property string transactionNR: ""
    property string transactionTimestamp: ""
    property bool transactionDirection: false
    property real transactionAmount: 0
    property string transactionConfirmations: ""

    // Signals
    signal loginSuccesfulSignal(string username, string password)
    signal loginFailed()
    signal marketValueChangedSignal(string currency)
    signal localeChange(string locale)
    signal userLogin(string username, string password)
    signal createUser(string username, string password)
    signal userExists(string username)
    signal clearAllSettings()
    signal saveAddressBook(string addresses)
    signal saveContactList(string contactList)
    signal saveAppSettings()
    signal saveWalletList(string walletList, string addresses)
    signal updateBalanceSignal(string walletList)
    signal createKeyPair(string network)
    signal importPrivateKey(string network, string privKey)
    signal helpMe(string help)
    signal checkNetwork(string network)
    signal updateAccount(string addresslist, string contactlist, string walletlist)
    signal updateTransactions(string coin, string address, string page)
    signal checkSessionId()
    signal getDetails(string coin, string transaction)

    signal savePincode(string pincode)
    signal checkPincode(string pincode)

    // Automated functions

    function updateBalance(coin, address, balance) {
        var balanceAlert
        var difference
        var newBalance
        changeBalance = 0

        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === coin) {
                if (walletList.get(i).address === address) {
                    newBalance = parseFloat(balance);
                    if (!isNaN(newBalance)){
                        if (newBalance !== walletList.get(i).balance) {

                            changeBalance = newBalance - walletList.get(i).balance
                            if (changeBalance > 0) {
                                difference = "increased"
                            }
                            else {
                                difference = "decreased"
                            }

                            walletList.setProperty(i, "balance", newBalance)
                            balanceAlert = "Your balance has " + difference + " with:<br><b>" + changeBalance + "</b>" + " " + (walletList.get(i).name)
                            alertList.append({"date" : new Date().toLocaleDateString(Qt.locale(),"MMMM d yyyy") + " at " + new Date().toLocaleTimeString(Qt.locale(),"HH:mm"), "message" : balanceAlert, "origin" : (walletList.get(i).name + " " + walletList.get(i).label)})
                            alert = true
                            sumBalance()
                            sumXBY()
                            sumXFUEL()
                            sumXBYTest()
                            sumXFUELTest()
                        }
                    }
                }
            }
        }
        var datamodel = []
        for (var e = 0; e < walletList.count; ++e)
            datamodel.push(walletList.get(e))

        var walletListJson = JSON.stringify(datamodel)
    }

    // Global functions
    function countWallets() {
        totalWallets = 0
        if (coinTracker == 0) {
            for(var i = 0; i < coinList.count; i++) {
                if (coinList.get(i).active === 1) {
                    totalWallets += 1
                }
            }
        }
        else {
            var name = getName(coinIndex)
            for(var e = 0; e < walletList.count; e++){
                if (walletList.get(e).name === name) {
                    totalWallets += 1
                }
            }
        }

        return totalWallets
    }

    function coinWalletLines(coin) {
        totalCoinWallets = 0
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === coin) {
                if (walletList.get(i).remove === false) {
                    totalCoinWallets += 1
                }
            }
        }
    }

    function resetFavorites(coin) {
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === coin) {
                walletList.setProperty(i, "favorite", false)
            }
        }
    }

    function countAddresses() {
        totalAddresses = 0
        for(var i = 0; i < walletList.count; i++) {
            totalAddresses += 1
        }
        return totalAddresses
    }

    function countAddressesContact(contactID) {
        var contactAddresses = 0
        for(var i = 0; i < addressList.count; i++) {
            if (addressList.get(i).contact === contactID) {
                if (addressList.get(i).remove === false) {
                    contactAddresses += 1
                }
            }
        }
        return contactAddresses
    }

    function sumBalance() {
        totalBalance = 0
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).active === true && walletList.get(i).include === true && walletList.get(i).remove === false) {
                if (walletList.get(i).name === "XBY") {
                    totalBalance += (walletList.get(i).balance * btcValueXBY * valueBTC)
                }
                else if (walletList.get(i).name === "XFUEL") {
                    totalBalance += (walletList.get(i).balance * btcValueXFUEL * valueBTC)
                }
            }
        }
        return totalBalance
    }

    function sumXBY() {
        totalXBY =0
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === "XBY" && walletList.get(i).include === true && walletList.get(i).remove === false) {
                totalXBY += walletList.get(i).balance
            }
        }
        return totalXBY
    }

    function sumXFUEL() {
        totalXFUEL = 0
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === "XFUEL" && walletList.get(i).include === true && walletList.get(i).remove === false) {
                totalXFUEL += walletList.get(i).balance
            }
        }
        return totalXFUEL
    }

    function sumXBYTest() {
        totalXBYTest =0
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === "XBY-TEST" && walletList.get(i).include === true && walletList.get(i).remove === false) {
                totalXBYTest += walletList.get(i).balance
            }
        }
        return totalXBYTest
    }

    function sumXFUELTest() {
        totalXFUELTest = 0
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === "XFUEL-TEST" && walletList.get(i).include === true && walletList.get(i).remove === false) {
                totalXFUELTest += walletList.get(i).balance
            }
        }
        return totalXFUELTest
    }

    function sumCoinTotal(coin) {
        var coinTotal = 0
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === coin && walletList.get(i).include === true && walletList.get(i).remove === false) {
                coinTotal += walletList.get(i).balance
            }
        }
        return coinTotal
    }

    function sumCoinUnconfirmed(coin) {
        var unconfirmedTotal = 0
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === coin && walletList.get(i).include === true && walletList.get(i).remove === false) {
                unconfirmedTotal += unconfirmedTotal + walletList.get(i).unconfirmedCoins
            }
        }
        return unconfirmedTotal
    }

    function coinConversion(coin, quantity) {
        var converted = 0
        for(var i = 0; i < coinList.count; i++) {
            if (coinList.get(i).name === coin) {
                converted = (quantity * coinList.get(i).coinValueBTC * valueBTC)
            }
        }
        return converted
    }

    function getLogo(coin) {
        var logo = ''
        for(var i = 0; i < coinList.count; i++) {
            if (coinList.get(i).name === coin) {
                logo = coinList.get(i).logo
            }
        }
        return logo
    }

    function getTestnet(coin) {
        testNet = false
        for(var i = 0; i < coinList.count; i++) {
            if (coinList.get(i).name === coin) {
                testNet = coinList.get(i).testnet
            }
        }
        return testNet
    }

    function getLogoBig(coin) {
        var logo = ''
        for(var i = 0; i < coinList.count; i++) {
            if (coinList.get(i).name === coin) {
                logo = coinList.get(i).logoBig
            }
        }
        return logo
    }

    function getName(coin) {
        var name = ""
        for(var i = 0; i < coinList.count; i++) {
            if (coinList.get(i).coinID === coin) {
                name = coinList.get(i).name
            }
        }
        return name
    }

    function getFullName(coin) {
        var name = ""
        for(var i = 0; i < coinList.count; i++) {
            if (coinList.get(i).coinID === coin) {
                name = coinList.get(i).fullname
            }
        }
        return name
    }

    function getPercentage(coin) {
        var percentage = 0
        for(var i = 0; i < coinList.count; i++) {
            if (coinList.get(i).name === coin) {
                percentage = coinList.get(i).percentage
            }
        }
        return percentage
    }

    function getValue(coin) {
        var value = 0
        for(var i = 0; i < coinList.count; i++) {
            if (coinList.get(i).name === coin) {
                value = coinList.get(i).coinValueBTC
            }
        }
        return value
    }

    function getAddress(coin, label) {
        var address = ""
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === coin) {
                if (walletList.get(i).label === label) {
                    address = walletList.get(i).address
                }
            }
        }
        return address
    }

    function getWalletNR(coin, label) {
        var walletID = ""
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === coin) {
                if (walletList.get(i).label === label) {
                    walletID = walletList.get(i).walletNR
                }
            }
        }
        return walletID
    }

    function getLabelAddress(coin, address) {
        var label = ""
        for(var i = 0; i < walletList.count; i++) {
            if (walletList.get(i).name === coin) {
                if (walletList.get(i).address === address) {
                    label = walletList.get(i).label
                }
            }
        }
        return label
    }

    function getCoinNR(coin) {
        selectedCoin = 0
        for (var i = 0; coinList.count; i++) {
            if (coinList.get(i).name === coin) {
                selectedCoin= coinList.get(i).coinID
            }
        }
    }

    function defaultWallet(coin) {
        var balance = 0
        var wallet = 0
        var favorite = false
        for(var i = 0; i < walletList.count; i++){
            if (walletList.get(i).name === coin){
                if (favorite == false) {
                    if (walletList.get(i).favorite === true){
                        balance = walletList.get(i).balance
                        wallet = walletList.get(i).walletNR
                        favorite = true
                    }
                    else {
                        if (walletList.get(i).balance > balance){
                            balance = walletList.get(i).balance
                            wallet = walletList.get(i).walletNR
                        }
                        else if (wallet == 0) {
                            balance = walletList.get(i).balance
                            wallet = walletList.get(i).walletNR
                        }
                    }
                }
                else {
                    if (walletList.get(i).favorite === true){
                        if (walletList.get(i).balance > balance){
                            balance = walletList.get(i).balance
                            wallet = walletList.get(i).walletNR
                        }
                    }
                }
            }
        }
        return wallet
    }

    function coinListLines(active) {
        totalLines = 0
        for(var i = 0; i < coinList.count; i++) {
            if (active === false) {
                totalLines += 1
            }
            else if (active === true) {
                if (coinList.get(i).active === true) {
                    totalLines += 1
                }
            }
        }
        return totalLines
    }

    function getAddressIndex(id) {
        for(var i = 0; i < addressList.count; i ++) {
            if (addressList.get(i).uniqueNR === id) {
                addressIndex = addressList.get(i)
            }
        }
    }

    function getContactIndex(id) {
        for(var i = 0; i < contactsList.count; i ++) {
            if (contactList.get(i).contactNR === id) {
                contactIndex = contactList.get(i)
            }
        }
    }

    function replaceName(id, first, last) {
        for(var i = 0; i < addressList.count; i ++) {
            if (addressList.get(i).contact === id) {
                contactList.setProperty(id, "fullname", last+first)
            }
        }
    }

    function getWalletIndex(id) {
        for(var i = 0; i < walletList.count; i ++) {
            if (walletList.get(i).walletNR === id) {
                walletIndex = walletList.get(i)
            }
        }
    }

    function getCoinIndex(id) {
        for(var i = 0; i < coinList.count; i ++) {
            if (coinList.get(i).coinID === id) {
                coinIndex = coinList.get(i)
            }
        }
    }

    function checkNotifications() {
        if (alertList.count > 1) {
            alert = true
        }
        else {
            alert = false
        }
    }

    Connections {
        target: marketValue

        onMarketValueChanged: {
            setMarketValue(currency, currencyValue)
        }
    }

    Connections {
        target: explorer

        onUpdateBalance: {
            updateBalance(coin, address, balance)
        }
    }

    Connections {
        target: xUtil

        onKeyPairCreated: {
            console.log("Address is: " + address)
            console.log("PubKey is: " + pubKey)
            console.log("PrivKey is: " + privKey)
        }
    }

    // Start up functions
    function setMarketValue(currency, currencyValue) {
        if (currencyValue !== "") {
            var currencyVal =  Number.fromLocaleString(Qt.locale("en_US"),currencyValue)
            if (currency === "btcusd"){
                valueBTCUSD = currencyVal;
            }else if(currency === "btceur"){
                valueBTCEUR = currencyVal;
            }else if(currency === "btcgbp"){
                valueBTCGBP = currencyVal;
            }else if(currency === "xbybtc"){
                btcValueXBY = currencyVal;
                btcValueXFUEL = currencyVal
            }else if(currency === "xbycha"){
                percentageXBY = currencyVal;
                percentageXFUEL = currencyVal;
            }
            sumBalance()
        }
    }

    function loadContactList(contacts) {
        if (typeof contacts !== "undefined") {
            contactList.clear();
            var obj = JSON.parse(contacts);
            for (var i in obj){
                var data = obj[i];
                contactList.append(data);
            }
        }
        else {
            console.log("no contacts saved in account")
        }
    }

    function loadAddressList(addresses) {
        if (typeof addresses !== "undefined") {
            addressList.clear();
            var obj = JSON.parse(addresses);
            for (var i in obj){
                var data = obj[i];
                addressList.append(data);
            }
        }
        else {
            console.log("no addresses saved in account")
        }
    }

    function loadWalletList(wallet) {
        if (typeof wallet !== "undefined") {
            walletList.clear();
            var obj = JSON.parse(wallet);
            for (var i in obj){
                var data = obj[i];
                walletList.append(data);
            }
        }
        else {
            console.log("no wallets saved in account")
        }
    }

    function loadSettings(settingsLoaded) {
        if (typeof settingsLoaded !== "undefined") {
            userSettings.accountCreationCompleted = settingsLoaded.accountCreationCompleted === "true";
            userSettings.defaultCurrency = settingsLoaded.defaultCurrency;
            userSettings.locale = settingsLoaded.locale;
            userSettings.pinlock = settingsLoaded.pinlock === "true";
            userSettings.theme = settingsLoaded.theme;
            userSettings.localKeys = settingsLoaded.localKeys === "true";

        }
        else {
            console.log("no settings saved in account")
        }
    }

    function loadTransactions(transactions){
        if (typeof transactions !== "undifined") {
            console.log("json history list: " + transactions)
            historyList.clear();
            var obj = JSON.parse(transactions);
            console.log("raw history list: " + obj)
            for (var i in obj){
                var data = obj[i];
                historyList.append(data);
            }
        }
        else {
            console.log("no transactions available")
        }
    }

    Connections {
        target: explorer

        onUpdateTransactionsDetails: {
            if (historyTracker == 1) {
                console.log ("confirmations: " + confirmations)
                loadTransactionAddresses(inputs, outputs)
                transactionTimestamp = timestamp
                transactionConfirmations = confirmations
                transactionAmount = (Number.fromLocaleString(Qt.locale("en_US"),balance) )/ 100000000
                transactionDetailTracker = 1
            }
        }
    }

    function loadTransactionAddresses(inputs, outputs){
        if (typeof inputs !== "undifined") {
            console.log("json input list: " + inputs)
            inputAddresses.clear();
            var objInput = JSON.parse(inputs);
            console.log("raw input list: " + objInput)
            for (var i in objInput){
                var dataInput = objInput[i];
                inputAddresses.append(dataInput);
            }
        }
        if (typeof outputs !== "undifined") {
            console.log("json output list: " + outputs)
            outputAddresses.clear();
            var objOutput = JSON.parse(outputs);
            console.log("raw ouput list: " + objOutput)
            for (var e in objOutput){
                var dataOutput = objOutput[e];
                outputAddresses.append(dataOutput);
            }
        }
    }

    function updateToAccount(){
        var dataModelWallet = []
        var datamodelContact = []
        var datamodelAddress = []

        for (var i = 0; i < walletList.count; ++i){
            dataModelWallet.push(walletList.get(i))
        }
        for (var e = 0; e < addressList.count; ++e){
            datamodelAddress.push(addressList.get(e))
        }
        for (var o = 0; o < contactList.count; ++o){
            datamodelContact.push(contactList.get(o))
        }

        var walletListJson = JSON.stringify(dataModelWallet)
        var addressListJson = JSON.stringify(datamodelAddress)
        var contactListJson = JSON.stringify(datamodelContact)

        updateAccount(addressListJson, contactListJson, walletListJson)
    }

    function editWalletInAddreslist(coin, address, label, remove) {
        for (var i = 0; i < addressList.count; i ++) {
            if (addressList.get(i).coin === coin && addressList.get(i).address === address) {
                addressList.setProperty(i, "label", label);
                addressList.setProperty(i, "remove", remove);
            }
        }
    }

    function deleteContactAddresses(contact) {
        for (var i = 0; i < addressList.count; i ++) {
            if (addressList.get(i).contact === contact) {
                addressList.setProperty(i, "remove", true);
            }
        }
    }

    function restoreContactAddresses(contact) {
        for (var i = 0; i < addressList.count; i ++) {
            if (addressList.get(i).contact === contact) {
                addressList.setProperty(i, "remove", false);
            }
        }
    }

    function clearAddressList() {
        for (var i = 0; i < addressList.count; i ++) {
            if (addressList.get(i).remove === true) {
                addressList.setProperty(i, "contact", 0);
                addressList.setProperty(i, "fullName", "");
                addressList.setProperty(i, "label", "");
                addressList.setProperty(i, "address", "");
                addressList.setProperty(i, "logo", '');
                addressList.setProperty(i, "coin", "");
                addressList.setProperty(i, "active", false);
                addressList.setProperty(i, "favorite", 0);
            }
        }
    }

    function clearContactList() {
        for (var i = 0; i < contactList.count; i ++) {
            if (contactList.get(i).remove === true) {
                contactList.setProperty(i, "firstName", "");
                contactList.setProperty(i, "lastName", "");
                contactList.setProperty(i, "photo", '');
                contactList.setProperty(i, "telNR", "");
                contactList.setProperty(i, "CellNR", "");
                contactList.setProperty(i, "mailAddress", "");
                contactList.setProperty(i, "chatID", "");
                contactList.setProperty(i, "favorite", false);
            }
        }
    }

    function clearWalletList() {
        for (var i = 0; i < walletList.count; i ++) {
            if (walletList.get(i).remove === true) {
                walletList.setProperty(i, "name", "");
                walletList.setProperty(i, "label", "");
                walletList.setProperty(i, "privatekey", "");
                walletList.setProperty(i, "publickey", "");
                walletList.setProperty(i, "address", "");
                walletList.setProperty(i, "balance", 0);
                walletList.setProperty(i, "unconfirmedCoins", 0);
                walletList.setProperty(i, "favorite", false);
                walletList.setProperty(i, "active", false);
                walletList.setProperty(i, "viewOnly", false);
                walletList.setProperty(i, "include", false);
            }
        }
    }

    function addWalletToList(coin, label, addr, pubkey, privkey, view){
        var favorite = true
        for(var o = 0; o < walletList.count; o ++) {
            if (favorite == true) {
                if (walletList.get(o).name === coin && walletList.get(o).favorite === true) {
                    favorite = false
                }
            }
        }
        walletList.append({"name": coin, "label": label, "address": addr, "privatekey" : privkey, "publickey" : pubkey ,"balance" : 0, "unconfirmedCoins": 0, "active": true, "favorite": favorite, "viewOnly" : view, "include" : true, "walletNR": walletID, "remove": false});
        walletID = walletID + 1
        addressList.append({"contact": 0, "fullname": "My addresses", "address": addr, "label": label, "logo": getLogo(coin), "coin": coin, "favorite": 0, "active": true, "uniqueNR": addressID, "remove": false});
        addressID = addressID +1;

        var dataModelWallet = []
        var datamodel = []

        for (var i = 0; i < walletList.count; ++i){
            dataModelWallet.push(walletList.get(i))
        }
        for (var e = 0; e < addressList.count; ++e){
            datamodel.push(addressList.get(e))
        }

        var walletListJson = JSON.stringify(dataModelWallet)
        var addressListJson = JSON.stringify(datamodel)

        saveWalletList(walletListJson, addressListJson)
    }

    function clearSettings(){
        userSettings.accountCreationCompleted = false;
        userSettings.defaultCurrency = 0;
        userSettings.theme = "dark";
        userSettings.pinlock = false;
        userSettings.locale = "en_us"
        userSettings.localKeys = false;
    }

    function initialiseLists() {
        addressList.append({"contact": 0, "address": "", "label": "", "logo": '', "coin": "", "favorite": 0, "active": false, "uniqueNR": 0, "remove": true})

        contactList.append({"firstName": "", "lastName": "", "photo": '', "telNR": "", "cellNR": "", "mailAddress": "", "chatID": "", "favorite": false, "active": false, "contactNR": 0, "remove": true})

        walletList.append({"name": "", "label": "", "address": "", "privatekey" : "", "publickey" : "" ,"balance" : 0, "unconfirmedCoins": 0, "active": false, "favorite": false, "viewOnly" : false, "walletNR": 0, "remove": true})
    }

    // loggin out
    function logOut () {
        console.log("resetting trackers")
        interactionTracker = 0
        loginTracker = 0
        logoutTracker = 0
        addWalletTracker = 0
        createWalletTracker = 0
        appsTracker = 0
        coinTracker = 0
        walletTracker = 0
        transferTracker = 0
        historyTracker = 0
        addressTracker = 0
        contactTracker = 0
        addAddressTracker = 0
        addCoinTracker = 0
        addContactTracker = 0
        editContactTracker = 0
        coinListTracker = 0
        walletListTracker = 0
        addressbookTracker = 0
        scanQRTracker = 0
        tradingTracker = 0
        balanceTracker = 0
        calculatorTracker = 0
        addressQRTracker = 0
        pictureTracker = 0
        cellTracker = 0
        currencyTracker = 0
        pincodeTracker = 0
        debugTracker = 0
        backupTracker = 0
        screenshotTracker = 0
        walletDetailTracker = 0
        portfolioTracker = 0
        transactionDetailTracker = 0
        console.log("resetting IDs")
        contactID = 1
        addressID = 1
        walletID = 1
        txID = 1
        pictureID = 0
        currencyID = 0
        console.log("resetting indexes")
        coinIndex = 0
        walletIndex = 0
        console.log("remove deleted items")
        clearAddressList()
        clearContactList()
        clearWalletList()
        console.log("save settings to account")
        updateToAccount()
        console.log("clearing front end lists")
        addressList.clear()
        contactList.clear()
        walletList.clear()
        alertList.clear()
        console.log("initializing front end lists")
        initialiseLists()
        console.log("clearing settings")
        username = ""
        selectedPage = ""
        clearAllSettings()
        Qt.quit()
    }

    // check for user interaction
    function detectInteraction() {
        if (interactionTracker == 0) {
            interactionTracker = 1
        }
    }

    // Listmodels
    ListModel {
        id: addressList
        ListElement {
            contact: 0
            fullName: ""
            label: ""
            address: ""
            logo: ''
            coin: ""
            active: false
            favorite: 0
            uniqueNR: 0
            remove: true
        }
    }

    ListModel {
        id: contactList
        ListElement {
            firstName: ""
            lastName: ""
            photo: 'qrc:/icons/icon-profile_01.svg'
            telNR: ""
            cellNR: ""
            mailAddress: ""
            chatID: ""
            favorite: false
            contactNR: 0
            remove: true
        }
    }

    ListModel {
        id: walletList
        ListElement {
            name: ""
            label: ""
            address: ""
            privatekey: ""
            publickey: ""
            balance: 0
            unconfirmedCoins: 0
            active: false
            favorite: false
            viewOnly: false
            include: false
            walletNR: 0
            remove: true
        }
    }

    ListModel {
        id: coinList
        ListElement {
            name: ""
            fullname: ""
            logo: ''
            logoBig: ''
            coinValueBTC: 0
            fiatValue: 0
            percentage: 0
            totalBalance: 0
            active: false
            testnet: false
            coinID: 0
        }
    }

    ListModel {
        id: transactionList
        ListElement {
            coinName: ""
            walletLabel: ""
            date: ""
            amount: 0
            txPartner: ""
            reference: ""
            txid: 0
            txNR: 0
        }
    }

    ListModel {
        id: historyList
        ListElement {
            txid: ""
            direction: false
            value: ""
            confirmations: 0
        }
    }

    ListModel {
        id: inputAddresses
        ListElement {
            address: ""
            amount: ""
        }
    }

    ListModel {
        id: outputAddresses
        ListElement {
            address: ""
            amount: ""
        }
    }

    ListModel {
        id: profilePictures
        ListElement {
            photo: ''
            pictureNR: 0
        }
    }

    ListModel {
        id: fiatCurrencies
        ListElement {
            currency: ""
            ticker: ""
            currencyNR: 0
        }
    }

    ListModel {
        id: alertList
        ListElement {
            date: "null"
            message: "null"
            origin: "null"
        }
    }

    // Global components
    Clipboard {
        id: clipboard
    }

    Settings {
        id: userSettings
        property string locale
        property int defaultCurrency
        property string theme
        property bool pinlock
        property bool accountCreationCompleted
        property bool localKeys

        onThemeChanged: {
            darktheme = userSettings.theme == "dark"? true : false
        }
    }

    // Global fonts
    FontLoader {
        id: xciteMobile
        name: "Brandon Grotesque"
    }

    FontLoader {
        id: xciteMobileSource
        source: 'qrc:/fonts/Brandon_reg.otf'
    }

    Network {
        id: network
        handler: wallet
    }

    SoundEffect {
        id: click01
        source: "qrc:/sounds/click_02.wav"
        volume: 0.15
    }
    Timer {
        id: marketValueTimer
        interval: 60000
        repeat: true
        running: sessionStart == 1
        onTriggered:  {
            marketValueChangedSignal("btcusd")
            marketValueChangedSignal("btceur")
            marketValueChangedSignal("btcgbp")
            marketValueChangedSignal("xbybtc")
            marketValueChangedSignal("xbycha")

        }
    }

    Timer {
        id: explorerTimer
        interval: 60000
        repeat: true
        running: sessionStart == 1
        onTriggered:  {
            var datamodel = []
            for (var i = 0; i < walletList.count; ++i)
                datamodel.push(walletList.get(i))

            var walletListJson = JSON.stringify(datamodel)
            updateBalanceSignal(walletListJson);

        }
    }

    Timer {
        id: loginTimer
        interval: 30000
        repeat: true
        running: sessionStart == 1

        onTriggered: {
            if (interactionTracker == 1) {
                sessionTime = 0
                interactionTracker = 0
                // reset timer on serverside
            }
            else {
                sessionTime = sessionTime +1
                if (sessionTime >= 10){
                    sessionTime = 0
                    sessionStart = 0
                    // show pop up that you will be logged out if you do not interact
                    autoLogout = 1
                    logoutTracker = 1
                }
            }
        }
    }

    Timer {
        id: networkTimer
        interval: 60000
        repeat: true
        running: sessionStart == 1

        onTriggered: {
            checkSessionId()
        }
    }

    Connections {
        target: UserSettings

        onSessionIdCheck: {
            if (sessionAlive === false && goodbey == 0 && manualLogout == 0 && autoLogout == 0) {
                console.log("session ID invalid")
                networkLogout = 1
                logoutTracker = 1
                sessionStart = 0
                sessionClosed = 1
            }
            else {
                console.log("session ID still valid")
            }
        }
    }

    Timer {
        id: requestTimer
        interval: 5000
        repeat: true
        running: sessionStart == 1

        onTriggered: {
            checkNotifications()
            if (requestedLogout == 1 && transferTracker == 0 && addAddressTracker == 0 && addContactTracker == 0 && addressTracker == 0 && editContactTracker == 0 && appsTracker == 0) {
                logoutTracker = 1
            }
        }
    }

    Timer {
        id: timer
        interval: 15000
        repeat: true
        running: sessionStart == 1

        onTriggered: {
            sumBalance()
            sumXBY()
            sumXFUEL()
            sumXBYTest()
            sumXFUELTest()
        }
    }
    // Order of the pages
    StackView {
        id: mainRoot
        initialItem: "../main.qml"
        anchors.fill: parent
    }

    onClosing: {
        if (mainRoot.depth > 1) {
            close.accepted = false
        }
    }
}
