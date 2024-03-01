//
//  ImmersiveView.swift
//  crypto
//
//  Created by Tech9320 on 2/24/24.
//

import SwiftUI
import RealityKit
import RealityKitContent

struct ImmersiveView: View {
    
    @State private var rate = ""
    
    @Environment(\.dismissWindow) var dismissWindow
    @Environment(\.openWindow) var openWindow

    var viewModel: ViewModel

    @State private var ball = Entity()
    
    var body: some View {
        RealityView { content in
            dismissWindow(id: "StartingWindow")
            print("Tuki")
            self.ball = try! await Entity(named: "Scene", in: realityKitContentBundle)
            ball.scale = [2, 2, 2]
            ball.transform.rotation = simd_quatf(angle: .pi / 4, axis: [0, 1, 0]);
            content.add(ball)
            let textEntity = viewModel.addText(text: "\(String(format: "%.2f", yourBitcoinBalance)) USD" )
            content.add(textEntity)
        }
        
        Button("Close") {
            openWindow(id: "StartingWindow")
            dismissWindow(id: "ImmersiveSpace")
        }
        .frame(width: 100, height: 50)
        .background(Color.red)
        .foregroundColor(.white)
        .cornerRadius(10)
        Button("Refresh") {
            fetchBitcoinPrice()
            dismissWindow(id: "ImmersiveSpace")
            openWindow(id: "ImmersiveSpace")

        }
        .frame(width: 100, height: 50)
        .foregroundColor(.white)
        .cornerRadius(10)
        
    }
    
    func fetchBitcoinPrice(){
        print("Fetching Bitcoin Price")
        let url = URL(string: "https://api.coindesk.com/v1/bpi/currentprice.json")!
        let task = URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                print("Error: \(error)")
            } else if let data = data {
                let json = try! JSONSerialization.jsonObject(with: data, options: []) as! [String: Any]
                let bpi = json["bpi"] as! [String: Any]
                let usd = bpi["USD"] as! [String: Any]
                let rate = usd["rate"] as! String
                self.rate = rate
                print("Bitcoin price: \(rate)")
                calculateYourBitcoinBalance()
            }
        }
        task.resume()

    }
    
    func calculateYourBitcoinBalance(){
        if let bitcoinAmount = Double(kolkoSamUneo) {
            if let bitcoinRate = Double(rate.replacingOccurrences(of: ",", with: "")) {
                yourBitcoinBalance = bitcoinAmount * bitcoinRate + 10
            }
        } else {
            yourBitcoinBalance = 0.0
        }
        self.rate = rate
    }
}

#Preview {
    ImmersiveView(viewModel: ViewModel())
        .previewLayout(.sizeThatFits)
}
