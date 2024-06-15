import Foundation

/// A protocol representing a network endpoint.
///
/// Conforming types define the properties necessary to construct a network request,
/// such as the URL scheme, host, path, HTTP method, headers, query parameters, body, etc.
///
/// - Note: Conforming types may provide default implementations for some properties.
///
/// - Usage:
/// ```swift
/// struct MyEndpoint: NetworkEndpoint {
///     let host = "api.example.com"
///     let urlPath = "/endpoint"
///     let httpMethod = HTTPMethod.get
/// }
/// ```
public protocol NetworkEndpoint {
    /// The URL scheme of the endpoint.
    var scheme: URLScheme { get }
    
    /// The host of the endpoint.
    var host: String { get }
    
    /// The URL path of the endpoint.
    var urlPath: String { get }
    
    /// The HTTP method used in the request.
    var httpMethod: HTTPMethod { get }
    
    /// The headers to be included in the request.
    var headers: NetworkHeaders? { get }
    
    /// The query parameters to be included in the request.
    var queryParameters: NetworkQueryParameters? { get }
    
    /// The body data of the request.
    var body: Data? { get }
    
    /// The cache policy for the request.
    var cachePolicy: URLRequest.CachePolicy? { get }
    
    /// The timeout interval for the request.
    var timeoutInterval: TimeInterval? { get }
}

public extension NetworkEndpoint {
    /// The default URL scheme for the endpoint.
    var scheme: URLScheme { .https }
    
    /// The default headers for the endpoint.
    var headers: NetworkHeaders? { nil }
    
    /// The default query parameters for the endpoint.
    var queryParameters: NetworkQueryParameters? { nil }
    
    /// The default body data for the endpoint.
    var body: Data? { nil }
    
    /// The default cache policy for the endpoint.
    var cachePolicy: URLRequest.CachePolicy? { nil }
    
    /// The default timeout interval for the endpoint.
    var timeoutInterval: TimeInterval? { nil }
}
