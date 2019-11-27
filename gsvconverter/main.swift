//
//  main.swift
//  gsvconverter
//
//  Created by bill donner on 11/26/19.
//  Copyright © 2019 bill donner. All rights reserved.
//

import Foundation
extension PlayData {
    
    static let sample = """
    {
                "title": "bleeblah",
                "subtitle": "blooblah",
                "author": ":billdonner",
                "headers": ["c1", "c2", "c3"],
                "data": [
                    ["r1c1", "r1c2"],
                    ["r2c1", "r2c2", "r2c3"]
                ]
            }
    """
    
    static func twowaytest() -> PlayData?{
        
        let  a = PlayData.decodeFromGSON(PlayData.sample)
        guard let stuff = a else { return nil }
        let csvString = stuff.encodeasGCSV()
        let  stuff2 = PlayData.decodeFromGCSV(csvString)
        let x1 = stuff2.encodeasGSON()
        guard let x2 = x1 else { return nil}
        let b = PlayData.decodeFromGSON(x2)
        guard let stuff3 = b else { return nil }
        let csvString3 = stuff3.encodeasGCSV()
        let stuff4 = PlayData.decodeFromGCSV(csvString3)
        if stuff == stuff4 {
            //print("you are a winner")
        } else {
            print("you are a loser")
            return nil
        }
        return stuff4
    }
    
    func test() {
        let start = Date()
        print(">>",separator:"",terminator:"")
        for _ in 1..<10000 {
            let _ = PlayData.twowaytest()!.encodeasGSON()!
        }
        let elapsed = Date().timeIntervalSince(start)*1000.0
        print ("elapsed: ",elapsed)
    }
    
}

struct PlayData:Codable, Equatable {
    
    let title: String
    let subtitle: String
    let author: String
    let headers: [String]
    let data: [[String]]
    
    func encodeasGCSV()->String {
        
        let colcount = headers.count
        var outbuf = ""
        
        func nl(_ s:String,tag:String) {
            outbuf += """
            "\(tag)","\(s)"
            """
            for _ in 2..<headers.count-1 {
                outbuf += ","
            }
            outbuf += "\n"
        }
        
        func dl(_ r:[String],tag:String) {
            outbuf += """
            "\(tag)",
            """
            for rr in r {
                outbuf += """
                "\(rr)",
                """
            }
            outbuf.removeLast()
            outbuf += "\n"
        }
        
        nl(title,tag:":title:")
        nl(subtitle,tag:":subtitle:")
        nl(author,tag:":author:")
        dl(headers,tag:":fields:")
        for (idx,onerow) in data.enumerated() {
            dl(onerow,tag: ":r\(idx+1):")
        }
        return outbuf
    }
    
    func encodeasGSON()->String? {
        let e = JSONEncoder()
        e.outputFormatting = [.withoutEscapingSlashes, .prettyPrinted]
        do {
            let x = try e.encode(self)
            return String(data: x, encoding:.utf8)!
        } catch {
            print("Cant encode as gson \(error)")
            return nil
        }
    }
    static func decodeFromGSON(_ s:String) -> PlayData? {
        // sample data
        let stringdata = s.data(using:.utf8)!
        // must decode correctly
        do {
            let t = try JSONDecoder().decode(PlayData.self,from:stringdata)
            let colcount = t.headers.count
            var rowcount = 0
            for onerow in t.data {
                if onerow.count == colcount {
                    rowcount += 1
                }
            }
            return (t)
        } catch {
            print("Cant decode as gson \(error)")
            return nil
        }
    }
    //MARK:- trivially inadequate csv parser
    static func decodeFromGCSV(_ s:String) -> PlayData
    {
        var title = ""
        var subtitle = ""
        var author = ""
        var headers : [String] = []
        var data : [[String]] = []
        let rows = s.components(separatedBy: "\n")
        var rownum = 0
        for row in rows {
            let fields = row.components(separatedBy: ",").map {
                $0.replacingOccurrences(of: "\"", with: "")
            }
            if fields.count > 1 {
                switch rownum {
                case 0: title = fields[1]
                case 1: subtitle = fields[1]
                case 2: author = fields [1]
                case 3:
                    headers = Array(fields.dropFirst())
                default:
                    data.append(Array(fields.dropFirst()))
                }
                rownum += 1
            }
        }
        return PlayData(title: title , subtitle: subtitle , author: author , headers: headers , data: data )
    }
}


func wf(_ u:String, url:URL, ext:String)   {
    let ourl = url.appendingPathExtension(ext)
    print("OUTPUT to \(ourl)")
    if verbose { print(u) }
    try! u.write(to: ourl, atomically: true, encoding: .utf8)
}
let verbose = false
guard CommandLine.arguments.count > 2
    else { print ("Usage : xxx infile outfile"); exit(0)}
let a = CommandLine.arguments[1]
let url = URL(string:a)!
let type = url.pathExtension

print("INPUT from \(url)")
do {
let contents = try String(contentsOf:url,encoding: .utf8)
    if verbose {print(contents)}


let b = CommandLine.arguments[2]
let ourl = URL(string:b)!
let start = Date()
    
switch type {
case "csv":
    let t = PlayData.decodeFromGCSV(contents)
    let u = t.encodeasGSON()!
    wf(u,url:ourl,ext:"json")
    
case "json":
    let t = PlayData.decodeFromGSON(contents)
    let u = t!.encodeasGCSV()
    wf(u,url:ourl,ext:"csv")
    
default : print("Cant handle files of type \(type)"); exit(0)
}
    
let elapsed = Date().timeIntervalSince(start) * 1000.0
print("Completed in \(elapsed)")
    
}
catch {
    print(error); //exit(0)
}

