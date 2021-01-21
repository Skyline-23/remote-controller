//
//  ViewController.swift
//  remote-controller
//
//  Created by 김부성 on 1/11/21.
//

import UIKit
import CocoaAsyncSocket

class ViewController: UIViewController, GCDAsyncSocketDelegate {
    
    enum list: String {
        case front = "Go"
        case back = "100"
        case left = "Left"
        case right = "Right"
        case connection_sign = "iOS"
    }
    // 호스트 지정
    let host = "192.168.43.7"
    // 포트 번호 지정
    let port:UInt16 = 8080
    // 소켓 변수 지정
    var socket: GCDAsyncSocket?
        
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    override func viewDidAppear(_ animated: Bool) {
        connect(host: host, port: port)
    }
    override func viewDidDisappear(_ animated: Bool) {
        socket?.disconnect()
    }
    
    @IBAction func uparrow(_ sender: Any) {
        let front = Data(list.front.rawValue.utf8)
        //변환된 데이터 타입을 보냄
        socket?.write(front as Data, withTimeout: 100, tag: 0)
    }
    @IBAction func rightarrow(_ sender: Any) {
        let right = Data(list.right.rawValue.utf8)
        //변환된 데이터 타입을 보냄
        socket?.write(right as Data, withTimeout: 100, tag: 0)
    }
    @IBAction func downarrow(_ sender: Any) {
        let back = Data(list.back.rawValue.utf8)
        //변환된 데이터 타입을 보냄
        socket?.write(back as Data, withTimeout: 100, tag: 0)
    }
    @IBAction func leftarrow(_ sender: Any) {
        let left = Data(list.left.rawValue.utf8)
        //변환된 데이터 타입을 보냄
        socket?.write(left as Data, withTimeout: 100, tag: 0)
    }
    
    
    // 연결 부분 함수
    func connect (host: String, port: UInt16) {
        // 소켓 지정
        socket = GCDAsyncSocket(delegate: self, delegateQueue: .main)
        do{
            // 서버 커넥팅
            print("서버에 연결중...")
            // try로 소켓 연결 시도, host, port번호 지정해놓고 타임아웃 시간 지정
            socket = GCDAsyncSocket(delegate: self, delegateQueue: .main)
            try socket?.connect(toHost: host, onPort: port, withTimeout: 5000)
            // 만약 연결이 되었을 경우 함수를 실행에 연결되었다고 표시
            let data = Data(list.connection_sign.rawValue.utf8)
            // 연결 사인 전송
            print("연결사인을 보냄")
            socket?.write(data, withTimeout: 100, tag: 0)
            // 데이터를 읽어옴
            socket?.readData(withTimeout: 100, tag: 0)
        } catch let error {
            //만약 에러를 띄운다면, 에러를 출력하도록 함
            print(error)
        }
    }

    // 소켓이 연결되었을 경우, 어디에 연결되었는지 표시함
    func socket(_ sock: GCDAsyncSocket, didConnectToHost host: String, port: UInt16) {
        print("호스트에 연결됨\n소켓 : \(sock)\n주소 : \(host)\n포트번호 : \(port)")
    }
    
    // 데이터를 읽어오면 실행되어서 처리하는 함수
    func socket(_ sock: GCDAsyncSocket, didRead data: Data, withTag tag: Int) {
        print("읽기 함수가 실행됨")
        let string = String(data: data, encoding: .utf8)
        print(string!)
    }
}

