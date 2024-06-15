import Foundation

/// A default implementation of the `NetworkSession` protocol using `URLSession`.
///
/// This class provides a default implementation for performing network data tasks
/// using `URLSession`. It allows for dependency injection of a custom `URLSession` instance,
/// making it versatile for testing and different configurations.
///
/// - Usage:
/// ```swift
/// let request = URLRequest(url: URL(string: "https://www.example.com")!)
/// let networkSession = DefaultNetworkSession()
/// do {
///     let (data, response) = try await networkSession.dataTask(with: request)
///     // Process the data and response
/// } catch {
///     print("Network request failed: \(error)")
/// }
/// ```
open class DefaultNetworkSession: NetworkSession {
    /// The URL session used to perform network tasks.
    private let session: URLSession
    
    /// Initializes a new `DefaultNetworkSession` instance.
    ///
    /// - Parameter session: The `URLSession` instance to be used for network tasks.
    ///   Defaults to `URLSession.shared`.
    public init(session: URLSession = .shared) {
        self.session = session
    }
    
    /// Performs a data task with the specified URL request.
    ///
    /// This method sends the given request and returns the response data and URL response asynchronously.
    ///
    /// - Parameter request: The URL request to be sent.
    /// - Returns: A tuple containing the response data and URL response.
    /// - Throws: An error if the network request fails.
    open func dataTask(with request: URLRequest) async throws -> (Data, URLResponse) {
        try await session.data(for: request)
    }
}
