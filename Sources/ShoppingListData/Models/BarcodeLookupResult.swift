import Foundation

public struct BarcodeLookupResult: Codable {
  public var products: [Product]? = [Product]()
  
  enum CodingKeys: String, CodingKey {
    case products = "products"
  }
  
  public init(from decoder: Decoder) throws {
    let values = try decoder.container(keyedBy: CodingKeys.self)
    products = try values.decodeIfPresent([Product].self, forKey: .products)
  }
  
  init() {}
  
}
