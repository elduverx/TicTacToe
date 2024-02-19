//
//  File.swift
//  TicTacToe
//
//  Created by duverney muriel on 14/02/24.
//

import SwiftUI

struct AlertItem: Identifiable{
    let id = UUID()
    var title: Text
    var message: Text
    var buttonTitle: Text
}

struct AlertContext {
    static let humanWin = AlertItem(title: Text("You Win"), message: Text("Youre a beater"), buttonTitle: Text("you have a balls as a bowling ball"))
    static let computerwin = AlertItem(title: Text("You defeated"), message: Text("You were beater by AI."), buttonTitle: Text("youre nuts"))
    static let draw = AlertItem(title: Text("Draw"), message: Text("no body won"), buttonTitle: Text("Try Again"))
}
