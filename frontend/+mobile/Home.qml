import QtQuick 2.0
import QtQuick.Window 2.2

Item {

    id: homepageLoader
    width: Screen.width
    height: Screen.Height

    Rectangle {
        anchors.fill: parent
        color: "#42454F"
    }

    Component.onCompleted: {
        goodbey = 0

        walletID = walletList.count
        contactID = contactList.count
        addressID = addressList.count
        txID = transactionList.count

        // finish account setup
        if (userSettings.accountCreationCompleted === false) {
            mainRoot.pop()
            mainRoot.push("../InitialSetup.qml")
        }
        // continue to wallet
        else {
            sumBalance()
            sumXBY()
            sumXFUEL()
            sumXBYTest()
            sumXFUELTest()
            checkNotifications()
            marketValueChangedSignal("btcusd")
            marketValueChangedSignal("btceur")
            marketValueChangedSignal("btcgbp")
            marketValueChangedSignal("xbybtc")
            marketValueChangedSignal("xbycha")
            mainRoot.push("../DashboardForm.qml")
            selectedPage = "home"
        }
    }
}
