/// A protocol representing a network authentication token.
///
/// Conforming types represent tokens used for authenticating network requests.
/// They provide the HTTP header field, the token value, and a validity check.
///
/// - Usage:
/// ```swift
/// struct MyToken: NetworkToken {
///     var httpHeaderField: String {
///         return "Authorization"
///     }
///
///     var value: String? {
///         return "Bearer myAccessToken"
///     }
///
///     var isValid: Bool {
///         return value != nil && !value!.isEmpty
///     }
/// }
///
/// let token = MyToken()
/// if token.isValid {
///     print("Token is valid and can be used in network requests.")
/// }
/// ```
public protocol NetworkToken {
    /// The HTTP header field name where the token should be included.
    ///
    /// For example, this could be "Authorization" for bearer tokens.
    var httpHeaderField: String { get }
    
    /// The value of the token.
    ///
    /// This could be a bearer token, API key, or other forms of tokens used for authentication.
    /// It can be `nil` if no token is available.
    var value: String? { get }
    
    /// A Boolean value indicating whether the token is valid.
    ///
    /// The validity check can include conditions like whether the token is non-nil, non-empty,
    /// or not expired. Specific implementations will define the exact criteria.
    var isValid: Bool { get }
}
