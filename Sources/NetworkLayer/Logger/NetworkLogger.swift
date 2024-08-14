import Foundation

/// A protocol that defines methods for logging network requests and responses.
public protocol NetworkLogger {
    
    /// Logs the details of a network request.
    /// - Parameter request: The `URLRequest` object representing the network request.
    func logRequest(_ request: URLRequest)
    
    /// Logs an error encountered while making a network request.
    /// - Parameter error: A `NetworkError` object representing the error that occurred.
    func logRequestError(_ error: NetworkError)
    
    /// Logs the details of a network response, optionally including the response data.
    /// - Parameters:
    ///   - response: The `HTTPURLResponse` object representing the network response.
    ///   - data: An optional `Data` object containing the body of the response, if any.
    func logResponse(_ response: HTTPURLResponse, data: Data?)
    
    /// Logs an error encountered while handling a network response.
    /// - Parameter error: A `NetworkError` object representing the error that occurred.
    func logResponseError(_ error: NetworkError)
}
