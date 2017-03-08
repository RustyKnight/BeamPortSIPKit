//
// Created by Shane Whitehead on 9/3/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public enum SIPSessionStatus {
	case none
	case outgoingInvite
	case incomingInvite
	case outgoingActive
	case incomingActive
}

public protocol SIPSessionManager {

	var isSpeakerOn: Bool { get set }
	var isKeepAwake: Bool { get set }
	var isMicroPhoneMuted: Bool { get set }
	var isSpeakerMuted: Bool { get set }

	func makeCall(to number: String, sendSDP: Bool) -> SIPSession

	func answer(call: SIPSession)
	func reject(call: SIPSession)
	func end(call: SIPSession)

//	var sessionStatus: SIPSessionStatus { get }

	func session(byID: Int) -> SIPSession?
	var sessionCount: Int { get }
	var sessions: [SIPSession] { get }

	func send(_ tone: DTMFTone, to session: SIPSession)

}

class DefaultSIPSessionManager: DefaultSIPSupportManager, SIPSessionManager {

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}


	var isSpeakerOn: Bool = false {
		didSet {
			if portSIPSDK.setLoudspeakerStatus(isSpeakerOn) != 0 && isSpeakerOn {
				isSpeakerOn = false
			}
		}
	}

	var isKeepAwake: Bool = false {
		didSet {
			if isKeepAwake {
				isKeepAwake = portSIPSDK.startKeepAwake()
			} else {
				portSIPSDK.stopKeepAwake()
			}
		}
	}

	var isMicroPhoneMuted: Bool = false {
		didSet {
			portSIPSDK.muteMicrophone(isMicroPhoneMuted)
		}
	}
	var isSpeakerMuted: Bool = false {
		didSet {
			portSIPSDK.muteSpeaker(isSpeakerMuted)
		}
	}

	func makeCall(to number: String, sendSDP: Bool) -> SIPSession {
		fatalError("Not yet implemented")
	}

	func answer(call: SIPSession) {
	}

	func reject(call: SIPSession) {
	}

	func end(call: SIPSession) {
	}

	func session(byID: Int) -> SIPSession? {
		return nil
	}

	var sessionCount: Int {
		return 0
	}

	var sessions: [SIPSession] {
		return []
	}

	func send(_ tone: DTMFTone, to session: SIPSession) {
	}

}