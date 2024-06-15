import Foundation

/// An enumeration representing network-related errors.
///
/// This enum defines various types of errors that can occur during network operations,
/// such as invalid URLs, client-side errors, server errors, empty responses, and decoding errors.
///
/// - Usage:
/// ```swift
/// do {
///     // Perform network operation
/// } catch NetworkError.invalidURL(let message) {
///     print("Invalid URL: \(message ?? "")")
/// } catch NetworkError.clientError(let message, let error) {
///     print("Client Error: \(message ?? ""), \(error)")
/// } catch NetworkError.noResponse(let message) {
///     print("No Response: \(message ?? "")")
/// } catch NetworkError.generalError(let statusCode, let message) {
///     print("General Error: Status Code \(statusCode), \(message ?? "")")
/// } catch NetworkError.emptyData(let message) {
///     print("Empty Data: \(message ?? "")")
/// } catch NetworkError.decodingError(let message, let error) {
///     print("Decoding Error: \(message ?? ""), \(error)")
/// } catch {
///     print("Unknown Error: \(error)")
/// }
/// ```
public enum NetworkError: Error {
    /// An error indicating an invalid URL.
    ///
    /// This error occurs when attempting to create a URL from an invalid string.
    case invalidURL(_ message: String?)
    
    /// An error indicating a client-side error.
    ///
    /// This error typically occurs when the client's request is malformed or invalid.
    case clientError(_ message: String?, error: Error)
    
    /// An error indicating no response from the server.
    ///
    /// This error occurs when the server fails to provide a response.
    case noResponse(_ message: String?)
    
    /// An error indicating a general server error.
    ///
    /// This error represents a server error with a specific status code and an optional message.
    case generalError(statusCode: Int, _ message: String?)
    
    /// An error indicating empty response data.
    ///
    /// This error occurs when the response data from the server is empty.
    case emptyData(_ message: String?)
    
    /// An error indicating a decoding failure.
    ///
    /// This error occurs when decoding the response data fails.
    case decodingError(_ message: String?, error: Error)
}
