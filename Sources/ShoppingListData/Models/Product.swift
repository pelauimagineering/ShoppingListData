import Foundation

public struct Product: Codable {
  public var barcodeNumber: String? = nil
  public var title: String? = nil
  public var descrioption: String? = nil
  public var stores: [Store]? = [Store]()
}
