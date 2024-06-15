/// A type alias representing a dictionary of network headers.
///
/// This type alias maps header field names to their respective values as strings,
/// and is used for specifying HTTP headers in network requests.
///
/// - Usage:
/// ```swift
/// var headers: NetworkHeaders = ["Content-Type": "application/json",
///                                "Authorization": "Bearer token"]
///
/// var request = URLRequest(url: URL(string: "https://www.example.com")!)
/// request.allHTTPHeaderFields = headers
/// ```
///
/// - Note: Make sure to validate the headers according to your requirements before assigning them to a request.
public typealias NetworkHeaders = [String: String]
