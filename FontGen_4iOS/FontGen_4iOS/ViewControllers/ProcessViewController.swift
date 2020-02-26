//
//  ProcessViewController.swift
//  FontGen_4iOS
//
//  Created by Tom on 2020/2/26.
//  Copyright © 2020 Tom. All rights reserved.
//

import Cocoa

class ProcessViewController: NSViewController {

    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do view setup here.
    }
    
    override func viewDidAppear() {
        super.viewDidAppear()
        
        guard let url = globalURL else{
            return
        }
        
        DispatchQueue.global().async {
            var i = 0
            for font in fonts{
                generateConfigFromFont(font: font, outputPath: url.path)
                i += 1
                DispatchQueue.main.async {
                    self.progressBar.doubleValue = Double((i*100)/fonts.count)
                }
            }
            DispatchQueue.main.async {
                self.view.window!.sheetParent!.endSheet(self.view.window!, returnCode: .OK)
                self.view.window!.close()
            }
        }
    }
    
    override func viewWillDisappear() {

    }
}
