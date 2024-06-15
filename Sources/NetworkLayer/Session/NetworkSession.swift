import Foundation

/// A protocol representing a network session capable of performing data tasks.
///
/// Conforming types are responsible for performing network data tasks given a URL request,
/// returning the resulting data and URL response asynchronously.
///
/// - Usage:
/// ```swift
/// struct URLSessionNetworkSession: NetworkSession {
///     func dataTask(with request: URLRequest) async throws -> (Data, URLResponse) {
///         let (data, response) = try await URLSession.shared.data(for: request)
///         return (data, response)
///     }
/// }
///
/// let request = URLRequest(url: URL(string: "https://www.example.com")!)
/// let networkSession: NetworkSession = URLSessionNetworkSession()
/// do {
///     let (data, response) = try await networkSession.dataTask(with: request)
///     // Process the data and response
/// } catch {
///     print("Network request failed: \(error)")
/// }
/// ```
public protocol NetworkSession {
    /// Performs a data task with the specified URL request.
    ///
    /// This method sends the given request and returns the response data and URL response asynchronously.
    ///
    /// - Parameter request: The URL request to be sent.
    /// - Returns: A tuple containing the response data and URL response.
    /// - Throws: An error if the network request fails.
    func dataTask(with request: URLRequest) async throws -> (Data, URLResponse)
}

