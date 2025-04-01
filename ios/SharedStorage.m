//
//  SharedStorage.m
//  test1
//
//  Created by Guillermo Guevara on 31-03-25.
//


#import "SharedStorage.h"

@implementation SharedStorage

RCT_EXPORT_MODULE();

RCT_EXPORT_METHOD(set:(NSString *)key
                  :(NSString *)value)
{
  NSUserDefaults *sharedDefaults = [[NSUserDefaults alloc] initWithSuiteName:@"group.com.yourcompany.7io-locale.shared"];
  [sharedDefaults setObject:value forKey:key];
  [sharedDefaults synchronize];
}

@end