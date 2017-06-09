//
// Created by Shane Whitehead on 8/6/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public protocol SIPReferral {
	var id: Int {get}
	var to: String {get}
	var from: String {get}
	var message: String {get}

	func accept() throws
	func reject() throws
}

class DefaultSIPReferral: DefaultSIPSupportManager, SIPReferral {
	let id: Int
	let to: String
	let from: String
	let message: String

	init(portSIPSDK: PortSIPSDK, id: Int, to: String, from: String, message: String) {
		self.id = id
		self.to = to
		self.from = from
		self.message = message
		super.init(portSIPSDK: portSIPSDK)
	}

	func accept() throws {
		let result = portSIPSDK.acceptRefer(id, referSignaling: message)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: Int32(result))
		}
	}

	func reject() throws {
		let result = portSIPSDK.rejectRefer(id)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}
}
