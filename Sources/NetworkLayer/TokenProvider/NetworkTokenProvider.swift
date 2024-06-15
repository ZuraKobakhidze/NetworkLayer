/// A protocol for providing network authentication tokens.
///
/// Types conforming to this protocol are responsible for managing and providing
/// network tokens, including fetching and refreshing tokens as needed.
///
/// - Usage:
/// ```swift
/// struct MyTokenProvider: NetworkTokenProvider {
///     var token: NetworkToken?
///
///     func getToken() async throws -> NetworkToken {
///         if let token = token, token.isValid {
///             return token
///         } else {
///             return try await fetchToken()
///         }
///     }
///
///     func fetchToken() async throws -> NetworkToken {
///         // Implementation to fetch a new token from the server.
///         let newToken = MyToken()
///         self.token = newToken
///         return newToken
///     }
///
///     func refreshToken() async throws -> NetworkToken {
///         // Implementation to refresh the token.
///         let refreshedToken = MyToken()
///         self.token = refreshedToken
///         return refreshedToken
///     }
/// }
///
/// // Example usage:
/// let tokenProvider = MyTokenProvider()
/// do {
///     let token = try await tokenProvider.getToken()
///     print("Token obtained: \(token.value ?? "nil")")
/// } catch {
///     print("Failed to get token: \(error)")
/// }
/// ```
public protocol NetworkTokenProvider {
    /// The current network token.
    ///
    /// This property holds the current token, which may be `nil` if no token is available.
    var token: NetworkToken? { get set }
    
    /// Returns the current token, fetching a new one if necessary.
    ///
    /// This method checks if the current token is valid. If it is, it returns the token.
    /// Otherwise, it fetches a new token by calling `fetchToken()`.
    ///
    /// - Returns: The current valid token.
    /// - Throws: An error if the token cannot be retrieved.
    func getToken() async throws -> NetworkToken
    
    /// Fetches a new token from the server.
    ///
    /// This method should contain the implementation to request a new token from the server
    /// and store it in the `token` property.
    ///
    /// - Returns: The newly fetched token.
    /// - Throws: An error if the token cannot be fetched.
    func fetchToken() async throws -> NetworkToken
    
    /// Refreshes the current token.
    ///
    /// This method should contain the implementation to refresh the token,
    /// which typically involves making a network request to get a new token
    /// based on the current token.
    ///
    /// - Returns: The refreshed token.
    /// - Throws: An error if the token cannot be refreshed.
    func refreshToken() async throws -> NetworkToken
}
