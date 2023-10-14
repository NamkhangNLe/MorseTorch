//
//  ImagePicker.swift
//  MorseCode
//
//  Created by Joseph Masson on 10/13/23.
//

import Foundation
import SwiftUI
import UIKit

//@MainActor
//protocol UIImagePickerControllerDelegate

struct ImagePicker: UIViewControllerRepresentable {
    
    @Binding var selectedImage:UIImage
    @Environment(\.presentationMode) private var presentationMode
    var sourceType: UIImagePickerController.SourceType = .photoLibrary
    @Binding var videoSelected: Bool
    //var mediaTypes = [KuTTypeMovie as String]
    
    func makeUIViewController(context: UIViewControllerRepresentableContext<ImagePicker>) -> some UIViewController {
        
        let imagePicker = UIImagePickerController()
        imagePicker.allowsEditing = false
        imagePicker.sourceType = sourceType
        
        imagePicker.mediaTypes = ["public.movie"]
        imagePicker.delegate = context.coordinator
        return imagePicker
        

    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
    
    final class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        var parent: ImagePicker
         
        init ( parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
                parent.selectedImage = image
            }
            
            parent.presentationMode.wrappedValue.dismiss()
            parent.videoSelected = true
            
        }
    }
    
    func makeCoordinator() -> Coordinator {
        Coordinator(parent: self)
    }
}




