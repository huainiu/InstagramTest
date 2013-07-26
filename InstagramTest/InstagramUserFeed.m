//
//  InstagramUserFeed.m
//  InstagramTest
//
//  Created by Бондик Киричков on 26.07.13.
//  Copyright (c) 2013 Kirichkov's. All rights reserved.
//

#import "InstagramUserFeed.h"

@interface InstagramUserFeed ()

@property (strong) NSDictionary * feedDictionary;

@property (strong) NSString * baseURL;

@end

@implementation InstagramUserFeed

-(void)requestFeed {
    
    
    NSString * feedURL = [_baseURL stringByAppendingString:_accessToken];
    NSURLRequest * feedRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:feedURL]];
    
    NSLog(@"%@",feedURL);
    AFJSONRequestOperation * feedOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:feedRequest success:^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON){
        _feedDictionary = JSON;
    } failure:nil];
    
    [feedOperation start];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        NSInteger count = ((NSDictionary*)[_feedDictionary objectForKey:@"data"]).count;
        return count;
    } else {
        return 0;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell * tempCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:[NSString stringWithFormat:@"%d",indexPath.row]];
    if (indexPath.section==0) {
        
        NSDictionary * mediaDict = [_feedDictionary objectForKey:@"data"][indexPath.row];
        
        id locationDict = [mediaDict objectForKey:@"location"];
        if ([locationDict isKindOfClass:[NSDictionary class]]) {
            NSString * locationName = [locationDict objectForKey:@"name"];
            if ([locationName isEqualToString:@""] || locationName==nil) {
                tempCell.textLabel.text = @"[unknown location]";
            } else {
                tempCell.textLabel.text = locationName;
            }
            
        } else {
            tempCell.textLabel.text = @"video";
        }
    }
    return tempCell;
}

- (id)init
{
    self = [super init];
    if (self) {
        _baseURL = @"https://api.instagram.com/v1/users/self/feed?";
        _feedDictionary = nil;
    }
    return self;
}

@end
