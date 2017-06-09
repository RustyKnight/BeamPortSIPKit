//
// Created by Shane Whitehead on 9/6/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public protocol HeaderExtensionManager {

	func value(named: String, from sipMessage: String) -> String?
	func add(named: String, with value: String) throws
	func clear() throws

}

public protocol HeaderManager {

	//modifyHeaderValue
	func modify(named: String, with value: String) throws
	//clearModifyHeaders
	func clear() throws

}

class DefaultHeaderExtensionManager: DefaultSIPSupportManager, HeaderExtensionManager {

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}

	func value(named: String, from sipMessage: String) -> String? {
		return portSIPSDK.getExtensionHeaderValue(sipMessage, headerName: named)
	}

	func add(named: String, with value: String) throws {
		let result = portSIPSDK.addExtensionHeader(named, headerValue: value)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func clear() throws {
		let result = portSIPSDK.clearAddExtensionHeaders()
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}
}

class DefaultHeaderManager: DefaultSIPSupportManager, HeaderManager {

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}

	func modify(named: String, with value: String) throws {
		let result = portSIPSDK.modifyHeaderValue(named, headerValue: value)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func clear() throws {
		let result = portSIPSDK.clearModifyHeaders()
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}
}
