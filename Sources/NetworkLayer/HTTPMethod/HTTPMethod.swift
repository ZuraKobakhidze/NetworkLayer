/// An enumeration representing HTTP methods.
///
/// This enum defines the various HTTP methods used in network requests.
/// Each case is associated with its corresponding string value used in HTTP requests.
///
/// - Usage:
/// ```swift
/// let method: HTTPMethod = .get
/// var request = URLRequest(url: URL(string: "https://www.example.com")!)
/// request.httpMethod = method.rawValue
/// ```
///
/// - Cases:
///   - `get`: Represents an HTTP GET request.
///   - `head`: Represents an HTTP HEAD request.
///   - `post`: Represents an HTTP POST request.
///   - `put`: Represents an HTTP PUT request.
///   - `delete`: Represents an HTTP DELETE request.
///   - `connect`: Represents an HTTP CONNECT request.
///   - `options`: Represents an HTTP OPTIONS request.
///   - `trace`: Represents an HTTP TRACE request.
///   - `patch`: Represents an HTTP PATCH request.
public enum HTTPMethod: String {
    /// Represents an HTTP GET request.
    case get = "GET"
    
    /// Represents an HTTP HEAD request.
    case head = "HEAD"
    
    /// Represents an HTTP POST request.
    case post = "POST"
    
    /// Represents an HTTP PUT request.
    case put = "PUT"
    
    /// Represents an HTTP DELETE request.
    case delete = "DELETE"
    
    /// Represents an HTTP CONNECT request.
    case connect = "CONNECT"
    
    /// Represents an HTTP OPTIONS request.
    case options = "OPTIONS"
    
    /// Represents an HTTP TRACE request.
    case trace = "TRACE"
    
    /// Represents an HTTP PATCH request.
    case patch = "PATCH"
}
