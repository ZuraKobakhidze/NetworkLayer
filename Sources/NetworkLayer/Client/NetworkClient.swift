import Foundation

/// A protocol representing a network client capable of making network requests.
///
/// Conforming types define properties and methods for performing asynchronous network requests
/// using a specified session and handling authentication tokens.
///
/// - Usage:
/// ```swift
/// struct MyNetworkClient: NetworkClient {
///     let session: NetworkSession = URLSession.shared
/// }
/// ```
public protocol NetworkClient {
    /// The network session used for making network requests.
    var session: NetworkSession { get }
    
    /// A list of network token providers for handling authentication tokens.
    var networkTokenProviderList: [NetworkTokenProvider] { get }
    
    /// Makes an asynchronous network request and decodes the response into a specified type.
    ///
    /// - Parameters:
    ///   - endpoint: The network endpoint to request.
    /// - Returns: A decoded instance of the specified type.
    /// - Throws: An error if the network request fails or if decoding the response fails.
    func request<T: Decodable>(endpoint: NetworkEndpoint) async throws -> T where T: Decodable
}

public extension NetworkClient {
    /// The default list of network token providers.
    var networkTokenProviderList: [NetworkTokenProvider] { [] }
}
