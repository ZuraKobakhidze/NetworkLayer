/// An enumeration representing URL schemes.
///
/// This enum is used to specify the URL scheme for network requests.
/// Currently, it supports only the HTTPS scheme, but it can be extended to include other schemes if needed.
///
/// - Usage:
/// ```swift
/// let scheme: URLScheme = .https
/// let urlString = "\(scheme.rawValue)://www.example.com"
/// print(urlString) // "https://www.example.com"
/// ```
public enum URLScheme: String {
    /// The HTTPS URL scheme.
    case https
}
