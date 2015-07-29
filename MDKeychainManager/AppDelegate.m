//
//  AppDelegate.m
//  MDKeychainManager
//
//  Created by Michael Diakonov on 7/29/15.
//  Copyright (c) 2015 Diakonov. All rights reserved.
//

#import "AppDelegate.h"
#import "MDKeychainManager.h"

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    
    //MDKeychainManager
    //-------------------------------------------------------------------
    NSString *identifier = @"Michael";
    NSString *username = @"Michael";
    NSString *password = @"1234";
    
    MDKeychainManager *keychainManager = [MDKeychainManager sharedManager];
    
    if([keychainManager addClientWithKeyChainIdentifier:identifier username:username password:password]){
        
        NSLog(@"Successfully added item to keychain!");
        
    }
    
    NSDictionary *dict = [keychainManager searchForItemWithIdentifier:identifier];
    
    NSData *data = [dict objectForKey:(__bridge id)kSecValueData];
    
    NSLog(@"Password for identifier: %@ is: %@", identifier, [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding]);
    
    if([keychainManager deleteClientWithIdentifier:identifier])
        NSLog(@"Successfully deleted item in keychain!");
    
    //-------------------------------------------------------------------
    
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
