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
    /// Returns the current token, fetching a new one if necessary.
    ///
    /// This method checks if the current token is valid. If it is, it returns the token.
    /// Otherwise, it fetches a new token by calling `fetchToken()`.
    ///
    /// - Returns: The current valid token.
    /// - Throws: An error if the token cannot be retrieved.
    func getToken() async throws -> NetworkToken
}
