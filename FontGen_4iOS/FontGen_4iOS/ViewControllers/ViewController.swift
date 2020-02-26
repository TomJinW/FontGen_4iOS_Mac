//
//  ViewController.swift
//  FontGen_4iOS
//
//  Created by Tom on 2020/2/26.
//  Copyright © 2020 Tom. All rights reserved.
//

import Cocoa
var fonts:[Font] = [Font]()
var globalURL:URL? = nil

class ViewController: NSViewController,NSTableViewDataSource,NSTableViewDelegate {
    

    
    @IBOutlet weak var tableView: NSTableView!
    @IBOutlet weak var txfL1: NSTextField!
    @IBOutlet weak var txfL2: NSTextField!
    @IBOutlet weak var txfL3: NSTextField!
    @IBOutlet weak var txfL4: NSTextField!
    @IBOutlet weak var progressBar: NSProgressIndicator!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fonts.reserveCapacity(20)
        tableView.registerForDraggedTypes([.fileURL])
        // Do any additional setup after loading the view.
        print(NSLocalizedString("1", comment: ""))
    }

    override func viewWillAppear() {
        super.viewWillAppear()
    }
    
    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }

    @IBAction func Gen1(_ sender: NSButton) {
        if tableView.selectedRow == -1 {return}
        let index = tableView.selectedRow
        let uid = UUID().uuidString
        fonts[index].fileName = fonts[index].fixedFileName
        txfL1.stringValue = fonts[index].fixedFileName
    }
    @IBAction func Gen2(_ sender: NSButton) {
        if tableView.selectedRow == -1 {return}
        let index = tableView.selectedRow
        let uid = UUID().uuidString
        fonts[index].profileUUID = uid
        txfL2.stringValue = uid
    }
    
    @IBAction func Gen3(_ sender: NSButton) {
        if tableView.selectedRow == -1 {return}
        let index = tableView.selectedRow
        let uid = UUID().uuidString
        fonts[index].fontPayloadUUID = uid
        txfL3.stringValue = uid
    }
    
    @IBAction func Gen4(_ sender: NSButton) {
        if tableView.selectedRow == -1 {return}
        let index = tableView.selectedRow
        let uid = UUID().uuidString
        fonts[index].profilePayloadUUID = uid
        txfL4.stringValue = uid
    }

    
    func numberOfRows(in tableView: NSTableView) -> Int {
        return (fonts.count)
    }
    
    func tableView(_ tableView: NSTableView, viewFor tableColumn: NSTableColumn?, row: Int) -> NSView? {
      let font = fonts[row]
      
      guard let cell = tableView.makeView(withIdentifier: tableColumn!.identifier, owner: self) as? NSTableCellView else { return nil }
        cell.textField?.stringValue = font.filePath
      
      return cell
    }
    
    @IBAction func addFont(_ sender: NSButton) {
        let dialog = NSOpenPanel();

        dialog.title                   = NSLocalizedString("ChooseFont", comment: "")
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = false
        dialog.canCreateDirectories    = true
        dialog.allowedFileTypes        = ["otf","ttf"]
        dialog.allowsMultipleSelection = true
        dialog.beginSheetModal(for: self.view.window!) { (response) in
            if (response == .OK) {
                for url in dialog.urls{
                    fonts.append(Font(path: (url.path)))
                }
                self.tableView.reloadData()
                self.tableView.selectRow(at: fonts.count-1)
            } else {
                return
            }
        }
    }
    
    @IBAction func remove(_ sender: NSButton) {
        if tableView.selectedRow == -1 {return}
        let index = tableView.selectedRow
        fonts.remove(at: index)
        tableView.reloadData()
        if (index == 0){
            tableView.selectRow(at: 0)
        }else{
            tableView.selectRow(at: index - 1)
        }
        if (fonts.count == 0){
            txfL1.stringValue.clear()
            txfL2.stringValue.clear()
            txfL3.stringValue.clear()
            txfL4.stringValue.clear()
        }
    }
    @IBAction func clearList(_ sender: NSButton) {
        fonts.removeAll()
        txfL1.stringValue.clear()
        txfL2.stringValue.clear()
        txfL3.stringValue.clear()
        txfL4.stringValue.clear()
        tableView.reloadData()
    }
    
    func tableViewSelectionDidChange(_ notification: Notification){
        if tableView.selectedRow == -1 {return}
        
        let index = tableView.selectedRow
        // Display Content
        txfL1.stringValue = fonts[index].fileName
        txfL2.stringValue = fonts[index].profileUUID
        txfL3.stringValue = fonts[index].fontPayloadUUID
        txfL4.stringValue = fonts[index].profilePayloadUUID
    }
    
    @IBAction func nameChanged(_ sender: NSTextField) {
        if tableView.selectedRow == -1 {return}
        let index = tableView.selectedRow
        fonts[index].fileName = txfL1.stringValue
    }

    @IBAction func L2Changed(_ sender: NSTextField) {
        if tableView.selectedRow == -1 {return}
        let index = tableView.selectedRow
        fonts[index].profileUUID = txfL2.stringValue
    }
    @IBAction func L3Changed(_ sender: NSTextField) {
        if tableView.selectedRow == -1 {return}
        let index = tableView.selectedRow
        fonts[index].fontPayloadUUID = txfL3.stringValue
    }
    @IBAction func L4Changed(_ sender: NSTextField) {
        if tableView.selectedRow == -1 {return}
        let index = tableView.selectedRow
        fonts[index].profilePayloadUUID = txfL4.stringValue
    }
    
    func tableView(
        _ tableView: NSTableView,validateDrop info: NSDraggingInfo,proposedRow row: Int,proposedDropOperation dropOperation: NSTableView.DropOperation)
        -> NSDragOperation
    {
        if dropOperation == .above {
            return .copy
        }
        return []
    }
    
    func tableView(
        _ tableView: NSTableView,
        acceptDrop info: NSDraggingInfo,
        row: Int,
        dropOperation: NSTableView.DropOperation)
        -> Bool
    {
        guard let items:[NSURL] = info.draggingPasteboard.readObjects(forClasses: [NSURL.self], options: nil) as? [NSURL]
            else { return false }
        
        var index = 0
        for item in items{
            guard let path = item.path else {continue}
            let endFix = String(path.split(separator: ".").last ?? "NONAME")
            if endFix.uppercased() == "OTF" || endFix.uppercased() == "TTF"{
                fonts.insert(Font(path: path), at: row+index)
                index += 1
            }
        }
        tableView.reloadData()
        tableView.selectRow(at: fonts.count-1)
        return true
    }
    @IBAction func Help(_ sender: NSButton) {
        let url = URL(fileURLWithPath: "https://github.com/TomJinW/FontGen_4iOS_Mac")
        NSWorkspace.shared.open(url)
    }
    
    @IBAction func saveFile(_ sender: NSButton) {
        if fonts.count == 0 {
            let alert = NSAlert()
            alert.messageText = NSLocalizedString("Attention", comment: "")
            alert.informativeText = NSLocalizedString("NoFontAdded", comment: "")
            alert.alertStyle = .informational
            alert.addButton(withTitle: "OK")
            alert.beginSheetModal(for: self.view.window!, completionHandler: nil)
            return
        }
        
        let dialog = NSOpenPanel();
        dialog.title                   = NSLocalizedString("ChooseDIR", comment: "")
        dialog.showsResizeIndicator    = true
        dialog.showsHiddenFiles        = false
        dialog.canChooseDirectories    = true
        dialog.canChooseFiles = false
        dialog.canCreateDirectories    = true
        dialog.allowsMultipleSelection = false
        
        dialog.beginSheetModal(for: self.view.window!) { (resoponse) in
            if (resoponse == .OK) {
                guard let url = dialog.url else {return}
                globalURL = url
                let controller = self.storyboard?.instantiateController(withIdentifier: "Progress") as! NSViewController
                let window = NSWindow(contentViewController: controller)
                self.view.window!.beginSheet(window) { (response) in
                    dialogOKCancel(window: self.view.window!, question: NSLocalizedString("Finished", comment: ""),
                                   text: NSLocalizedString("OpenFolder?", comment: "")) { (response) in
                        if response.rawValue == 1000{
                            NSWorkspace.shared.open(url)
                        }
                    }
                }
            } else {
                return
            }
        }
    }
}

extension String{
    mutating func clear(){
        self = ""
    }
}

extension NSTableView {
    func selectRow(at index: Int) {
        selectRowIndexes(.init(integer: index), byExtendingSelection: false)
        if let action = action {
            perform(action)
        }
    }
}


func dialogOKCancel(window:NSWindow,question: String, text: String,handler:@escaping ((NSApplication.ModalResponse )-> Void)) {
    let alert = NSAlert()
    alert.messageText = question
    alert.informativeText = text
    alert.alertStyle = .informational
    alert.addButton(withTitle: NSLocalizedString("OK", comment: ""))
    alert.addButton(withTitle: NSLocalizedString("Cancel", comment: ""))
    alert.beginSheetModal(for: window, completionHandler: handler)
//    return alert.runModal() == .alertFirstButtonReturn
}
