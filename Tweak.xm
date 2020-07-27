#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wunused-variable"

static NSDate *date1;
static NSDate *date2;
static BOOL placeHolder = YES;
static BOOL placeHolder2 = NO;
static NSString *foregroundBundleID;
NSDictionary *bundleDefaults = [[NSUserDefaults standardUserDefaults]persistentDomainForName:@"com.popsicletreehouse.switcherclearerprefs"];
BOOL isEnabled = [[bundleDefaults objectForKey:@"isEnabled"]boolValue];
BOOL dontClearNowPlaying = [[bundleDefaults objectForKey:@"dontClearNowPlaying"]boolValue];
NSInteger clearingInterval = [([bundleDefaults objectForKey:@"clearingInterval"] ?: @(5)) integerValue];
@interface FBProcessManager
+(id)sharedInstance;
-(id)allApplicationProcesses;
@end
@interface SBDisplayItem: NSObject
@property (nonatomic,copy,readonly) NSString * bundleIdentifier;
@end
@interface SBApplication : NSObject
@property (nonatomic,readonly) NSString * bundleIdentifier;                                                                                     //@synthesize bundleIdentifier=_bundleIdentifier - In the implementation block
@end
@interface SBMediaController : NSObject
@property (nonatomic, weak,readonly) SBApplication * nowPlayingApplication;
+(id)sharedInstance;
@end
@interface SBMainSwitcherViewController: NSTimer
+(id)sharedInstance;
-(id)recentAppLayouts;
-(void)dismissSwitcher;
-(void)createTimer;
-(void)_deleteAppLayout:(id)arg1 forReason:(long long)arg2;
@end
@interface SBAppLayout:NSObject
@property (nonatomic,copy) NSDictionary * rolesToLayoutItemsMap;
@end
@interface SBRecentAppLayouts: NSObject
+ (id)sharedInstance;
-(id)_recentsFromPrefs;
-(void)remove:(SBAppLayout* )arg1;
-(void)removeAppLayouts:(id)arg1 ;
@end
%hook SBMainSwitcherViewController
%new
-(void)dismissSwitcher {
	if(dontClearNowPlaying) {
		SBMainSwitcherViewController *mainSwitcher = [%c(SBMainSwitcherViewController) sharedInstance];
    	NSArray *applications = mainSwitcher.recentAppLayouts;
    	for(SBAppLayout * item in applications) {
			SBDisplayItem *itemz = [item.rolesToLayoutItemsMap objectForKey:@1];
			NSString *bundleID = itemz.bundleIdentifier;
			NSString *nowPlayingID = [[[%c(SBMediaController) sharedInstance] nowPlayingApplication] bundleIdentifier];
			if(![bundleID isEqualToString: nowPlayingID]) {
				[mainSwitcher _deleteAppLayout:item forReason: 1];
			}
		}
	} else if(!dontClearNowPlaying) {
		SBMainSwitcherViewController *mainSwitcher = [%c(SBMainSwitcherViewController) sharedInstance];
    	NSArray *applications = mainSwitcher.recentAppLayouts;
    	for(SBAppLayout * item in applications) {
			SBDisplayItem *itemz = [item.rolesToLayoutItemsMap objectForKey:@1];
			NSString *bundleID = itemz.bundleIdentifier;
			NSString *nowPlayingID = [[[%c(SBMediaController) sharedInstance] nowPlayingApplication] bundleIdentifier];
			[mainSwitcher _deleteAppLayout:item forReason: 1];
		}
	}
}
%new
-(void)createTimer {
	NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:clearingInterval target:self selector:@selector(dismissSwitcher) userInfo:nil repeats:YES];
	[[NSRunLoop currentRunLoop] addTimer:timer forMode:NSDefaultRunLoopMode];
}
-(id)_init {
	if(isEnabled) {
		//%orig;
		//NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:clearingInterval target:self selector:@selector(dismissSwitcher) userInfo:nil repeats:YES];
		/*if(placeHolder) {
			date1 = [NSDate now];
			placeHolder = NO;
			placeHolder2 = YES;
		} else if (!placeHolder && placeHolder2) {
			date2 = [NSDate now];
			placeHolder2 = NO;
		}
		NSTimeInterval secondsBetween = [date2 timeIntervalSinceDate: date1];
		if(secondsBetween >= (clearingInterval)) {*/
		[self createTimer];
		return %orig;
		//	placeHolder2 = NO;
		//	placeHolder = YES;
		//}
	} else {
		return %orig;
	}	
}
%end
#pragma clang diagnostic pop