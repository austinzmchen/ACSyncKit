# ACSyncKit

[![CI Status](http://img.shields.io/travis/austinzmchen/ACSyncKit.svg?style=flat)](https://travis-ci.org/austinzmchen/ACSyncKit)
[![Version](https://img.shields.io/cocoapods/v/ACSyncKit.svg?style=flat)](http://cocoapods.org/pods/ACSyncKit)
[![License](https://img.shields.io/cocoapods/l/ACSyncKit.svg?style=flat)](http://cocoapods.org/pods/ACSyncKit)
[![Platform](https://img.shields.io/cocoapods/p/ACSyncKit.svg?style=flat)](http://cocoapods.org/pods/ACSyncKit)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

## Installation

ACSyncKit is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'ACSyncKit'
```

## Tech Notes

Json Model

```
import Foundation
import ObjectMapper
import AlamofireObjectMapper

open class ACJsonReplaceMe: ACSyncableJsonRecord {
    var name: String?
    var desc: String?
    var isAutoGen: Bool?
    var itemsType: String?
    
    override open func mapping(map: Map) {
        super.mapping(map: map)
        
        name <- map["Name"]
        desc <- map["Desc"]
        isAutoGen <- map["IsAutoGen"]
        itemsType <- map["ItemsType"]
    }
}

```

```
protocol ACReplaceMeProcessorType: ACSyncableProcessorType {}

@objc class ACReplaceMeProcessor: NSObject, ACReplaceMeProcessorType {
    
    let syncContext: ACSyncContext
    required init (context: ACSyncContext) {
        self.syncContext = context
    }
    
    func sync(_ completion: @escaping (_ success: Bool, _ syncedObjects: [AnyObject]?, _ error: Error?) -> ()) {}
}

fileprivate let kRemoteFetchSizeDefault: Int = 16
```


## Author

austinzmchen, austin@accodeworks.com

## License

ACSyncKit is available under the MIT license. See the LICENSE file for more info.
