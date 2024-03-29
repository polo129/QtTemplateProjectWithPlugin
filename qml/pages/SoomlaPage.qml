import Felgo 3.0
import QtQuick 2.5
import "../helper"

ListPage {

    title: "Soomla Plugin"

    listView.header: Column {
        width: parent.width

        SectionDescription { text: "Integrate with Soomla to offer in-app purchases and a virtual economy model within your app." }
        SectionContent {
            contentItem: AppImage {
                width: sourceSize.width * dp(1) * 0.75
                height: width / sourceSize.width * sourceSize.height
                source: Qt.resolvedUrl("../../assets/code-soomla.png")
            }
        }
        SectionContent {
            contentItem: AppImage {
                anchors.horizontalCenter: parent.horizontalCenter
                width: sourceSize.width * dp(1) * 0.5
                height: width / sourceSize.width * sourceSize.height
                source: Qt.resolvedUrl("../../assets/logo-soomla.png")
            }
        }

        SectionHeader { text: "Example" }
        SectionContent { contentItem: Row {
                spacing: dp(10)
                anchors.horizontalCenter: parent.horizontalCenter

                AppText { text: "Credits:" }
                AppText { text: "" + creditsCurrency.balance }
                AppText { text: "Goodies:" }
                AppText { text: "" + goodieGood.balance }
            }
        }
    }

    listView.anchors.bottomMargin: annoyingAd.visible ? annoyingAd.height : 0

    model: ListModel {
        ListElement { section: "Credits"; name: "Buy 10 credits" }

        ListElement { section: "Goodies"; name: "Buy 1 goodie" }

        ListElement { section: "Product"; name: "Give Ad-Free Upgrade" }
        ListElement { section: "Product"; name: "Take Ad-Free Upgrade" }
        ListElement { section: "Product"; name: "Buy Ad-Free Upgrade" }

        ListElement { section: "Store"; name: "Restore Purchases" }
    }

    delegate: SimpleRow {
        text: name

        onSelected: {
            if (index === 0) {
                store.buyItem(creditsPack.itemId)
            }
            else if (index === 1) {
                store.buyItem(goodieGood.itemId)
            }
            else if (index === 2) {
                store.giveItem(noadsGood.itemId)
            }
            else if (index ===3) {
                store.takeItem(noadsGood.itemId)
            }
            else if (index === 4) {
                store.buyItem(noadsGood.itemId)
            }
            else if (index === 5) {
                store.restoreAllTransactions()
            }
        }
    }

    section.property: "section"
    section.delegate: SimpleSection { }

    // This rectangle represents an ad banner within your app
    Rectangle {
        id: annoyingAd
        anchors.bottom: parent.bottom
        width: parent.width
        height: dp(50)

        // Just one line for handling visiblity of the ad banner, you can use property binding for this!
        visible: !noadsGood.purchased

        SequentialAnimation on color {
            loops: Animation.Infinite
            ColorAnimation { from: "green"; to: "red"; duration: 300 }
            ColorAnimation { from: "red"; to: "green"; duration: 300 }
        }

        Text {
            text: "Annoying Ad"
            font.pixelSize: dp(20)
            color: "white"
            anchors.centerIn: parent
        }
    }

    Store {
        id: store

        version: 1
        secret: Constants.soomlaSecret
        androidPublicKey: Constants.soomlaAndroidPublicKey

        // Virtual currencies within the game
        currencies: [
            Currency {
                id: creditsCurrency
                itemId: Constants.creditsCurrencyItemId
                name: "Credits"
            }
        ]

        // Purchasable credit packs
        currencyPacks: [
            CurrencyPack {
                id: creditsPack
                itemId: Constants.creditsPackItemId
                name: "10 Credits"
                description: "Buy 10 Credits"
                currencyId: creditsCurrency.itemId
                currencyAmount: 10
                purchaseType:  StorePurchase { id: gold10Purchase; productId: creditsPack.itemId; price: 0.99 }
            }
        ]

        // Goods contain either single-use, single-use-pack or lifetime goods
        goods: [
            // A goodie costs 3 credits (virtual currency that can be purschased with an in-app purchase)
            SingleUseGood {
                id: goodieGood
                itemId: Constants.goodieItemId
                name: "Goodie"
                description: "A tasty goodie"
                purchaseType: VirtualPurchase { itemId: creditsCurrency.itemId; amount: 3; }
            },
            // Life-time goods can be restored from the store
            LifetimeGood {
                id: noadsGood
                itemId: Constants.noAdsItemId
                name: "No Ads"
                description: "Buy this item to remove the app banner"
                purchaseType: StorePurchase { id: noAdPurchase; productId: noadsGood.itemId; price: 2.99; }
            }
        ]

        onItemPurchased: {
            console.debug("Purchases item:", itemId)
            NativeDialog.confirm("Info", "Successfully bought: " + itemId, null, false)
        }

        onInsufficientFundsError: {
            console.debug("Insufficient funds for purchasing item")
            NativeDialog.confirm("Error",
                                 "Insufficient credits for buying a goodie, get more credits now?",
                                 function(ok) {
                                     if (ok) {
                                         // Trigger credits purchase right from dialog
                                         store.buyItem(creditsPack.itemId)
                                     }
                                 },
                                 true)
        }

        onRestoreAllTransactionsFinished: {
            console.debug("Purchases restored with success:", success)
        }
    }
}
