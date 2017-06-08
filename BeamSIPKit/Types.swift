//
// Created by Shane Whitehead on 6/03/2017.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib


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

	public enum ClientFailure: Int32 {
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

	public enum GlobalFailure: Int {
		case busyEverywhere = 600
		case decline = 603
		case doesNotExistAnywhere
		case notAcceptable = 606
	}

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

public enum SIPAudioCodec: Int32 {
	case none = -1
	case g729 = 18
	case pcma = 8
	case pcmu = 0
	case gsm = 3
	case g722 = 9
	case ilbc = 97
	case amr
	case amrwb
	case speex = 100
	case dtmf
	case speexWB
	case isacWB
	case isacsWB
	case opus
	case g7221 = 121

	static func from(_ text: String) -> SIPAudioCodec? {
		switch text.lowercased() {
		case "none": return .none
		case "g729": return .g729
		case "pcma": return .pcma
		case "pcmu": return .pcmu
		case "gsm": return .gsm
		case "g722": return .g722
		case "ilbc": return .ilbc
		case "amr": return .amr
		case "amrwb": return .amrwb
		case "speex": return .speex
		case "dtmf": return .dtmf
		case "speexWB": return .speexWB
		case "isacWB": return .isacWB
		case "isacsWB": return .isacsWB
		case "opus": return .opus
		case "g7221": return .g7221
		default: return nil
		}
	}

	static func from(_ list: [String]) -> [SIPAudioCodec] {
		var results: [SIPAudioCodec] = []
		for item in list {
			guard let value = from(item) else {
				continue
			}
			results.append(value)
		}
		return results
	}

	var type: AUDIOCODEC_TYPE {
		switch self {
		case .none: return AUDIOCODEC_NONE
		case .g729: return AUDIOCODEC_G729
		case .pcma: return AUDIOCODEC_PCMA
		case .pcmu: return AUDIOCODEC_PCMU
		case .gsm: return AUDIOCODEC_GSM
		case .g722: return AUDIOCODEC_G722
		case .ilbc: return AUDIOCODEC_ILBC
		case .amr: return AUDIOCODEC_AMR
		case .amrwb: return AUDIOCODEC_AMRWB
		case .speex: return AUDIOCODEC_SPEEX
		case .dtmf: return AUDIOCODEC_DTMF
		case .speexWB: return AUDIOCODEC_SPEEXWB
		case .isacWB: return AUDIOCODEC_ISACWB
		case .isacsWB: return AUDIOCODEC_ISACSWB
		case .opus: return AUDIOCODEC_OPUS
		case .g7221: return AUDIOCODEC_G7221
		}
	}
}

public enum SIPVideoCodec: Int32 {
	case none = -1
	case i420 = 113
	case h263 = 32
	case h263PlusH1998 = 115
	case h264 = 125
	case vp8 = 120

	static func from(_ text: String) -> SIPVideoCodec? {
		switch text.lowercased() {
		case "none": return .none
		case "i420": return .i420
		case "h263": return .h263
		case "h263PlusH1998": return .h263PlusH1998
		case "h264": return .h264
		case "vp8": return .vp8
		default: return nil
		}
	}

	static func from(_ list: [String]) -> [SIPVideoCodec] {
		var results: [SIPVideoCodec] = []
		for item in list {
			guard let value = from(item) else {
				continue
			}
			results.append(value)
		}
		return results
	}

	var type: VIDEOCODEC_TYPE {
		switch self {
		case .none: return VIDEO_CODEC_NONE
		case .i420: return VIDEO_CODEC_I420
		case .h263: return VIDEO_CODEC_H263
		case .h263PlusH1998: return VIDEO_CODEC_H263_1998
		case .h264: return VIDEO_CODEC_H264
		case .vp8: return VIDEO_CODEC_VP8
		}
	}
}

public enum SIPVideoDevice: Int32 {
	case front = 0
	case back = 1
}

public enum SIPDTMF: Int32 {
	case rfc2833 = 0
	case info

	var type: DTMF_METHOD {
		switch self {
		case .rfc2833: return DTMF_RFC2833
		case .info: return DTMF_INFO
		}
	}
}