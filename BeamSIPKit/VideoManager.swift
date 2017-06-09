//
// Created by Shane Whitehead on 9/6/17.
// Copyright (c) 2017 Beam Communications. All rights reserved.
//

import Foundation
import PortSIPLib

public enum SIPVideoOrientation: Int32 {
	case portrait = 0
	case landscape = 90
	case reversePortrait = 180
	case reverseLandscape = 270
}

public protocol VideoManager {
	func set(videoDeviceID deviceID: Int32) throws
	func setResolution(width: Int32, height: Int32) throws
	func set(videoBitRateKbps: Int32) throws
	func set(videoFrameRate: Int32) throws

	func set(enabled: Bool, for: SIPSession) throws
	func set(orientation: SIPVideoOrientation) throws

	func set(localView: PortSIPVideoRenderView)
	func set(remoteView: PortSIPVideoRenderView, for: SIPSession) throws

	func set(displayLocal: Bool) throws
	func set(nackStatus: Bool) throws
}

class DefaultVideoManager: DefaultSIPSupportManager, VideoManager {

	override init(portSIPSDK: PortSIPSDK) {
		super.init(portSIPSDK: portSIPSDK)
	}

	func set(videoDeviceID deviceID: Int32) throws {
		let result = portSIPSDK.setVideoDeviceId(deviceID)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func setResolution(width: Int32, height: Int32) throws {
		let result = portSIPSDK.setVideoResolution(width, height: height)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func set(videoBitRateKbps: Int32) throws {
		let result = portSIPSDK.setVideoBitrate(videoBitRateKbps)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func set(videoFrameRate: Int32) throws {
		let result = portSIPSDK.setVideoFrameRate(videoFrameRate)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func set(enabled: Bool, for session: SIPSession) throws {
		let result = portSIPSDK.sendVideo(session.id, sendState: enabled)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func set(orientation: SIPVideoOrientation) throws {
		let result = portSIPSDK.setVideoOrientation(orientation.rawValue)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func set(localView: PortSIPVideoRenderView) {
		portSIPSDK.setLocalVideoWindow(localView)
	}

	func set(remoteView: PortSIPVideoRenderView, for session: SIPSession) throws {
		let result = portSIPSDK.setRemoteVideoWindow(session.id, remoteVideoWindow: remoteView)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func set(displayLocal: Bool) throws {
		let result = portSIPSDK.displayLocalVideo(displayLocal)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}

	func set(nackStatus: Bool) throws {
		let result = portSIPSDK.setVideoNackStatus(nackStatus)
		guard result == 0 else {
			throw SIPError.apiCallFailedWith(code: result)
		}
	}
}