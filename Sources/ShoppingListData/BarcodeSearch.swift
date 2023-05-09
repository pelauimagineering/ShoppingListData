import Foundation
import os.log


typealias BarcodeSearchResult = Result<[Product], DataError>

public struct BarcodeSearch {
  /// API Key for the BarCodeLookup.com service
  private(set) var apiKey: String
  private(set) var urlTemplate: String
  
  public init() {
    self.apiKey = "r0ah81r986qqvy7uffzkxwbv8gig1b"
    self.urlTemplate = "https://api.barcodelookup.com/v3/products?barcode={BARCODE}&formatted=n&key={KEY}"
  }
  
  func doLookup(_ code: String) async -> BarcodeSearchResult {
    await withCheckedContinuation({ continuation in
      doLookup(code) { result in
        os_log("Barcode lookup has completed. Continue with the next step")
        continuation.resume(returning: result)
      }
    })
  }
  
  func doLookup(_ code: String, completion: @escaping (BarcodeSearchResult) -> Void) {
    let urlWithKey = urlTemplate.replacingOccurrences(of: "{KEY}", with: apiKey)
    let urlString = urlWithKey.replacingOccurrences(of: "{BARCODE}", with: code)
    guard let url = URL(string: urlString) else {
      os_log("Bad URL")
      completion(.failure(.URLFormat))
      return
    }
    
    Task {
      do {
        os_log("Fetch data using URLSession")
        let (data, _) = try await URLSession.shared.data(from: url)
        
        guard let lookupResult = try? JSONDecoder().decode(BarcodeLookupResult.self, from: data),
                                                           let allProducts = lookupResult.products else {
          os_log("No Products were parsed from the barcode lookup results")
          completion(.failure(.GeneralFailure))
          return
        }
        completion(.success(allProducts))
      } catch (let err) {
        os_log("Error: \(err.localizedDescription)")
        completion(.failure(.FetchError))
      }
    }
  }
}
