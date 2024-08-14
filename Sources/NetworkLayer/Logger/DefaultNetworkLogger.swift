import Foundation

final public class DefaultNetworkLogger: NetworkLogger {
    public init() { }
    
    public func logRequest(_ request: URLRequest) {
        print("\n🚀 - - - - - - OUTGOING REQUEST - - - - - - 🚀\n")
        
        let url = request.url?.absoluteString ?? .empty
        let urlComponents = URLComponents(string: url)
        
        var logOutput = """
            URL: \(url)\n
            HTTPMethod: \(request.httpMethod ?? .empty)\n
            HOST: \(urlComponents?.host ?? .empty)\n
            PATH: \(urlComponents?.path ?? .empty)\n
            QUERY: \(urlComponents?.query ?? .empty)\n
            HTTPHeaderFields: \n
        """
        
        request
            .allHTTPHeaderFields?
            .forEach { logOutput += "\t\t\($0.key): \($0.value)\n" }
        
        if let httpBody = request.httpBody {
            logOutput.append("\n\tHTTPBody: \n")
            if let jsonString = httpBody.jsonString {
                logOutput.append("\(jsonString)\n")
            } else {
                logOutput.append("\(httpBody.toString)\n")
            }
        }
        
        print(logOutput)
        print("🚀 - - - - - - END - - - - - - 🚀\n")
    }
    
    public func logRequestError(_ error: NetworkError) {
        print("\n⚠️ - - - - - - ERROR REQUEST - - - - - - ⚠️\n")
        
        print("ERROR: \(error.localizedDescription)\n")
        
        print("⚠️ - - - - - - END - - - - - - ⚠️\n")
    }
    
    public func logResponse(_ response: HTTPURLResponse, data: Data?) {
        print("\n📩 - - - - - - INCOMING RESPONSE - - - - - - 📩\n")
        
        var logOutput = """
            URL: \(response.url?.absoluteString ?? .empty)\n
            StatusCode: \(response.statusCode)\n
            HTTPHeaderFields: \n
        """
        
        response
            .allHeaderFields
            .forEach { logOutput.append("\t\t\($0.key): \($0.value)\n") }
        
        if let data = data {
            logOutput.append("\n\tDATA: \n")
            if let jsonString = data.jsonString {
                logOutput.append("\(jsonString)\n")
            } else {
                logOutput.append("\(data.toString)\n")
            }
        }
        
        print(logOutput)
        print("📩 - - - - - - END - - - - - - 📩\n")
    }
    
    public func logResponseError(_ error: NetworkError) {
        print("\n⛔ - - - - - - ERROR RESPONSE - - - - - - ⛔\n")
        
        print("ERROR: \(error.localizedDescription)\n")
        
        print("⛔ - - - - - - END - - - - - - ⛔\n")
    }
}

private extension Data {
    var jsonString: String? {
        if let jsonObject = try? JSONSerialization.jsonObject(with: self),
           let jsonData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted),
           let jsonString = String(data: jsonData, encoding: .utf8) {
            return jsonString
        } else {
            return nil
        }
    }
    
    var toString: String {
        String(data: self, encoding: .utf8) ?? .empty
    }
}

private extension String {
    static var empty: String {
        ""
    }
}
