//
//  Controls the barcode recognition process and informs registered delegates about the
//  barcode recognition state each time a new video frame has been analyzed.
//
//  Copyright 2010 Mirasense. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <CoreLocation/CoreLocation.h>


@class ScanditSDKBarcodePicker;
@class ScanditSDKOverlayController;


@protocol ScanditSDKNextFrameDelegate
- (void)scanditSDKBarcodePicker:(ScanditSDKBarcodePicker*)scanditSDKBarcodePicker 
				didCaptureImage:(NSData*) image 
					 withHeight:(int)height 
					  withWidth:(int)width;
@end

typedef enum {
    CAMERA_FACING_BACK,
    CAMERA_FACING_FRONT
} CameraFacingDirection;

@interface ScanditSDKBarcodePicker : UIViewController <AVCaptureVideoDataOutputSampleBufferDelegate> {
    
	ScanditSDKOverlayController *overlayController;
    CGSize size;
}

@property (nonatomic, retain) ScanditSDKOverlayController *overlayController;

/**
 * The size of the picker and its preview. Change this if you want to scale the picker.
 * 
 * By default it is full screen.
 */
@property (nonatomic, assign) CGSize size;

/**
 * The orientation of the camera preview. In general the preview's orientation will be as wanted,
 * but there may be cases where it needs to be set individually. This also switches height and
 * width of the whole picker such that the preview fits again.
 * This does not change the orientation of the overlayed UI elements.
 *
 * Possible values are: 
 * AVCaptureVideoOrientationPortrait, AVCaptureVideoOrientationPortraitUpsideDown,
 * AVCaptureVideoOrientationLandscapeLeft, AVCaptureVideoOrientationLandscapeRight
 */
@property (nonatomic, assign) AVCaptureVideoOrientation cameraPreviewOrientation;


/**
 * Initiate the barcode picker. To enable the analytics and location capabilities 
 * of the Scandit SDK, set the parameters accordingly. The app key is mandatory and is available
 * via the Scandit SDK website. 
 * The default facing is CAMERA_FACING_BACK.
 */
- (id)initWithAppKey:(NSString *)scanditSDKAppKey;
- (id)initWithAppKey:(NSString *)scanditSDKAppKey 
      cameraFacingPreference:(CameraFacingDirection)facing;

/**
 * Sets a new (custom) overlay controller that received updates from the barcode engine.
 */
- (void)setOverlayController:(ScanditSDKOverlayController *)overlay;


/**
 * Returns YES if the scanning is in progress. 
 */
- (BOOL)isScanning;

/** 
 * Starts the scanning process, and triggers the loading and initialization of the recognition 
 * engine, in case this has not been done so far.
 */
- (void)startScanning;

/** 
 * Stops the scanning process. 
 */
- (void)stopScanning;

/**
 * Resets the barcode scanner state. Can be used if a code has been recognized, the user is still 
 * close to the code, and the code should be recognized again, e.g. after the user pressed a button.
 */
- (void)reset;

/**
 * Enables or disables the recognition of 1D codes.
 *
 * By default it is enabled.
 */
- (void)set1DScanningEnabled:(BOOL)enabled;

/**
 * Enables or disables the recognition of 2D codes. (Note: 2D scanning is not
 * supported by all Scandit SDK versions)
 *
 * By default it is enabled.
 */
- (void)set2DScanningEnabled:(BOOL)enabled;

/**
 * Enables or disables the recognition of EAN13 and UPC12/UPCA codes.
 *
 * By default it is enabled.
 */
- (void)setEan13AndUpc12Enabled:(BOOL)enabled;

/**
 * Enables or disables the recognition of EAN8 codes.
 *
 * By default it is enabled.
 */
- (void)setEan8Enabled:(BOOL)enabled;

/**
 * Enables or disables the recognition of UPCE codes.
 *
 * By default it is enabled.
 */
- (void)setUpceEnabled:(BOOL)enabled;

/**
 * Enables or disables the recognition of CODE39 codes.
 * 
 * Note: CODE39 scanning is only available with the 
 * Scandit SDK Enterprise Basic or Enterprise Premium Package
 *
 * By default it is enabled.
 */
- (void)setCode39Enabled:(BOOL)enabled;

/**
 * Enables or disables the recognition of CODE128 codes.
 *
 * Note: CODE128 scanning is only available with the 
 * Scandit SDK Enterprise Basic or Enterprise Premium Package
 *
 * By default it is enabled.
 */
- (void)setCode128Enabled:(BOOL)enabled;

/**
 * Enables or disables the recognition of ITF codes.
 *
 * Note: ITF scanning is only available with the 
 * Scandit SDK Enterprise Basic or Enterprise Premium Package
 *
 * By default it is enabled.
 */
- (void)setItfEnabled:(BOOL)enabled;

/**
 * Enables or disables the recognition of QR codes.
 *
 * By default it is enabled.
 */
- (void)setQrEnabled:(BOOL)enabled;

/**
 * Enables or disables the recognition of Data Matrix codes.
 *
 * Note: Datamatrix scanning is only available with the 
 * Scandit SDK Enterprise Premium Package
 *
 * By default it is enabled.
 */
- (void)setDataMatrixEnabled:(BOOL)enabled;

/**
 * Enables special settings to allow the recognition of very small Data Matrix codes. If this is
 * not specifically needed, do not enable it as it uses considerable processing power. This setting
 * automatically forces 2d recognition on every frame.
 *
 * By default it is disabled.
 */
- (void)setMicroDataMatrixEnabled:(BOOL)enabled;

/**
 * Enables the detection of white on black codes. This option currently only 
 * works for Data Matrix codes.
 *
 * By default it is disabled.
 */
- (void)setInverseDetectionEnabled:(BOOL)enabled;

/**
 * Forces the barcode scanner to always run the 2D decoders (QR,Datamatrix, etc.), 
 * even when the 2D detector did not detect the presence of a 2D code. 
 * This slows down the overall scanning speed, but is useful for very small 
 * Datamatrix codes which are sometimes not detected by the 2D detector. 
 *
 * By default the recognition is not forced.
 */
- (void)force2dRecognition:(BOOL)force;

/**
 * Switches the torch on or off. If the torch button is enabled on the overlay,
 * users can change this by clicking it.
 * By default the torch is off.
 */
- (void)switchTorchOn:(BOOL)on;

/**
 * Changes the location of the spot where the recognition actively scans for barcodes. X and Y can
 * be between 0 and 1, where 0/0 corresponds to the top left corner and 1/1 to the bottom right corner.
 * 
 * The default is 0.5/0.5
 */
- (void)setScanningHotSpotToX:(float)x andY:(float)y;

/**
 * Changes the height of the spot where the recognition actively scans for barcodes. The height of
 * the hot spot is given relatively to the height of the screen and has to be between 0.0 and 1.0.
 * Be aware that if the hot spot height is very large, the engine is forced to decrease the quality
 * of the recognition to keep the speed at an acceptable level.
 * 
 * The default is 0.25
 */
- (void)setScanningHotSpotHeight:(float)height;

/**
 * Sets the delegate to which the next camera frame should be sent.
 */
- (void)sendNextFrameToDelegate:(id<ScanditSDKNextFrameDelegate>)delegate;



@end

