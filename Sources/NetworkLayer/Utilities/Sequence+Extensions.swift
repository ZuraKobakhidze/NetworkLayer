extension Sequence {
    /// Asynchronously transforms each element of the sequence using the given closure and returns an array of the transformed elements.
    ///
    /// This method applies the asynchronous `transform` closure to each element of the sequence and collects the results into an array.
    /// It runs the transformations sequentially, waiting for each one to complete before moving on to the next.
    ///
    /// - Parameter transform: An asynchronous closure that accepts an element of this sequence as its parameter and returns a transformed value of type `T`.
    /// - Returns: An array of transformed elements of type `T`.
    /// - Throws: Rethrows any error thrown by the `transform` closure.
    ///
    /// - Usage:
    /// ```swift
    /// let numbers = [1, 2, 3, 4, 5]
    /// let doubledNumbers = try await numbers.asyncMap { number in
    ///     return number * 2
    /// }
    /// print(doubledNumbers) // [2, 4, 6, 8, 10]
    /// ```
    ///
    /// - Note: This method processes the elements sequentially. For concurrent processing, consider using a different approach.
    func asyncMap<T>(_ transform: (Element) async throws -> T) async rethrows -> [T] {
        var results = [T]()
        for element in self {
            try await results.append(transform(element))
        }
        return results
    }
}
