//
//  UIImageExt.swift
//  PathwaysWidgetExtension
//
//  Created by Francisco Mestizo on 12/12/24.
//

import Foundation
import UIKit

extension UIImage {
    func imageWith(newSize: CGSize) -> UIImage {
            let image = UIGraphicsImageRenderer(size: newSize).image { _ in
                draw(in: CGRect(origin: .zero, size: newSize))
            }
            
            return image.withRenderingMode(renderingMode)
        }
    
    func scalePreservingAspectRatio(targetSize: CGSize) -> UIImage {
        // Determine the scale factor that preserves aspect ratio
        let widthRatio = targetSize.width / size.width
        let heightRatio = targetSize.height / size.height
        
        let scaleFactor = min(widthRatio, heightRatio)
        
        // Compute the new image size that preserves aspect ratio
        let scaledImageSize = CGSize(
            width: size.width * scaleFactor,
            height: size.height * scaleFactor
        )

        // Draw and return the resized UIImage
        let renderer = UIGraphicsImageRenderer(
            size: scaledImageSize
        )

        let scaledImage = renderer.image { _ in
            self.draw(in: CGRect(
                origin: .zero,
                size: scaledImageSize
            ))
        }
        
        return scaledImage
    }
    
//    static func resizeImageData(imageData: Data, targetSize: CGSize) -> Data? {
//            guard let image = UIImage(data: imageData) else { return nil }
//            
//            // Create a scaled image
//            let scaledImage = image.scalePreservingAspectRatio(targetSize: targetSize)
//            
//            // Convert the scaled image back to Data
//            return scaledImage.pngData() // or .jpegData(compressionQuality: 0.8) if you prefer JPEG
//        }
}

//extension UIImage {
//    /// Resizes image data to a target size and compresses it.
//    static func resizeImageData(imageData: Data, targetSize: CGSize) -> Data? {
//        guard let image = UIImage(data: imageData) else { return nil }
//
//        let renderer = UIGraphicsImageRenderer(size: targetSize)
//        let resizedImage = renderer.image { _ in
//            image.draw(in: CGRect(origin: .zero, size: targetSize))
//        }
//
//        return resizedImage.jpegData(compressionQuality: 0.9)
//    }
//}

extension UIImage {
    /// Resizes image data while maintaining aspect ratio.
    static func resizeImageData(imageData: Data, targetLongSide: CGFloat) -> Data? {
        guard let image = UIImage(data: imageData) else { return nil }

        let aspectRatio = image.size.width / image.size.height

        let newSize: CGSize
        if image.size.width > image.size.height {
            // Landscape or square
            newSize = CGSize(width: targetLongSide, height: targetLongSide / aspectRatio)
        } else {
            // Portrait
            newSize = CGSize(width: targetLongSide * aspectRatio, height: targetLongSide)
        }

        let renderer = UIGraphicsImageRenderer(size: newSize)
        let resizedImage = renderer.image { _ in
            image.draw(in: CGRect(origin: .zero, size: newSize))
        }

        return resizedImage.jpegData(compressionQuality: 1)
    }
}
