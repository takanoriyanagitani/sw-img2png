import CoreImage.CIImage

import class Foundation.ProcessInfo
import struct Foundation.URL
import func FpUtil.Bind
import typealias FpUtil.IO
import func FpUtil.Lift

public enum ImgToPngError: Error {
  case invalidUrl(String)
  case invalidArgument(String)
  case unimplemented
}

// Creates an URL of the specified file path string.
public func StrToUrl(_ s: String) -> Result<URL, Error> {
  let u: URL = URL(fileURLWithPath: s)
  return .success(u)
}

public typealias UrlToImage = (URL) -> IO<CIImage>

func urlToImg(_ u: URL) -> Result<CIImage, Error> {
  guard let img = CIImage(contentsOf: u) else {
    return .failure(ImgToPngError.invalidUrl("unable to load: \( u )"))
  }

  return .success(img)
}

public func UrlToImg(_ u: URL) -> IO<CIImage> {
  return Lift(urlToImg)(u)
}

func getEnvVarByKey(_ key: String) -> Result<String, Error> {
  let ostr: String? = ProcessInfo.processInfo.environment[key]
  guard let val = ostr else {
    return .failure(
      ImgToPngError.invalidArgument("env var \( key ) missing")
    )
  }

  return .success(val)
}

public func GetEnvVarByKey(key: String) -> IO<String> {
  return Lift(getEnvVarByKey)(key)
}
