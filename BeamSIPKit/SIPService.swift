//
//  SIPService.swift
//  BeamSIPKit
//
//  Created by Shane Whitehead on 1/03/2017.
//  Copyright © 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

//#import <PortSIPLib/PortSIPErrors.hxx>
//#import <PortSIPLib/PortSIPEventDelegate.h>
//#import <PortSIPLib/PortSIPSDK.h>
//#import <PortSIPLib/PortSIPTypes.hxx>
//#import <PortSIPLib/PortSIPVideoRenderView.h>

struct SIPNotification {

	struct Call {
		// When the call is coming, this event will be triggered.
		public static let incoming = Notification.Name("SIP.call.incoming")
		// If the outgoing call is being processed, this event will be triggered.
		public static let outgoing = Notification.Name("SIP.call.outgoing")
		// Once the caller received the "183 session in progress" message, this event will be triggered.
		public static let progress = Notification.Name("SIP.call.progress")
		// If the outgoing call is ringing, this event will be triggered.
		public static let outgoingRinging = Notification.Name("SIP.call.outgoingRinging")
		// If the remote party is answering the call, this event will be triggered.
		public static let answered = Notification.Name("SIP.call.answered")
		// If the outgoing call fails, this event will be triggered.
		public static let failed = Notification.Name("SIP.call.failed")
		// This event will be triggered when remote party updates this call.
		public static let updated = Notification.Name("SIP.call.updated")
		// This event will be triggered when UAC sent/UAS receives ACK (the call is connected).
		// Some functions (hold, updateCall etc...) can be called only after the call is connected,
		// otherwise it will return error.
		public static let connected = Notification.Name("SIP.call.connected")
		// If the enableCallForward method is called and a call is incoming, the call will be forwarded
		// automatically and this event will be triggered.
		public static let beginningForward = Notification.Name("SIP.call.beginningForward")
		// This event will be triggered once remote side closes the call.
		public static let closed = Notification.Name("SIP.call.closed")
		// If the remote side has placed the call on hold, this event will be triggered.
		public static let remoteHold = Notification.Name("SIP.call.hold")
		// If the remote side un-holds the call, this event will be triggered.
		public static let remoteUnHold = Notification.Name("SIP.call.unhold")
	}

	struct Register {
		public static let success = Notification.Name("SIP.register.success")
		public static let failure = Notification.Name("SIP.register.failure")
	}

}


public enum SIPResponseCode {
	
	public enum Success: Int {
		case ok = 200
		case accepted = 202
		case noNotification = 203
	}
	
	public enum Redirection: Int {
		case multipleChoices = 300
		case movedPermanently
		case movedTemporarily
		case useProxy = 305
		case alternativeService = 380
	}
	
	public enum ClientFailure: Int {
		case badRequest = 400
		case unauthorized
		case paymentRequired
		case forbidden
		case notFound
		case methodNotFound
		case notAcceptable
		case proxyAuthenticationRequired
		case requestTimeout
		case conflict
		case gone
		case lengthRequired
		case conditionalRequestFailed
		case requestEntityTooLarge
		case requestURITooLong
		case unsupportedMediaType
		case unsupportedURIScheme
		case unknownResourcePriority
		case badExtension = 420
		case extensionRequired
		case sessionIntervalTooSmall
		case intervalTooBrief
		case badLocationInformation
		case useIdentityHeader
		case provideReferrerIdentity
		case flowFailed
		case anonymityDisallowed = 433
		case badIdentityInfo = 436
		case unsupportedCertificate
		case invalidIdentityHeader
		case firstHopLacksOutboundSupport
		case consentNeeded = 470
		case temporarilyUnavailable = 480
		case callOrTransactionDoesNotExist
		case loopDetected
		case tooManyHops
		case addressIncomplete
		case ambiguous
		case busyHere
		case requestTerminated
		case notAcceptableHere
		case badEvent
		case requestPending = 491
		case undecipherable = 493
		case securityAgreementRequired = 494
	}
	
	public enum ServerFailure: Int {
		case internalError = 500
		case notImplemented
		case BadGateway
		case serviceUnavailable
		case serverTimeout
		case versionNotSupported
		
		case messageTooLarge = 513
		case preconditionFailure = 580
	}
	
	public enum GloablFailure: Int {
		case busyEverywhere = 600
		case decline = 603
		case doesNotExistAnywhere
		case notAcceptable = 606
	}
	
}

public protocol SIPSession {
	var timeOfCall: Date { get }
	var durationOfCall: TimeInterval { get }
	var number: String { get }
	var id: Int { get }
	
	func answer()
	
	func reject()
	
	func end()
	
	var isOnHold: Bool { get set }
	
	func reject(withReason code: SIPResponseCode.ClientFailure)
	
	func rejectWithBusyHere()
	
	func rejectWithUnavailable()
}

public protocol SIPServiceCredentials {
	var userName: String { get }
	var password: String { get }
	var authName: String { get }
	var displayName: String { get }
}

public protocol SIPServiceConfiguration {
	
	var host: String { get }
	var port: Int { get }
	var credentials: SIPServiceCredentials { get }
	var licenseKey: String { get }
	
}

public struct DefaultSIPServiceCredentials: SIPServiceCredentials {
	public let userName: String
	public let password: String
	public let authName: String
	public let displayName: String
}

public struct DefaultSIPServiceConfiguration: SIPServiceConfiguration {
	public let host: String
	public let port: Int
	public let credentials: SIPServiceCredentials
	public let licenseKey: String
}

public enum DTMFTone: Int {
	case number0 = 0
	case number1
	case number2
	case number3
	case number4
	case number5
	case number6
	case number7
	case number8
	case number9
	case star
	case hash
	case toneA
	case toneB
	case toneC
	case toneD
	case flash
}

public enum SIPSessionStatus {
	case none
	case outgoingInvite
	case incomingInvite
	case outgoingActive
	case incomingActive
}

public enum SIPServiceStatus {
	case disconnected
	case connecting
	case connected
	case disconnecting
}

public protocol SIPService {
	
	func initialise(with: SIPServiceConfiguration)
	
	func deinitialise()
	
	func makeCall(to number: String, sendSDP: Bool) -> SIPSession
	
	var isConnected: Bool { get set }
	
	var isSpeakerOn: Bool { get set }
	var isKeepAwake: Bool { get set }
	var isMicroPhoneMuted: Bool { get set }
	var isSpeakerMuted: Bool { get set }
	
	func answer(call: SIPSession)
	
	func reject(call: SIPSession)
	
	func end(call: SIPSession)
	
	var status: SIPServiceStatus { get }
	var sessionStatus: SIPSessionStatus { get }
	
	func session(byID: Int) -> SIPSession?
	var sessionCount: Int { get }
	var sessions: [SIPSession] { get }
	
	func send(_ tone: DTMFTone, to session: SIPSession)
	
}

public struct SIPServiceManager {
	public static let shared: SIPService = MutableSIPServiceManager.shared
}

public struct MutableSIPServiceManager {
	public static var shared: SIPService = DefaultSIPService()
}

class DefaultSIPService: SIPService {
	
	func initialise(with: SIPServiceConfiguration) {
	}
	
	func deinitialise() {
	}
	
	func makeCall(to number: String, sendSDP: Bool) -> SIPSession {
		fatalError("Not yet implemented")
	}
	
	var isConnected: Bool = false
	var isSpeakerOn: Bool = false
	var isKeepAwake: Bool = false
	var isMicroPhoneMuted: Bool = false
	var isSpeakerMuted: Bool = false
	
	var status: SIPServiceStatus = .disconnected
	var sessionStatus: SIPSessionStatus = .none
	var sessionCount: Int {
		return sessions.count
	}
	var sessions: [SIPSession] = []
	
	func answer(call: SIPSession) {
	}
	
	func reject(call: SIPSession) {
	}
	
	func end(call: SIPSession) {
	}
	
	func session(byID: Int) -> SIPSession? {
		return nil
	}
	
	func send(_ tone: DTMFTone, to session: SIPSession) {
	}
	
}
