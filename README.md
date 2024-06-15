# Package Overview 

The *NetworkLayer* package provides a set of protocols and default implementations 
for handling network operations in Swift. It aims to simplify the process of making network requests, 
defining endpoints, handling authentication tokens, and decoding responses.

# Features

- Network Requests: Easily make asynchronous network requests using URLSession or a custom network session.
- Endpoint Definition: Define network endpoints with properties such as URL scheme, host, path, HTTP method, headers, query parameters, body, etc.
- Token Handling: Seamlessly handle authentication tokens with protocols for token providers and token management.
- Error Handling: Handle network errors with a predefined set of error types for common scenarios such as invalid URLs, client errors, server errors, empty responses, and decoding errors.
- Decoding Responses: Decode network responses into Swift types using Codable protocols.

# How to Use

- Import the Package: Import the *NetworkLayer* package into your Swift file.

import NetworkLayer

- Define Endpoints: Define your network endpoints by conforming to the NetworkEndpoint protocol. Specify properties such as scheme, host, path, method, headers, query parameters, etc.

struct MyEndpoint: NetworkEndpoint {
    let scheme: URLScheme = .https
    let host: String = "api.example.com"
    let urlPath: String = "/endpoint"
    let httpMethod: HTTPMethod = .get
}

- Create a Network Client: Create a network client instance by initializing DefaultNetworkClient with a network session and optional token providers.

let session = URLSession.shared
let networkClient = DefaultNetworkClient(session: session)

- Make Network Requests: Use the network client to make asynchronous network requests by calling the request method with your defined endpoint.

do {
    let response: MyResponseModel = try await networkClient.request(endpoint: MyEndpoint())
    // Process the response
} catch {
    print("Network request failed: \(error)")
}

- Handle Responses: Handle the response data in the completion block of the network request. You can decode the response data into Swift types using Codable protocols.

# Conclusion

The *NetworkLayer* package simplifies network operations in Swift 
by providing a set of protocols and default implementations for common tasks 
such as making network requests, defining endpoints, handling authentication tokens, 
and decoding responses. By following the outlined steps, 
you can easily integrate network functionality into your Swift projects.
