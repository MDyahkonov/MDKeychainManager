//
//  MDKeychainManager.m
//  MDKeychainManager
//
//  Created by Michael Diakonov on 7/29/15.
//  Copyright (c) 2015 Diakonov. All rights reserved.
//

#import "MDKeychainManager.h"
#import <Security/Security.h>

static NSString * const service = @"com.Organization.App_name";

@interface MDKeychainManager ()

@end

@implementation MDKeychainManager

+ (MDKeychainManager *)sharedManager{
    
    static MDKeychainManager *sharedManager;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        
        sharedManager = [[self alloc] initPrivate];
        
    });
    
    return sharedManager;
    
}

- (instancetype)initPrivate{
    
    self = [super init];
    if(!self) return nil;
    
    return self;
    
}
//--------------------------------------------------
#pragma mark - Public methods
//--------------------------------------------------

- (BOOL)addClientWithKeyChainIdentifier:(NSString *)identifier username:(NSString *)username password:(NSString *)password{
    
    NSMutableDictionary *client = [self createKeychainDictionaryWithIdentifier:identifier username:username password:password];
    
    OSStatus status = SecItemAdd((__bridge CFDictionaryRef)client, NULL);
    
    if(status != errSecSuccess)
        return NO;
    
    return YES;
}

- (NSDictionary *)searchForItemWithIdentifier:(NSString *)identifier{
    
    NSMutableDictionary *searchDict = [@{} mutableCopy];
    
    NSData *identifierData = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    //Define search dictionary
    [searchDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchDict setObject:(__bridge id)kSecMatchLimitOne forKey:(__bridge id)kSecMatchLimit];
    [searchDict setObject:identifierData forKey:(__bridge id)kSecAttrGeneric];
    [searchDict setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnAttributes];
    [searchDict setObject:(__bridge id)kCFBooleanTrue forKey:(__bridge id)kSecReturnData];
    
    CFDictionaryRef dict = NULL;
    
    OSStatus status = SecItemCopyMatching((__bridge CFDictionaryRef)searchDict, (CFTypeRef *) &dict);
    
    if(status != errSecSuccess)
        return nil;
    
    NSDictionary *result = (__bridge NSDictionary *)dict;
    
    return result;
    
}

- (BOOL)deleteClientWithIdentifier:(NSString *)identifier{
    
    NSMutableDictionary *searchDict = [@{} mutableCopy];
    
    NSData *identifierData = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    
    //Define search dictionary
    [searchDict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    [searchDict setObject:identifierData forKey:(__bridge id)kSecAttrGeneric];
    [searchDict setObject:[identifier dataUsingEncoding:NSUTF8StringEncoding] forKey:(__bridge id)kSecValueData];
    
    OSStatus status = SecItemDelete((__bridge CFDictionaryRef)searchDict);
    
    if(status != errSecSuccess)
        return NO;
    
    return YES;
    
}

//--------------------------------------------------
#pragma mark - Private methods
//--------------------------------------------------

- (NSMutableDictionary *)createKeychainDictionaryWithIdentifier:(NSString *)identifier username:(NSString *)username password:(NSString *)password{
    
    NSMutableDictionary *dict = [@{} mutableCopy];
    
    [dict setObject:(__bridge id)kSecClassGenericPassword forKey:(__bridge id)kSecClass];
    
    NSData *identifierData = [identifier dataUsingEncoding:NSUTF8StringEncoding];
    NSData *passwordData = [password dataUsingEncoding:NSUTF8StringEncoding];
    
    [dict setObject:(__bridge id)kSecAttrAccessibleWhenUnlocked forKey:(__bridge id)kSecAttrAccessible];
    [dict setObject:identifierData forKey:(__bridge id)kSecAttrGeneric];
    [dict setObject:username forKey:(__bridge id)kSecAttrAccount];
    [dict setObject:passwordData forKey:(__bridge id)kSecValueData];
    [dict setObject:service forKey:(__bridge id)kSecAttrService];
    
    return dict;
}


@end