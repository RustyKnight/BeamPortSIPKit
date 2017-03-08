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

public protocol SIPServer {
	var address: String {get}
	var port: Int32 {get}
}

public protocol SIPServiceAccountConfiguration {

	var sipServer: SIPServer {get}
	var credentials: SIPServiceCredentials { get }
	var localServer: SIPServer {get}
	var userDomain: String {get}
	var stunServer: SIPServer {get}
	var outboundServer: SIPServer {get}
}

public struct DefaultSIPServiceCredentials: SIPServiceCredentials {
	public let userName: String
	public let password: String
	public let authName: String
	public let displayName: String
}

public struct DefaultSIPServer: SIPServer {
	public let address: String
	public let port: Int32
	
	init(address: String = "", port: Int32 = 0) {
		self.address = address
		self.port = port
	}
}

public struct DefaultLocalServer: SIPServer {
	public let address: String
	public let port: Int32
	
	init(address: String = "0.0.0.0", port: Int32 = ((10000 + Int(arc4random())) % 1000)) {
		self.address = address
		self.port = port
	}
}

public struct DefaultSIPServiceConfiguration: SIPServiceAccountConfiguration {
	public let sipServer: SIPServer
	public let credentials: SIPServiceCredentials
	
	public let localServer: SIPServer
	public let userDomain: String
	public let stunServer: SIPServer
	public let outboundServer: SIPServer
	
	public init(
					sipServer: SIPServer,
					credentials: SIPServiceCredentials,
					localServer: SIPServer = DefaultLocalServer(),
					userDomain: String = "",
					stunServer: SIPServer = DefaultSIPServer(),
					outboundServer: SIPServer = DefaultSIPServer()) {
		self.sipServer = sipServer
		self.credentials = credentials
		self.localServer = localServer
		self.userDomain = userDomain
		self.stunServer = stunServer
		self.outboundServer = outboundServer
	}
	
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

public enum SIPServiceStatus {
	case disconnected
	case connecting
	case connected
	case disconnecting
}

public protocol SIPService {

	// MARK: Initialisation and registration

	func initialise(withConfiguration config: SIPServiceConfiguration) throws
	func deinitialise()
	func authenticate(_ account: SIPServiceAccountConfiguration) throws
	func register(expires: Int32, retries: Int32) throws
	func unregister() throws

	var isInitialised: Bool { get }
	func refreshInterval(_ interval: Int32) throws
	var isRegistered: Bool { get }

	var status: SIPServiceStatus { get }

//	var isConnected: Bool { get set }

	var nicManager: SIPNICManager {get}
	var sessionManager: SIPSessionManager {get}

	// MARK: Codec support

	var audioCodeManager: AudioCodecManager {get}
	var videoCodeManager: VideoCodecManager {get}

}

public struct SIPServiceManager {
	public static let shared: SIPService = MutableSIPServiceManager.shared
}

public struct MutableSIPServiceManager {
	public static var shared: SIPService = DefaultSIPService()
}

public enum SIPError: Error {
	case initializationError(code: Int32)
	case authenticationFailed(code: Int32)
	case apiCallFailedWith(code: Int32)
	case notInitialisedYet

}

protocol SIPSupportManager {
	var portSIPSDK: PortSIPSDK {get}
}

public class DefaultSIPSupportManager: SIPSupportManager {
	let portSIPSDK: PortSIPSDK

	init(portSIPSDK: PortSIPSDK) {
		self.portSIPSDK = portSIPSDK
	}
}

class DefaultSIPService: SIPService {
	
	var portSIPSDK: PortSIPSDK!
	
	init() {
		portSIPSDK = PortSIPSDK()
	}
	
	private(set) var isInitialised: Bool = false
	
	func initialise(withConfiguration config: SIPServiceConfiguration) throws {
		guard !isInitialised else {
			return
		}
		
		var ret = portSIPSDK.initialize(
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
		
		portSIPSDK.setSrtpPolicy(config.srtp.type);

		ret = portSIPSDK.setLicenseKey(config.licenseKey)
		guard ret == 0 else {
			deinitialise()
			throw SIPError.initializationError(code: ret)
		}
		
		isInitialised = true
	}
	
	func deinitialise() {
		defer {
			isInitialised = false
		}
		status = .disconnected
		portSIPSDK.unInitialize()
	}
	
	func authenticate(_ account: SIPServiceAccountConfiguration) throws {
		let ret = portSIPSDK.setUser(
				account.credentials.userName,
				displayName: account.credentials.displayName,
				authName: account.credentials.authName,
				password: account.credentials.password,
				localIP: account.localServer.address,
				localSIPPort: account.localServer.port,
				userDomain: account.userDomain,
				sipServer: account.sipServer.address,
				sipServerPort: account.sipServer.port,
				stunServer: account.stunServer.address,
				stunServerPort: account.stunServer.port,
				outboundServer: account.outboundServer.address,
				outboundServerPort: account.outboundServer.port);

		if(ret != 0){
			throw SIPError.authenticationFailed(code: ret)
		}
	}
	
	private(set) var isRegistered: Bool = false
	
	func register(expires: Int32, retries: Int32) throws {
		guard isInitialised else {
			status = .disconnected
			throw SIPError.notInitialisedYet
		}
		status = .connecting
		let result = portSIPSDK.registerServer(expires, retryTimes: retries)
		guard result == 0 else {
			deinitialise()
			throw SIPError.apiCallFailedWith(code: result)
		}
		status = .connected
		isRegistered = true
	}
	
	func unregister() throws {
		status = .disconnecting
		let result = portSIPSDK.unRegisterServer()
		status = .disconnected
		guard result == 0 else {
			deinitialise()
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func refreshInterval(_ interval: Int32) throws {
		let result = portSIPSDK.refreshRegisterServer(interval)
		guard result == 0 else {
			deinitialise()
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	var status: SIPServiceStatus = .disconnected

	var nicManager: SIPNICManager {
		return DefaultSIPNICManager(portSIPSDK: portSIPSDK)
	}
	var sessionManager: SIPSessionManager {
		return DefaultSIPSessionManager(portSIPSDK: portSIPSDK)
	}


	var audioCodeManager: AudioCodecManager {
		return AudioCodecManager(portSIPSDK: portSIPSDK)
	}

	var videoCodeManager: VideoCodecManager {
		return VideoCodecManager(portSIPSDK: portSIPSDK)
	}

}
