//
//  generateIDcode.m
//  myshop
//
//  Created by LEIBI on 12/10/15.
//  Copyright © 2015 LEIBI. All rights reserved.
//

#import "generateIDcode.h"

@implementation generateIDCode

- (void)idCode:(CDVInvokedUrlCommand *)command {
    NSLog(@"begin to generate idcode!");
    
    CDVPluginResult *pluginResult;
    NSString *callbackID = [command callbackId];
    NSString *result = [[NSString alloc] init];
    NSString *type = [command argumentAtIndex:0];
    NSString *userID = [[NSString alloc] init];
    NSString *devID = [[NSString alloc] init];
    NSString *intNum = [[NSString alloc] init];
    operatePlist *readPlist = [[operatePlist alloc] init];
    NSDictionary *userinfo = [[NSDictionary alloc] initWithDictionary:[readPlist read:@"userinfo"]];
    
    if ([command argumentAtIndex:1] != nil) {
        userID = [command argumentAtIndex:1];
    }
    else {
        userID = [userinfo objectForKey:@"user_id"];
    }
    
    if ([command argumentAtIndex:2] != nil) {
        devID = [command argumentAtIndex:2];
    }
    else {
        devID = [userinfo objectForKey:@"dev_id"];
    }
    
    if ([command argumentAtIndex:3] != nil) {
        intNum = [command argumentAtIndex:3];
    }
    else {
        intNum = @"-1";
    }
    
    NSString *p1 = [self typeList:type];
    if (![p1 isEqualToString:@"error"]) {
        result = [self idCode:p1 withUserID:userID withDevID:devID withNumber:[intNum intValue]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
    }
    else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:@"type out of range!"];
    }
}

- (void)shortCode:(CDVInvokedUrlCommand *)command {
    NSLog(@"begin to generate shortCode!");
    
    CDVPluginResult *pluginResult;
    NSString *callbackID = [command callbackId];
    NSString *result = [[NSString alloc] init];
    NSString *type = [command argumentAtIndex:0];
    NSString *intNum = [[NSString alloc] init];
    NSString *p1 = [self typeList:type];
    
    if ([command argumentAtIndex:1] != nil) {
        intNum = [command argumentAtIndex:1];
    }
    else {
        intNum = @"-1";
    }
    
    if (![p1 isEqualToString:@"error"]) {
        result = [self shortCode:p1 withNumber:[intNum intValue]];
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
    }
    else {
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR
                                         messageAsString:@"type out of range!"];
    }

}

- (void)devID:(CDVInvokedUrlCommand *)command {
    NSLog(@"begin to generate dev_id!");
    
    CDVPluginResult *pluginResult;
    NSString *callbackID = [command callbackId];
    NSString *p1 = [[NSString alloc] init];
    NSString *p2 = [[NSString alloc] init];
    NSDictionary *info = [[NSDictionary alloc] init];
    operatePlist *accessPlist = [[operatePlist alloc] init];
    
    info = [accessPlist read:@"userinfo"];
    
    if ([info objectForKey:@"dev_id"] == nil) {
        NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
        [dateFormat setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
        p1 = [dateFormat stringFromDate:[NSDate date]];
        NSLog(@"p1: %@", p1);
        
        p2 = [[[p1 MD5String] substringWithRange:NSMakeRange(0, 12)] uppercaseString];
        info = [[NSDictionary alloc] initWithObjectsAndKeys:p2, @"dev_id", nil];
        
        [accessPlist write:@"userinfo" withInfo:info];
    }
    
    pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK];
    [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
}

- (void)MD5:(CDVInvokedUrlCommand *)command {
    NSLog(@"begin to generate MD5!");
    
    CDVPluginResult *pluginResult;
    NSString *callbackID = [command callbackId];
    NSString *result = [[NSString alloc] init];
    NSString *key = [[NSString alloc] init];
    NSString *error = [[NSString alloc] init];
    
    if ([command argumentAtIndex:0] != nil) {
        key = [command argumentAtIndex:0];
        result = [key MD5String];
    }
    else {
        error = @"input is error!";
    }
    
    if (error.length > 0) {
        NSLog(@"input is error!");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_ERROR messageAsString:error];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
    }
    else {
        NSLog(@"MD5 is generated!");
        pluginResult = [CDVPluginResult resultWithStatus:CDVCommandStatus_OK messageAsString:result];
        [self.commandDelegate sendPluginResult:pluginResult callbackId:callbackID];
    }
}

- (NSString *)idCode:(NSString *)type
          withUserID:(NSString *)user_id
           withDevID:(NSString *)dev_id
          withNumber:(int)num {
    NSString *result = [[NSString alloc] init];
    NSString *p1 = [[NSString alloc] init];
    NSString *p2 = [[NSString alloc] init];
    NSString *p3 = [[NSString alloc] init];
    NSString *p4 = [[NSString alloc] init];
    NSString *p5 = [[NSString alloc] init];
    
    //根据前缀生成P1
    p1 = type;
    NSLog(@"p1: %@", p1);
    
    //根据user_id产生MD5生成P2
    p2 = [NSString stringWithFormat:@"%@%@", user_id, dev_id];
    p2 = [[[p2 MD5String] substringWithRange:NSMakeRange(0, 12)] uppercaseString];
    NSLog(@"p2: %@", p2);
    
    //根据当前时间格式yyMMddHHmmss生成P3
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyMMddHHmmss"];
    p3 = [dateFormat stringFromDate:[NSDate date]];
    NSLog(@"p3: %@", p3);
    
    if (num == -1) {
        //根据当前时间格式yyMMddHH生成P5
        [dateFormat setDateFormat:@"yyMMddHH"];
        p5 = [dateFormat stringFromDate:[NSDate date]];
        NSLog(@"p5: %@", p5);
        
        NSMutableString *sql = [[NSMutableString alloc] initWithString:@"select * from COUNT "];
        [sql appendFormat:@"where type = \"%@\"", p1];
        
        NSMutableArray *searchResult = [[NSMutableArray alloc] initWithArray:[self searchData:sql]];
        if ([searchResult count] == 0) {
            num = 1;
            NSString *numStr = [[NSString alloc] initWithFormat:@"%i", num];
            NSString *sql = @"INSERT INTO COUNT (count, date, type) VALUES (?, ?, ?)";
            NSArray *column = [[NSArray alloc] initWithObjects:numStr, p5, p1, nil];
            NSMutableArray *insertSql = [[NSMutableArray alloc] initWithObjects:sql, nil];
            NSMutableArray *insertRecord = [[NSMutableArray alloc] initWithObjects:column, nil];
            [self saveData:insertRecord withSql:insertSql];
        }
        else {
            NSMutableDictionary *count = [[NSMutableDictionary alloc] initWithDictionary:[searchResult objectAtIndex:0]];
            if ([[count objectForKey:@"date"] isEqualToString:p5]) {
                num = [[count valueForKey:@"count"] intValue]+ 1;
            }
            else {
                num = 1;
                [count setObject:p5 forKey:@"date"];
            }
            NSString *numStr = [[NSString alloc] initWithFormat:@"%i", num];
            NSString *sql = @"UPDATE COUNT SET count = ? ,  date = ?";
            NSArray *column = [[NSArray alloc] initWithObjects:numStr, p5, nil];
            NSMutableArray *updateSql = [[NSMutableArray alloc] initWithObjects:sql, nil];
            NSMutableArray *updateRecord = [[NSMutableArray alloc] initWithObjects:column, nil];
            [self saveData:updateRecord withSql:updateSql];
        }
    }
    
    p4 = [NSString stringWithFormat:@"%04d", num];
    result = [NSString stringWithFormat:@"%@%@%@%@", p1, p2, p3, p4];
    return result;
}

- (NSString *)shortCode:(NSString *)type withNumber:(int)num {
    NSString *result;
    NSString *p1 = [[NSString alloc] init];
    NSString *p3 = [[NSString alloc] init];
    NSString *p4 = [[NSString alloc] init];
    NSString *p5 = [[NSString alloc] init];
    
    p1 = type;
    NSLog(@"p1: %@", p1);
    
    NSDateFormatter *dateFormat = [[NSDateFormatter alloc] init];
    [dateFormat setDateFormat:@"yyMMdd"];
    p3 = [dateFormat stringFromDate:[NSDate date]];
    NSLog(@"p3: %@", p3);
    
    if (num == -1) {
        [dateFormat setDateFormat:@"yyMMddHH"];
        p5 = [dateFormat stringFromDate:[NSDate date]];
        NSLog(@"p5: %@", p5);
        
        NSMutableString *sql = [[NSMutableString alloc] initWithString:@"select * from COUNT "];
        [sql appendFormat:@"where type = \"%@\"", p1];
        
        NSMutableArray *searchResult = [[NSMutableArray alloc] initWithArray:[self searchData:sql]];
        if ([searchResult count] == 0) {
            num = 1;
            NSString *numStr = [[NSString alloc] initWithFormat:@"%i", num];
            NSString *sql = @"INSERT INTO COUNT (count, date, type) VALUES (?, ?, ?)";
            NSArray *column = [[NSArray alloc] initWithObjects:numStr, p5, p1, nil];
            NSMutableArray *insertSql = [[NSMutableArray alloc] initWithObjects:sql, nil];
            NSMutableArray *insertRecord = [[NSMutableArray alloc] initWithObjects:column, nil];
            [self saveData:insertRecord withSql:insertSql];
        }
        else {
            NSMutableDictionary *count = [[NSMutableDictionary alloc] initWithDictionary:[searchResult objectAtIndex:0]];
            if ([[count objectForKey:@"date"] isEqualToString:p5]) {
                num = [[count valueForKey:@"count"] intValue]+ 1;
            }
            else {
                num = 1;
                [count setObject:p5 forKey:@"date"];
            }
            NSString *numStr = [[NSString alloc] initWithFormat:@"%i", num];
            NSString *sql = @"UPDATE COUNT SET count = ? ,  date = ?";
            NSArray *column = [[NSArray alloc] initWithObjects:numStr, p5, nil];
            NSMutableArray *updateSql = [[NSMutableArray alloc] initWithObjects:sql, nil];
            NSMutableArray *updateRecord = [[NSMutableArray alloc] initWithObjects:column, nil];
            [self saveData:updateRecord withSql:updateSql];
        }
    }
    
    p4 = [NSString stringWithFormat:@"%04d", num];
    result = [NSString stringWithFormat:@"%@%@%@", p1, p3, p4];
    return result;
}

- (NSString *)typeList:(NSString *)type {
    NSArray *typeList = [[NSArray alloc] initWithObjects:@"SP", @"FH", @"SH", @"PP", @"DW", @"CG", @"XS", @"TP", @"SK", @"FK", @"FP", @"PZ", @"XT", @"CT", @"LX", @"CA", @"CJ", @"XQ", @"HF", @"FB", @"GS", @"WL", @"ZW", @"XX", @"BC", @"LY", nil];
    
    NSString *p1 = [[NSString alloc] init];
    
    switch ([typeList indexOfObject:type]) {
        case 0://商品
        p1 = @"SP";
        break;
        case 1://发货
        p1 = @"FH";
        break;
        case 2://收货
        p1 = @"SH";
        break;
        case 3://商品品牌
        p1 = @"PP";
        break;
        case 4://商品单位
        p1 = @"DW";
        break;
        case 5://采购
        p1 = @"CG";
        break;
        case 6://销售
        p1 = @"XS";
        break;
        case 7://图片
        p1 = @"TP";
        break;
        case 8://收款
        p1 = @"SK";
        break;
        case 9://付款
        p1 = @"FK";
        break;
        case 10://发票
        p1 = @"FP";
        break;
        case 11://附件
        p1 = @"PZ";
        break;
        case 12://销售退货
        p1 = @"XT";
        break;
        case 13://采购退货
        p1 = @"CT";
        break;
        case 14://联系人
        p1 = @"LX";
        break;
        case 15://商品类型
        p1 = @"CA";
        break;
        case 16://生产厂家
        p1 = @"CJ";
        break;
        case 17://需求
        p1 = @"XQ";
        break;
        case 18://回复
        p1 = @"HF";
        break;
        case 19://发布商品
        p1 = @"FB";
        break;
        case 20://公司
        p1 = @"GS";
        break;
        case 21://物流
        p1 = @"WL";
        break;
        case 22://职位
        p1 = @"ZW";
        break;
        case 23://消息
        p1 = @"XX";
        break;
        case 24://基础联系人ID
        p1 = @"BC";
        break;
        case 25://录音
        p1 = @"LY";
        break;
        default:
        NSLog(@"error! out of type list!");
        p1 = @"error";
        break;
    }

    return p1;
}

- (void)saveData:(NSMutableArray *)record withSql:(NSMutableArray *)sql{
    //NSLog(@"begin to insert records into database");
    
    NSString *folderName = [[NSString alloc] init];
    NSString *writableDBPath = [self GetPathByFolderName:folderName withFileName:@"myshop"];
    
    NSArray *column = [[NSArray alloc] init];
    bool resultStatus = false;
    char *errorMsg;
    @try {
        const char* cpath = [writableDBPath UTF8String];
        if (sqlite3_open(cpath, &database) != SQLITE_OK) {
            sqlite3_close(database);
            NSAssert(NO, @"open database is filure!");
        }
        else {
            if (sqlite3_exec(database, "BEGIN", NULL, NULL, &errorMsg) == SQLITE_OK) {
                NSLog(@"sqlite transaction is launch!");
                sqlite3_free(errorMsg);
                
                sqlite3_stmt *statement;
                //NSLog(@"%lu", (unsigned long)[sql count]);
                for (int i = 0; i < [sql count]; i++) {
                    //NSLog(@"%@", [sql objectAtIndex:i]);
                    if (sqlite3_prepare_v2(database, [[sql objectAtIndex:i] UTF8String], -1, &statement, NULL) == SQLITE_OK) {
                        column = [record objectAtIndex:i];
                        for (int j = 0; j < [column count]; j++) {
                            //NSLog(@"%@", [column objectAtIndex:j]);
                            sqlite3_bind_text(statement, (j+1), [[column objectAtIndex:j] UTF8String], -1, NULL);
                        }
                        if (sqlite3_step(statement) == SQLITE_DONE) {
                            resultStatus = YES;
                            sqlite3_finalize(statement);
                        } else {
                            resultStatus = NO;
                        }
                    }
                    else {
                        NSLog(@"Error: %s", sqlite3_errmsg(database));
                        NSAssert1(0, @"Error: %s", sqlite3_errmsg(database));
                    }
                }
                if (sqlite3_exec(database, "COMMIT", NULL, NULL, &errorMsg) == SQLITE_OK) {
                    NSLog(@"sqlite transaction commit success!");
                }
                sqlite3_free(errorMsg);
            }
            else {
                NSLog(@"Error: %s", sqlite3_errmsg(database));
                NSAssert1(0, @"Error: %s", sqlite3_errmsg(database));
                sqlite3_free(errorMsg);
            }
        }
    }
    @catch (NSException *exception) {
        if (sqlite3_exec(database, "ROLLBACK", NULL, NULL, &errorMsg) == SQLITE_OK) {
            NSLog(@"sqilte transaction is rollback!");
        }
    }
    @finally {
        
    }
}

- (NSMutableArray *)searchData:(NSString *)sql {
    //NSLog(@"begin to query database!");
    
    NSString *folderName = [[NSString alloc] init];
    NSString *writableDBPath = [self GetPathByFolderName:folderName withFileName:@"myshop"];
    
    NSMutableArray *result = [[NSMutableArray alloc] init];
    const char *cSql = [sql UTF8String];
    sqlite3_stmt *statement;
    
    const char* cpath = [writableDBPath UTF8String];
    if (sqlite3_open(cpath, &database) != SQLITE_OK) {
        sqlite3_close(database);
        NSAssert(NO, @"open database is filure!");
    } else {
        if (sqlite3_prepare_v2(database, cSql, -1, &statement, NULL) == SQLITE_OK) {
            while (sqlite3_step(statement) == SQLITE_ROW) {
                int num_clos = sqlite3_column_count(statement);
                NSMutableDictionary *dict = [NSMutableDictionary dictionaryWithCapacity:num_clos];
                if (num_clos > 0) {
                    for (int j = 0; j < num_clos; j++) {
                        const char *col_name = sqlite3_column_name(statement, j);
                        if (col_name) {
                            NSString *colName = [NSString stringWithUTF8String:col_name];
                            id value = nil;
                            switch (sqlite3_column_type(statement, j)) {
                                case SQLITE_INTEGER: {
                                    int i_value = sqlite3_column_int(statement, j);
                                    value = [NSNumber numberWithInt:i_value];
                                    break;
                                }
                                case SQLITE_FLOAT: {
                                    double d_value = sqlite3_column_double(statement, j);
                                    value = [NSNumber numberWithDouble:d_value];
                                    break;
                                }
                                case SQLITE_TEXT: {
                                    char *c_value = (char *)sqlite3_column_text(statement, j);
                                    value = [[NSString alloc] initWithUTF8String:c_value];
                                    break;
                                }
                                case SQLITE_BLOB: {
                                    value = (__bridge id)(sqlite3_column_blob(statement, j));
                                    break;
                                }
                            }
                            if (value) {
                                [dict setObject:value forKey:colName];
                            }
                        }
                    }
                }
                [result addObject:dict];
            }
        }
        sqlite3_finalize(statement);
        sqlite3_close(database);
    }
    return result;
}

- (NSString *)GetPathByFolderName:(NSString *)_folderName withFileName:(NSString *)_fileName {
    //NSLog(@"begin to generate file path!");
    
    NSError *error;
    NSFileManager *filePath = [NSFileManager defaultManager];
    NSString *directory = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0];
    
    directory = [directory stringByAppendingString: _folderName];
    
    if (![filePath fileExistsAtPath:directory]) {
        [filePath createDirectoryAtPath:directory
            withIntermediateDirectories:YES
                             attributes:nil
                                  error:&error];
    }
    
    NSString *fileDirectory = [[[directory stringByAppendingPathComponent:_fileName]
                                stringByAppendingPathExtension:@"db"]
                               stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSLog(@"%@",fileDirectory);
    return fileDirectory;
}
@end
