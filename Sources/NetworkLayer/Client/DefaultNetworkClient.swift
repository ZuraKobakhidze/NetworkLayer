import Foundation

/// A default implementation of the `NetworkClient` protocol using URLSession.
///
/// This class provides a default implementation for making network requests using URLSession,
/// with support for handling authentication tokens and building network requests.
///
/// # Usage
///
/// ```swift
/// let session = URLSession.shared
/// let networkClient = DefaultNetworkClient(session: session)
/// let endpoint = MyNetworkEndpoint()
/// do {
///     let response: MyResponseModel = try await networkClient.request(endpoint: endpoint)
///     // Process the response
/// } catch {
///     print("Network request failed: \(error)")
/// }
/// ```
public final class DefaultNetworkClient: NetworkClient {
    public let session: NetworkSession
    
    public let networkTokenProviderList: [NetworkTokenProvider]
    
    public let networkLogger: NetworkLogger?
    
    public init(session: NetworkSession = DefaultNetworkSession(),
                networkTokenProviderList: [NetworkTokenProvider] = [],
                networkLogger: NetworkLogger? = DefaultNetworkLogger()) {
        self.session = session
        self.networkTokenProviderList = networkTokenProviderList
        self.networkLogger = networkLogger
    }
    
    public func request<T>(endpoint: NetworkEndpoint) async throws -> T where T : Decodable {
        var request = try buildNetworkRequest(from: endpoint)
        let networkTokenList = try await getNetworkTokenList()
        networkTokenList.forEach { request.setValue($0.value, forHTTPHeaderField: $0.httpHeaderField) }
        networkLogger?.logRequest(request)
        let (data, response) = try await session.dataTask(with: request)
        let httpURLResponse = try checkResponse(response: response)
        networkLogger?.logResponse(httpURLResponse, data: data)
        try checkStatusCode(for: httpURLResponse)
        return try decodeData(from: data)
    }
    
    /// Builds a URLRequest from the given NetworkEndpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The network endpoint.
    /// - Returns: A URLRequest instance.
    private func buildNetworkRequest(from endpoint: NetworkEndpoint) throws -> URLRequest {
        let urlComponents = buildURLComponents(from: endpoint)
        
        guard let url = urlComponents.url else {
            let error = NetworkError.invalidURL("Invalid URL: \(urlComponents.description)")
            networkLogger?.logRequestError(error)
            throw error
        }
        
        return buildURLRequest(from: url, endpoint: endpoint)
    }
    
    /// Builds URLComponents from the given NetworkEndpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The network endpoint.
    /// - Returns: A URLComponents instance.
    private func buildURLComponents(from endpoint: NetworkEndpoint) -> URLComponents {
        var urlComponents = URLComponents()
        urlComponents.scheme = endpoint.scheme.rawValue
        urlComponents.host = endpoint.host
        urlComponents.path = endpoint.urlPath
        urlComponents.queryItems = endpoint.queryParameters?.parameters
        return urlComponents
    }
    
    /// Builds a URLRequest from a URL and NetworkEndpoint.
    ///
    /// - Parameters:
    ///   - url: The URL.
    ///   - endpoint: The network endpoint.
    /// - Returns: A URLRequest instance.
    private func buildURLRequest(from url: URL, endpoint: NetworkEndpoint) -> URLRequest {
        var request = URLRequest(url: url)
        request.httpMethod = endpoint.httpMethod.rawValue
        request.allHTTPHeaderFields = endpoint.headers
        request.httpBody = endpoint.body
        endpoint.cachePolicy.map { request.cachePolicy = $0 }
        endpoint.timeoutInterval.map { request.timeoutInterval = $0 }
        return request
    }
    
    /// Retrieves a list of network tokens asynchronously from the provided token providers.
    ///
    /// - Returns: An array of network tokens.
    /// - Throws: An error if retrieving the tokens fails.
    private func getNetworkTokenList() async throws -> [NetworkToken] {
        try await networkTokenProviderList
            .asyncMap {
                try await $0.getToken()
            }
    }
    
    /// Checks if the given response is an HTTPURLResponse.
    ///
    /// - Parameters:
    ///   - response: The URLResponse to check.
    /// - Returns: An HTTPURLResponse instance.
    /// - Throws: A NetworkError if the response is not an HTTPURLResponse.
    private func checkResponse(response: URLResponse) throws -> HTTPURLResponse {
        guard let httpURLResponse = response as? HTTPURLResponse else {
            let error = NetworkError.noResponse(nil)
            networkLogger?.logResponseError(error)
            throw error
        }
        return httpURLResponse
    }
    
    /// Checks if the HTTP status code in the given response is within the success range (200-299).
    ///
    /// - Parameters:
    ///   - response: The HTTPURLResponse.
    /// - Returns: A boolean indicating whether the status code is within the success range.
    /// - Throws: A NetworkError if the status code is outside the success range.
    @discardableResult private func checkStatusCode(for response: HTTPURLResponse) throws -> Bool {
        guard (200...299).contains(response.statusCode) else {
            let error = NetworkError.generalError(statusCode: response.statusCode, nil)
            networkLogger?.logResponseError(error)
            throw error
        }
        return true
    }
    
    /// Decodes data into the specified type.
    ///
    /// - Parameters:
    ///   - data: The data to decode.
    /// - Returns: An instance of the specified type.
    /// - Throws: A NetworkError if decoding fails.
    private func decodeData<T>(from data: Data) throws -> T where T: Decodable {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            let error = NetworkError.decodingError("Can't decode data", error: error)
            networkLogger?.logResponseError(error)
            throw error
        }
    }
}
