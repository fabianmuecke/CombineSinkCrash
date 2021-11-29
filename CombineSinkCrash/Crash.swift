//
//  Crash.swift
//  CombineSinkCrash
//
//  Created by Fabian Mücke on 29.11.21.
//

import Combine
import Foundation

func crashMe() {
    var retained = [AnyCancellable]()
    let queue = DispatchQueue(label: "com.linguee.crash", qos: .default, attributes: .concurrent)
    let subject = CurrentValueSubject<String, Never>("")
    for counter in 0 ... 200_000 {
        let currentCount = counter
        retained.append(
            Deferred { () -> AnyPublisher<String, Never> in
                var cancelled = false
                let lock = NSLock()
                return Future<String, Never> { promise in
                    lock.lock()
                    if cancelled {
                        lock.unlock()
                        return
                    }
                    lock.unlock()
                    print("running: \(currentCount)")
                    promise(.success("\(currentCount)"))
                }
                .handleEvents(receiveCancel: {
                    lock.lock()
                    cancelled = true
                    lock.unlock()
                })
                .eraseToAnyPublisher()
            }
            .handleEvents(receiveCancel: {
                print("cancelled: \(currentCount)")
            })
            .subscribe(on: queue)
            // This crashes:
            .sink(receiveValue: { value in
                print("value: \(value)")
            })
            // This doesn't:
//                .subscribe(subject)
        )

        if counter % 10 == 0 {
            print("cancelling at: \(currentCount)")
            retained = []
        }
    }
}
