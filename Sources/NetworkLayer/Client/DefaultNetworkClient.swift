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
open class DefaultNetworkClient: NetworkClient {
    /// The network session used for making network requests.
    public let session: NetworkSession
    
    /// The list of network token providers for handling authentication tokens.
    public let networkTokenProviderList: [NetworkTokenProvider]
    
    /// Initializes a new `DefaultNetworkClient` instance.
    ///
    /// - Parameters:
    ///   - session: The `NetworkSession` instance to be used for network requests.
    ///   - networkTokenProviderList: The list of `NetworkTokenProvider` instances for handling authentication tokens.
    public init(session: NetworkSession, networkTokenProviderList: [NetworkTokenProvider] = []) {
        self.session = session
        self.networkTokenProviderList = networkTokenProviderList
    }
    
    open func request<T>(endpoint: NetworkEndpoint) async throws -> T where T : Decodable {
        var request = try buildNetworkRequest(from: endpoint)
        let networkTokenList = try await getNetworkTokenList()
        networkTokenList.forEach { request.setValue($0.value, forHTTPHeaderField: $0.httpHeaderField) }
        let (data, response) = try await session.dataTask(with: request)
        let httpURLResponse = try checkResponse(response: response)
        try checkStatusCode(for: httpURLResponse)
        return try decodeData(from: data)
    }
    
    /// Builds a URLRequest from the given NetworkEndpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The network endpoint.
    /// - Returns: A URLRequest instance.
    open func buildNetworkRequest(from endpoint: NetworkEndpoint) throws -> URLRequest {
        let urlComponents = buildURLComponents(from: endpoint)
        
        guard let url = urlComponents.url else {
            throw NetworkError.invalidURL("Invalid URL: \(urlComponents.description)")
        }
        
        return buildURLRequest(from: url, endpoint: endpoint)
    }
    
    /// Builds URLComponents from the given NetworkEndpoint.
    ///
    /// - Parameters:
    ///   - endpoint: The network endpoint.
    /// - Returns: A URLComponents instance.
    open func buildURLComponents(from endpoint: NetworkEndpoint) -> URLComponents {
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
    open func buildURLRequest(from url: URL, endpoint: NetworkEndpoint) -> URLRequest {
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
    open func getNetworkTokenList() async throws -> [NetworkToken] {
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
    open func checkResponse(response: URLResponse) throws -> HTTPURLResponse {
        guard let httpURLResponse = response as? HTTPURLResponse else {
            throw NetworkError.noResponse(nil)
        }
        return httpURLResponse
    }
    
    /// Checks if the HTTP status code in the given response is within the success range (200-299).
    ///
    /// - Parameters:
    ///   - response: The HTTPURLResponse.
    /// - Returns: A boolean indicating whether the status code is within the success range.
    /// - Throws: A NetworkError if the status code is outside the success range.
    @discardableResult open func checkStatusCode(for response: HTTPURLResponse) throws -> Bool {
        guard (200...299).contains(response.statusCode) else {
            throw NetworkError.generalError(statusCode: response.statusCode, nil)
        }
        return true
    }
    
    /// Decodes data into the specified type.
    ///
    /// - Parameters:
    ///   - data: The data to decode.
    /// - Returns: An instance of the specified type.
    /// - Throws: A NetworkError if decoding fails.
    open func decodeData<T>(from data: Data) throws -> T where T: Decodable {
        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError("Can't decode data", error: error)
        }
    }
}
