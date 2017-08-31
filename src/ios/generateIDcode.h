//
//  generateIDcode.h
//  myshop
//
//  Created by LEIBI on 12/10/15.
//  Copyright © 2015 LEIBI. All rights reserved.
//

#import <Cordova/CDV.h>
#import "sqlite3.h"
#import "operatePlist.h"
#import "NSString+MD5.h"
#import "operatePlist.h"

@interface generateIDCode : CDVPlugin
{
    sqlite3 *database;
}

- (void)idCode:(CDVInvokedUrlCommand *)command;
- (void)shortCode:(CDVInvokedUrlCommand *)command;
- (void)devID:(CDVInvokedUrlCommand *)command;
- (void)MD5:(CDVInvokedUrlCommand *)command;

- (NSString *)idCode:(NSString *)type
          withUserID:(NSString *)user_id
           withDevID:(NSString *)dev_id
          withNumber:(int) num;
- (NSString *)shortCode:(NSString *)type withNumber:(int) num;
@end
