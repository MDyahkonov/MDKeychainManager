//
//  MDKeychainManager.h
//  MDKeychainManager
//
//  Created by Michael Diakonov on 7/29/15.
//  Copyright (c) 2015 Diakonov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MDKeychainManager : NSObject

+ (MDKeychainManager *)sharedManager;

- (BOOL)addClientWithKeyChainIdentifier:(NSString *)identifier username:(NSString *)username password:(NSString *)password;
- (BOOL)deleteClientWithIdentifier:(NSString *)identifier;
- (NSDictionary *)searchForItemWithIdentifier:(NSString *)identifier;

//TODO
//Update item

@end


