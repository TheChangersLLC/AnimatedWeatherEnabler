#import <Foundation/Foundation.h>

static BOOL shouldInject = NO;

%hook SBApplication

- (BOOL)icon:(id)icon launchFromLocation:(int)location
{
	shouldInject = NO;
	NSString *app = [self bundleIdentifier];
	if ([app isEqualToString:@"com.apple.weather"])
		shouldInject = YES;
	return %orig;
}

%end

%hook BKSApplicationLaunchSettings

- (void)setEnvironment:(NSDictionary *)env
{
	if (shouldInject) {
		NSMutableDictionary *dict = [env mutableCopy];
		[dict setObject:@"/usr/lib/InjectionAW.dylib" forKey:@"DYLD_INSERT_LIBRARIES"];
		[dict setObject:@"1" forKey:@"DYLD_FORCE_FLAT_NAMESPACE"];
 	 	%orig((NSDictionary *)dict);
  		[dict release];
  	}
  	else %orig;
}

%end
