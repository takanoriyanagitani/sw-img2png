import class CoreImage.CIImage
import struct Foundation.URL
import func FpUtil.Bind
import typealias FpUtil.IO
import func FpUtil.Lift
import func ImageToPng.GetEnvVarByKey
import func ImageToPng.ImageWriterNewDefault
import func ImageToPng.StrToUrl
import func ImageToPng.UrlToImg
import typealias ImageToPng.WriteImage

@main
struct ImgFileToPngFile {
  static func main() {
    let imgFilename: IO<String> = GetEnvVarByKey(key: "ENV_I_IMG_FILENAME")
    let imgUrl: IO<URL> = Bind(
      imgFilename,
      Lift(StrToUrl)
    )
    let img: IO<CIImage> = Bind(
      imgUrl,
      UrlToImg
    )

    let pngFilename: IO<String> = GetEnvVarByKey(key: "ENV_O_PNG_FILENAME")
    let pngUrl: IO<URL> = Bind(
      pngFilename,
      Lift(StrToUrl)
    )

    let iwtr: WriteImage = ImageWriterNewDefault()

    let img2png: IO<Void> = Bind(
      pngUrl,
      {
        let pu: URL = $0
        let wimg: (CIImage) -> IO<Void> = iwtr(pu)
        return Bind(
          img,
          wimg
        )
      }
    )

    let res: Result<Void, Error> = img2png()

    do {
      try res.get()
    } catch {
      print("unable to convert: \( error )")
    }
  }
}
