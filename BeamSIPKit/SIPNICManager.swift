//
// Created by Shane Whitehead on 9/3/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public protocol SIPNICManager {
	var count: Int32 {get}
	func localIPAddress(forNIC: Int32) -> String
}

class DefaultSIPNICManager: DefaultSIPSupportManager, SIPNICManager {

	var count: Int32 {
		return portSIPSDK.getNICNums()
	}

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}

	func localIPAddress(forNIC: Int32) -> String {
		return portSIPSDK.getLocalIpAddress(forNIC)
	}

}