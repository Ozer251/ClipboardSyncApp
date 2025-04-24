
import SwiftUI

struct ContentView: View {
    @State private var message = "Press to send clipboard"
    var body: some View {
        VStack(spacing: 20) {
            Text(message)
                .multilineTextAlignment(.center)
                .padding()
            Button("Send Clipboard to PC") {
                sendClipboard()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(8)
        }
    }

    func sendClipboard() {
        if let clipboardText = UIPasteboard.general.string {
            guard let url = URL(string: "http://192.168.68.50:5000/clipboard") else {
                message = "Invalid server URL"
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "POST"
            request.setValue("application/json", forHTTPHeaderField: "Content-Type")
            let json = ["text": clipboardText]
            request.httpBody = try? JSONSerialization.data(withJSONObject: json)
            URLSession.shared.dataTask(with: request) { _, _, _ in
                DispatchQueue.main.async {
                    message = "Clipboard sent!"
                }
            }.resume()
        } else {
            message = "No clipboard text"
        }
    }
}
