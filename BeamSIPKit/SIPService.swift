//
//  SIPService.swift
//  BeamSIPKit
//
//  Created by Shane Whitehead on 1/03/2017.
//  Copyright © 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

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
	
	struct Refer {
		public static let received = Notification.Name("SIP.refer.received")
		public static let accepted = Notification.Name("SIP.refer.accepted")
		public static let rejected = Notification.Name("SIP.refer.rejected")
		public static let transferTrying = Notification.Name("SIP.refer.transferTrying")
		public static let transferRinging = Notification.Name("SIP.refer.transferRinging")
		public static let success = Notification.Name("SIP.refer.success")
		public static let failure = Notification.Name("SIP.refer.failure")
	}
	
	// Messaging?
	
	struct Signaling {
		public static let received = Notification.Name("SIP.signaling.received")
		public static let sending = Notification.Name("SIP.signaling.sending")
	}
	
	// MWI
	
	struct MessageWaitingIndicator {
		public static let voiceMessage = Notification.Name("SIP.mwi.voice")
		public static let faxMessage = Notification.Name("SIP.mwi.fax")
	}
	
	struct DTMF {
		public static let received = Notification.Name("SIP.dtmf.received")
	}
	
	struct Info {
		public static let received = Notification.Name("SIP.info.received")
	}
	
	struct Options {
		public static let received = Notification.Name("SIP.options.received")
	}
	
	struct Presence {
		public static let receivedSubscription = Notification.Name("SIP.presence.receivedSubscription")
		public static let online = Notification.Name("SIP.presence.online")
		public static let offline = Notification.Name("SIP.presence.offline")
	}
	
	struct Message {
		public static let received = Notification.Name("SIP.message.received")
		public static let receivedOutOfDialog = Notification.Name("SIP.message.receivedOutOfDialog")
		public static let sendSuccessful = Notification.Name("SIP.message.sendSuccessful")
		public static let sendFailure = Notification.Name("SIP.message.sendFailure")
		public static let sendOutOfDialogSuccess = Notification.Name("SIP.message.sendOutOfDialogSuccess")
		public static let sendOutOfDialogFailure = Notification.Name("SIP.message.sendOutOfDialogFailure")
	}
	
	struct Play {
		public static let audioFileFinished = Notification.Name("SIP.play.audioFileFinished")
		public static let videoFileFinished = Notification.Name("SIP.play.videoFileFinished")
	}
	
	struct RTP {
		public static let received = Notification.Name("SIP.rtp.audioFileFinished")
		public static let sending = Notification.Name("SIP.rtp.videoFileFinished")
	}
	
	struct Stream {
		public static let audio = Notification.Name("SIP.stream.audio")
		public static let video = Notification.Name("SIP.stream.video")
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

public enum SIPTransportProtocol: Int {
	case udp = 0
	case tls
	case tcp
	case pers
	
	var type: TRANSPORT_TYPE {
		switch self {
			case .udp: return TRANSPORT_UDP
			case .tls: return TRANSPORT_TLS
			case .tcp: return TRANSPORT_TCP
			case .pers: return TRANSPORT_PERS
		}
	}
}

public enum SIPLogLevel: Int {
	case none = -1
	case error = 1
	case warning
	case info
	case debug
	case cout
	
	var type: PORTSIP_LOG_LEVEL {
		switch self {
			case .none: return PORTSIP_LOG_NONE
			case .error: return PORTSIP_LOG_ERROR
			case .warning: return PORTSIP_LOG_WARNING
			case .info: return PORTSIP_LOG_INFO
			case .debug: return PORTSIP_LOG_DEBUG
			case .cout: return PORTSIP_LOG_COUT
		}
	}
}

public enum SIPDeviceLayer: Int32 {
	case os = 0
	case virtual
}

public enum SIPSRTP: Int32 {
	case none = 0
	case force
	case prefer
	
	var type: SRTP_POLICY {
		switch self {
			case .none: return SRTP_POLICY_NONE
			case .force: return SRTP_POLICY_FORCE
			case .prefer: return SRTP_POLICY_PREFER
		}
	}
}

public protocol SIPServiceConfiguration {
	var transportProtocol: SIPTransportProtocol { get }
	var logLevel: SIPLogLevel { get }
	var logFilePath: String { get }
	var maxCallLines: Int32 { get }
	var sipAgent: String { get }
	var audioDeviceLayer: SIPDeviceLayer { get }
	var videoDeviceLayer: SIPDeviceLayer { get }
	var srtp: SIPSRTP { get }
	var licenseKey: String { get }
}

public protocol SIPServiceCredentials {
	var userName: String { get }
	var password: String { get }
	var authName: String { get }
	var displayName: String { get }
}

public protocol SIPServiceAccountConfiguration {
	
	var host: String { get }
	var port: Int32 { get }
	var credentials: SIPServiceCredentials { get }
	
	var localIPAddress: String {get}
	var localPort: Int32 {get}
	
	var userDomain: String {get}
	
	var stunServer: String {get}
	var stunServerPort: Int32 {get}
	
	var outboundServer: String {get}
	var outboundServerPort: Int32 {get}
}

public struct DefaultSIPServiceCredentials: SIPServiceCredentials {
	public let userName: String
	public let password: String
	public let authName: String
	public let displayName: String
}

public struct DefaultSIPServiceConfiguration: SIPServiceAccountConfiguration {
	public let host: String
	public let port: Int32
	public let credentials: SIPServiceCredentials
	public let licenseKey: String
	
	public let localIPAddress: String
	public let localPort: Int32
	public let userDomain: Strin
	public let stunServer: String
	public let stunServerPort: Int32
	public let outboundServer: String
	public let outboundServerPort: Int32
	
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
	
	func initialise(withConfiguration config: SIPServiceConfiguration) throws
	
	func deinitialise()
	
	func authenticate(_ account: SIPServiceAccountConfiguration)
	
	var isInitialised: Bool { get }
	
	func register(expires: Int, retries: Int) throws
	
	func unregister() throws
	
	var refreshInterval: Int { get set }
	var isRegistered: Bool { get }
	
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

public enum SIPError: Error {
	case initializationError(code: Int32)
}

class DefaultSIPService: SIPService {
	
	var portSIP: PortSIPSDK
	
	init() {
		portSIP = PortSIPSDK()
	}
	
	private(set) var isInitialised: Bool = false
	
	func initialise(withConfiguration config: SIPServiceConfiguration) throws {
		guard !isInitialised else {
			return
		}
		
		var ret = portSIP.initialize(
				config.transportProtocol.type,
				loglevel: config.logLevel.type,
				logPath: config.logFilePath,
				maxLine: config.maxCallLines,
				agent: config.sipAgent,
				audioDeviceLayer: config.audioDeviceLayer.rawValue,
				videoDeviceLayer: config.videoDeviceLayer.rawValue)
		guard ret == 0 else {
			throw SIPError.initializationError(code: ret)
		}
		
		portSIP.setSrtpPolicy(config.srtp.type);

//		let localPort = 10000 + arc4random()%1000;
//		var loaclIPaddress = "0.0.0.0";//Auto select IP address
//
//		ret = portSIPSDK.setUser(kUserName,displayName:kDisplayName, authName:kAuthName, password:kPassword, localIP:loaclIPaddress, localSIPPort:Int32(localPort), userDomain:kUserDomain, sipServer:kSIPServer, sipServerPort:Int32(kSIPServerPort!), stunServer:"", stunServerPort:0, outboundServer:"", outboundServerPort:0);
//
//		if(ret != 0){
//			NSLog("setUser failure ErrorCode = %d",ret);
//			return ;
//		}
		
		ret = portSIP.setLicenseKey(config.licenseKey)
		guard ret == 0 else {
			try deinitialise()
			throw SIPError.initializationError(code: ret)
		}
		
		isInitialised = true
	}
	
	func deinitialise() {
		defer {
			isInitialised = false
		}
		portSIP.unInitialize()
	}
	
	func authenticate(_ account: SIPServiceAccountConfiguration) {
		let localPort = 10000 + arc4random()%1000;
		var loaclIPaddress = "0.0.0.0";//Auto select IP address

		let ret = portSIP.setUser(
				account.credentials.userName,
				displayName: account.credentials.displayName,
				authName: account.credentials.authName,
				password: account.credentials.password,
				localIP: loaclIPaddress,
				localSIPPort: Int32(localPort),
				userDomain: "",
				sipServer: account.host,
				sipServerPort: account.port,
				stunServer:"",
				stunServerPort:0,
				outboundServer:"",
				outboundServerPort:0);

		if(ret != 0){
			NSLog("setUser failure ErrorCode = %d",ret);
			return ;
		}
	}
	
	private(set) var isRegistered: Bool = false
	
	func register(expires: Int, retries: Int) throws {
	}
	
	func unregister() throws {
	}
	
	var refreshInterval: Int {
		get {
			return 0
		}
		set {
		}
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
