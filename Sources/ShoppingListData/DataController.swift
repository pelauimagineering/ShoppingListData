import CoreData
import SwiftUI
import UserNotifications
import os.log


public enum DataError: Error {
  case GeneralFailure, URLFormat, FetchError, UploadError
  case DataConversionFailed, NoSearchReults
}

protocol ProductLookupProtocol {
  func lookup(_ item: String)
//  func lookup(_ image: UIImage)
}
