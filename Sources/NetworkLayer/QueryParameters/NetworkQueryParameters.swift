import Foundation

/// A type alias representing a dictionary of network query parameters.
///
/// This type alias maps parameter names to their respective values as strings,
/// and is used for constructing URL query strings.
///
/// - Usage:
/// ```swift
/// let queryParameters: NetworkQueryParameters = ["search": "swift", "page": "1"]
/// let url = URL(string: "https://www.example.com")!
/// var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false)!
/// urlComponents.queryItems = queryParameters.parameters
/// let finalURL = urlComponents.url!
/// print(finalURL) // "https://www.example.com?search=swift&page=1"
/// ```
public typealias NetworkQueryParameters = [String: String]

public extension NetworkQueryParameters {
    /// Converts the dictionary of query parameters to an array of `URLQueryItem`.
    ///
    /// This computed property maps each key-value pair in the dictionary to a `URLQueryItem`,
    /// which can then be used to construct a query string for a URL.
    ///
    /// - Returns: An array of `URLQueryItem` representing the query parameters.
    var parameters: [URLQueryItem] {
        self.map { .init(name: $0.key, value: $0.value) }
    }
}
