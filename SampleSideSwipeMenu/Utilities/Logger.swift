//
//  Logger.swift
//  SampleSideSwipeMenu
//
//  Created by fjwrer on 2020/10/07.
//  Copyright © 2020 fjwrer_1004. All rights reserved.
//

import Foundation

/// ログ出力クラス
public class Logger {
    private static var enabled = false

    /// ログ出力先ファイルハンドル
    fileprivate static var fileHandle: FileHandle?

    public static func setup(logFilePath: String) {
        createFileIfNotExists(logFilePath)
        fileHandle = FileHandle(forWritingAtPath: logFilePath)
        enabled = true
    }

    /// ログ出力
    public static func log(_ message: String) {
        guard enabled else { return }

        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .medium
        let dateString = dateFormatter.string(from: Date())
        let logString = "[\(dateString)] \(message)"

        // Output to stdout
        print(logString)

        // Output to file
        if
            let fileHandle = Logger.fileHandle,
            let logData = "\(logString)\n".data(using: String.Encoding.utf8)
        {
            fileHandle.seekToEndOfFile()
            fileHandle.write(logData)
        }
    }

    fileprivate static func createFileIfNotExists(_ filePath: String) {
        let fileManager = FileManager.default
        if !fileManager.fileExists(atPath: filePath) {
            fileManager.createFile(atPath: filePath, contents: nil, attributes: nil)
        }
    }
}

private var todayString: String {
    let now = Date()
    let formatter = DateFormatter()
    formatter.dateFormat = "yyyy-MM-dd"
    formatter.locale = Locale(identifier: "en_US_POSIX")
    return formatter.string(from: now)
}
