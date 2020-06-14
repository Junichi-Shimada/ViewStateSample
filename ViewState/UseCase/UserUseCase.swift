//
//  UserUseCase.swift
//  ViewState
//
//  Created by junichi.shimada on 2020/06/13.
//  Copyright © 2020 junichi.shimada. All rights reserved.
//

import Foundation

enum State {
    case idle
    case loading
    case loaded([User])
    case nodata
    case error
}

protocol ViewProcotol {
    func update(state: State)
}

class UserUseCase {
    var viewOutput: ViewProcotol?
    private var state: State = .idle
    
    func fetch() {
        if case .loading = state {
            return
        }
        
        state = .loading
        self.viewOutput?.update(state: state)
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            let iRandom = Int.random(in: 1...3)
            switch(iRandom) {
            case 1:
                self?.state = .loaded(userData)
            case 2:
                self?.state = .nodata
            case 3:
                self?.state = .error
            default:
                break
            }
            self?.viewOutput?.update(state: self!.state)
            self?.state = .idle
        }
//        let url = URL(string: "https://www.google.co.jp")!
//        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
//            if error != nil {
//                self.state = .error
//            }
//            if let _ = data, let _ = response {
//                self.state = .loaded(userData)
//            }
//            DispatchQueue.main.async {
//                self.viewOutput?.update(state: self.state)
//            }
//        }
//        task.resume()
    }
}
