//
//  GameViewModel.swift
//  TicTacToe
//
//  Created by duverney muriel on 14/02/24.
//

import SwiftUI


final class GameViewModel: ObservableObject{
    
    let columns: [GridItem] = [GridItem(.flexible()),
                               GridItem(.flexible()),
                               GridItem(.flexible()),]
    
    
    @Published var moves: [Move?] = Array(repeating: nil, count: 9)
    @Published var isGameboardDisabled:Bool = false
    @Published var alertItem: AlertItem?
    
    
    func proccessPlayerMoves(for position: Int){
        if isSquareOccupied(in: moves, forIndex: position) {return}
        moves[position] = Move(player: .human, boardIndex: position)
        
        //                             Check for win condition or draw
        if checkWinCondition(for: .human, in: moves){
            alertItem = AlertContext.humanWin
            return
        }
        
        if checkForDraw(in: moves){
            alertItem = AlertContext.draw
            return
        }
        
        
        isGameboardDisabled = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5){ [self] in
            let computerPosition = determineComputerMovePosition(in: moves)
            moves[computerPosition] = Move(player: .computer, boardIndex: computerPosition)
            isGameboardDisabled = false
            
            if checkWinCondition(for: .computer, in: moves){
                alertItem = AlertContext.computerwin
                return
            }
            if checkForDraw(in: moves){
                alertItem = AlertContext.draw
                return
            }
        }
        
    }
    
    
    //
    
    
    func isSquareOccupied(in moves: [Move?], forIndex index: Int) -> Bool {
        return moves.contains { $0?.boardIndex == index }
    }
    
    func determineComputerMovePosition(in moves: [Move?]) -> Int {
        //        if IA can win, then win
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5],[6,7,8], [0,3,6], [1,4,7], [2,5,8], [2,4,6],[0,4,8]]
        let computerMoves = moves.compactMap{$0}.filter { $0.player == .computer}
        let computerPositions = Set(computerMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(computerPositions)
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first! }
            }
        }
        
        //        if IA cant win, then block
        let humanMoves = moves.compactMap{$0}.filter { $0.player == .human}
        let humanPositions = Set(humanMoves.map{ $0.boardIndex })
        
        for pattern in winPatterns {
            let winPositions = pattern.subtracting(humanPositions)
            if winPositions.count == 1 {
                let isAvaiable = !isSquareOccupied(in: moves, forIndex: winPositions.first!)
                if isAvaiable { return winPositions.first! }
            }
        }
        //        if IA can't block then take the mid square
        let centerSquare = 4
        if !isSquareOccupied(in: moves, forIndex: centerSquare){
            return centerSquare
        }
        //        if IA can't take the middle square, take random available square
        var movePosition = Int.random(in: 0..<9)
        
        while isSquareOccupied(in: moves, forIndex: movePosition){
            movePosition = Int.random(in: 0..<9)
        }
        return movePosition
    }
    
    func checkWinCondition(for player: Player, in moves: [Move?]) -> Bool {
        //        configure win condition pattern
        let winPatterns: Set<Set<Int>> = [[0,1,2], [3,4,5],[6,7,8], [0,3,6], [1,4,7], [2,5,8], [2,4,6],[0,4,8]]
        //        choose between player moves.
        let playerMoves = moves.compactMap{$0}.filter { $0.player == player}
        
        //         make a map for each player moves to reach the position or last position.
        let playerPositions = Set(playerMoves.map{ $0.boardIndex })
        
        
        //   el sub set es el configurador que pone el ultimo movimiento haciendo seguir el patron.
        
        for pattern in winPatterns where pattern.isSubset(of:playerPositions) { return true }
        
        return false
    }
    
    func checkForDraw(in moves: [Move?]) -> Bool {
        return moves.compactMap { $0 }.count == 9
    }
    
    func resetGame(){
        moves =  Array(repeating: nil, count: 9)
    }
    
}
