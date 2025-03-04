import class CoreFoundation.CFString
import class CoreGraphics.CGColorSpace
import class CoreImage.CIContext
import struct CoreImage.CIFormat
import class CoreImage.CIImage
import struct Foundation.URL
import func FpUtil.Err
import typealias FpUtil.IO

public struct PngWriteOption {
  public var fmt: CIFormat = .RGBA8
  public var color: CGColorSpace

  func img2png(
    ictx: CIContext,
    img: CIImage,
    to: URL
  ) -> Result<Void, Error> {
    return Result(catching: {
      try ictx.writePNGRepresentation(
        of: img,
        to: to,
        format: self.fmt,
        colorSpace: self.color
      )
    })
  }

  public func imageToPng(ictx: CIContext, img: CIImage, to: URL) -> IO<Void> {
    return {
      return Result(catching: {
        try ictx.writePNGRepresentation(
          of: img,
          to: to,
          format: self.fmt,
          colorSpace: self.color
        )
      })
    }
  }

  public static func newOptionDefaultFmt(color: CGColorSpace) -> Self {
    let me: Self = Self(color: color)
    return me
  }

  public static func newOptionDefaultFmt(colorName: CFString) -> Self? {
    let ocolor: CGColorSpace? = CGColorSpace(name: colorName)
    return ocolor.map {
      let color: CGColorSpace = $0
      return Self.newOptionDefaultFmt(color: color)
    }
  }

  public static func newOptionDefault() -> Self? {
    Self.newOptionDefaultFmt(colorName: CGColorSpace.sRGB)
  }
}

public typealias WriteImage = (URL) -> (CIImage) -> IO<Void>

public func ImageWriterNew(ictx: CIContext, opt: PngWriteOption) -> WriteImage {
  return {
    let url: URL = $0
    return {
      let img: CIImage = $0
      return opt.imageToPng(ictx: ictx, img: img, to: url)
    }
  }
}

func imageWriterNewDefault() -> WriteImage? {
  let ictx: CIContext = CIContext()
  let opw: PngWriteOption? = PngWriteOption.newOptionDefault()
  return opw.map {
    let pw: PngWriteOption = $0
    return ImageWriterNew(ictx: ictx, opt: pw)
  }
}

public func ImageWriterNew(_ owtr: WriteImage?) -> WriteImage {
  guard let wtr = owtr else {
    return {
      let _: URL = $0
      return {
        let _: CIImage = $0
        return Err(ImgToPngError.invalidArgument("invalid image writer"))
      }
    }
  }

  return {
    let u: URL = $0
    return wtr(u)
  }
}

public func ImageWriterNewDefault() -> WriteImage {
  let owtr: WriteImage? = imageWriterNewDefault()
  return ImageWriterNew(owtr)
}
