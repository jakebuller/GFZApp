//
//  The ScanditSDKOverlayController is used to display the viewfinder and the location of the recognized
//  barcode. The overlay controller can be used to configure various scan screen UI elements such as
//  search bar, sound and text elements.
//
//  Copyright 2010 Mirasense AG. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioToolbox/AudioServices.h"
#import "ScanditSDKBarcodePicker.h"

@class ScanditSDKOverlayController;

@protocol ScanditSDKOverlayControllerDelegate
- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController 
                 didScanBarcode:(NSDictionary *)barcode;
- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController 
            didCancelWithStatus:(NSDictionary *)status;
- (void)scanditSDKOverlayController:(ScanditSDKOverlayController *)overlayController 
                didManualSearch:(NSString *)text;
@end

@interface ScanditSDKOverlayController : UIViewController <UISearchBarDelegate> {
	id<ScanditSDKOverlayControllerDelegate> delegate;
	
    UISearchBar *searchBar;
    UIToolbar *toolBar;
	
}

@property (nonatomic, assign) id<ScanditSDKOverlayControllerDelegate> delegate;
@property (nonatomic, retain) UISearchBar *manualSearchBar;
@property (nonatomic, retain) UIToolbar *toolBar;


// UI elements configuration: toolbar, searchbar

/**
 * Adds (or removes) a search bar to the top of the scan screen.
 */
- (void)showSearchBar:(BOOL)show;

/**
 * Adds (or removes) a tool bar at the bottom of the scan screen.
 */
- (void)showToolBar:(BOOL)show;

/**
 * 
 * this method is deprecated and has no longer a matching implementation 
 * in the overlay controller. It will be removed in future versions of the Scandit SDK. 
 * 
 * Add the 'most likely barcode' UI element. This element is displayed
 * below the viewfinder when the barcode engine is not 100% confident 
 * in its result and asks for user confirmation. This element is
 * seldom displayed - typically only when decoding challenging barcodes
 * with fixed focus cameras. 
 * 
 * By default this is disabled (see comment above).
 */
- (void)showMostLikelyBarcodeUIElement:(BOOL)show;

/**
 * Sets the offset at which the info banner is shown. The info banner contains 
 * the 'powered by Scandit' logo and  the 'most likely barcode UI Element' if it is enabled'.
 *
 * By default this is: 0
 */
- (void)setInfoBannerOffset:(int)offset;

/**
 * Resets the scan screen user interface to its initial state.
 */
- (void)resetUI;



// Sound configuration

/**
 * Enables (or disables) the sound when a barcode is recognized.
 * 
 * Enabled by default.
 */
- (void)setBeepEnabled:(BOOL)enabled;

/**
 * Enables or disables the vibration when a barcode is recognized.
 * 
 * Enabled by default.
 */
- (void)setVibrateEnabled:(BOOL)enabled;

/**
 * Sets the audio file used when a code has been recognized. Returns YES if the change was
 * successful.
 * 
 * The default is: "beep.wav"
 */
- (BOOL)setScanSoundResource:(NSString *)path ofType:(NSString *)extension;


// Torch configuration


/**
 * Enables or disables the torch toggle button for all devices that support a torch.
 *
 * By default it is enabled.
 */
- (void)setTorchEnabled:(BOOL)enabled;

/**
 * Sets the image which is being drawn on the left side when the torch is on. If you want this to
 * be displayed in proper resolution on high resolution screens you should provide a resource with
 * the same name but @2x appended (e.g. flashlight-icon@2x.png).
 * 
 * By default this is: "flashlight-icon.gif"
 */
- (BOOL)setTorchOnImageResource:(NSString *)fileName ofType:(NSString *)extension;

/**
 * Sets the image which is being drawn on the left side when the torch is off. If you want this to
 * be displayed in proper resolution on high resolution screens you should provide a resource with
 * the same name but @2x appended (e.g. flashlight-icon@2x.png).
 * 
 * By default this is: "flashlight-icon.gif"
 */
- (BOOL)setTorchOffImageResource:(NSString *)fileName ofType:(NSString *)extension;

/**
 * Sets the position at which the button to enable the torch is drawn. The X and Y coordinates are
 * relative to the screen size, which means they have to be between 0 and 1.
 *
 * By default this is: 0.02, 0.12, 35, 35
 */
- (void)setTorchButtonRelativeX:(float)x relativeY:(float)y width:(float)width height:(float)height;



// Text configuration

/**
 * Sets the text that will be displayed while non-autofocusing cameras are initialized.
 * 
 * By default this is: "Initializing camera..."
 */
- (void)setTextForInitializingCamera:(NSString *)text;

/**
 * Sets the text that will be displayed above the viewfinder to tell the user to align it with the
 * barcode that should be recognized.
 *
 * By default this is: "Align code with box"
 */
- (void)setTextForInitialScanScreenState:(NSString *)text;

/**
 * Sets the text that will be displayed above the viewfinder to tell the user to align it with the 
 * barcode and hold still because a potential code seems to be on the screen.
 *
 * By default this is: "Align code and hold still"
 */
- (void)setTextForBarcodePresenceDetected:(NSString *)text;

/**
 * Sets the text that will be displayed above the viewfinder to tell the user to hold still because
 * a barcode is aligned with the box and the recognition is trying to recognize it.
 * 
 * By default this is: "Decoding ..."
 */
- (void)setTextForBarcodeDecodingInProgress:(NSString *)text;

/**
 * Sets the text that will be displayed if the engine was unable to recognize the barcode.
 *
 * By default this is: "No barcode recognized"
 */
- (void)setTextWhenNoBarcodeWasRecognized:(NSString *)text;

/**
 * Sets the text that will be displayed if the engine was unable to recognize the barcode and it is
 * suggested to enter the barcode manually.
 *
 * By default this is: "Touch to enter"
 */
- (void)setTextToSuggestManualEntry:(NSString *)text;

/**
 * Sets the caption of the manual entry at the top when a barcode of valid length has been entered.
 *
 * By default this is: "Go"
 */
- (void)setSearchBarActionButtonCaption:(NSString *)caption;

/**
 * Sets the caption of the manual entry at the top when no barcode of valid length has been entered.
 * 
 * By default this is: "Cancel"
 */
- (void)setSearchBarCancelButtonCaption:(NSString *)caption;

/**
 * Sets the text shown in the manual entry field when nothing has been entered yet.
 * 
 * By default this is: "Scan barcode or enter it here"
 */
- (void)setSearchBarPlaceholderText:(NSString *)text;

/**
 * Sets the caption of the toolbar button.
 *
 * By default this is: "Cancel"
 */
- (void)setToolBarButtonCaption:(NSString *)caption;

/**
 * Sets the text that is displayed alongside the 'most likely barcode' UI element that 
 * is displayed when the barcode engine is not 100% confident in its result and asks for user
 * confirmation.
 *
 * By default this is: "Tap to use"
 */
- (void)setTextForMostLikelyBarcodeUIElement:(NSString *)text;


// Viewfinder Configuration


/**
 * Sets the font of all text displayed in the UI.
 * 
 * By default this is: "Helvetica"
 */
- (void)setUIFont:(NSString *)font;

/**
 * Sets the color of the viewfinder before and while tracking a barcode (which has not yet been recognized).
 * 
 * By default this is: white (1.0, 1.0, 1.0)
 */
- (void)setViewfinderColor:(float)r green:(float)g blue:(float)b;

/**
 * Sets the color of the viewfinder once the bar code has been recognized.
 * 
 * By default this is: green (0.0, 1.0, 0.0)
 */
- (void)setViewfinderDecodedColor:(float)r green:(float)g blue:(float)b;

/**
 * Sets the size of the viewfinder relative to the size of the screen size
 * Changing this value does not(!) affect the area in which barcodes are successfully recognized.
 * It only changes the size of the box drawn onto the scan screen. 
 * 
 * By default the width is 0.6 and the height is 0.25
 */
- (void)setViewfinderHeight:(float)h width:(float) w;

/**
 * Sets the font size of the text in the view finder. 
 * 
 * By default this is font size 16
 */
- (void)setViewfinderFontSize:(float)fontSize;

/**
 * Sets whether to draw the static viewfinder when no code was detected yet.
 *
 * By default this is YES.
 */
- (void)drawStaticViewfinder:(BOOL)draw;

/**
 * Sets whether to draw the hook at the top of the viewfinder that displays text.
 *
 * By default this is YES.
 */
- (void)drawViewfinderTextHook:(BOOL)draw;

/**
 * Enables (or disables) the "flash" when a barcode is successfully scanned. 
 * 
 * By default, it is enabled
 */
- (void)setScanFlashEnabled:(BOOL)enabled;

/**
 * Sets the banner image which is being drawn at the bottom of the scan screen. If you want this to
 * be displayed in proper resolution on high resolution screens you should provide a resource with
 * the same name but @2x appended (like poweredby@2x.png).
 * 
 * By default this is: "poweredby.png"
 */
- (BOOL)setBannerImageWithResource:(NSString *)fileName ofType:(NSString *)extension;

// Searchbar Configuration


/**
 * Sets the minimum size that a barcode entered in the manual searchbar has to have to possibly be valid.
 * 
 * By default this is: 8
 */
- (void)setMinSearchBarBarcodeLength:(NSInteger)length;

/**
 * Sets the maximum sizethat a barcode entered in the manual searchbar can have to possibly be valid.
 * 
 * By default this is: 100
 */
- (void)setMaxSearchBarBarcodeLength:(NSInteger)length;


@end
