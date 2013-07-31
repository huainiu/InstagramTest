//
//  InstagramUserFeed.m
//  InstagramTest
//
//  Created by Бондик Киричков on 26.07.13.
//  Copyright (c) 2013 Kirichkov's. All rights reserved.
//

#import "InstagramUserFeed.h"
#import "UIImageView+AFNetworking.h"

@interface InstagramUserFeed ()

@property (strong) NSMutableArray * feedArray;
@property (strong) NSString * refreshURL;
@property (strong) NSString * baseURL;

@property (strong) NSString * currentMinID;
@property (strong) NSString * currentMaxID;



@end

@implementation InstagramUserFeed

-(void)refreshFeed {
    
    if (_currentMinID != nil) {
        
        NSString * feedURL = [_baseURL stringByAppendingString:_accessToken];
        
        if (![_currentMinID isEqualToString:@""]) {
            feedURL = [feedURL stringByAppendingFormat:@"%@%@", @"&min_id=", _currentMinID];
        }
        
        NSURLRequest * feedRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:feedURL]];
        
        NSLog(@"%@",feedURL);
        
        AFJSONRequestOperation * feedOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:feedRequest success:^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON){
            
            NSMutableArray * tempMediaArray = [NSMutableArray arrayWithArray:[JSON objectForKey:@"data"]];
            
            for (int i=tempMediaArray.count-1; i>=0; i--) {
                NSDictionary * mediaDict = [tempMediaArray objectAtIndex:i];
                if (![[mediaDict objectForKey:@"type"] isEqualToString:@"image"] ) {
                    [tempMediaArray removeObjectAtIndex:i];
                }
            }
            
            NSRange insertNewFeedRecordsRange = {0, tempMediaArray.count};
            [_feedArray insertObjects:tempMediaArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:insertNewFeedRecordsRange]];
            
            if ([_currentMaxID isEqualToString:@""]) {
                _currentMaxID = [[_feedArray lastObject] objectForKey:@"id"];
            }
            _currentMinID = [[_feedArray objectAtIndex:0] objectForKey:@"id"];
            
            [_display.tableView reloadData];
            [_display stopLoading];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            if (_feedArray.count>0) {
                _currentMinID = [[_feedArray objectAtIndex:0] objectForKey:@"id"];
            } else {
                _currentMinID = @"";
            }

            [_display stopLoading];
        }];
        
        _currentMinID = nil;
        [feedOperation start];
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    if (section == 0) {
        
        NSInteger count = _feedArray.count;
        return count;
    } else {
        return 0;
    }

}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    UITableViewCell * tempCell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:nil];
    if (indexPath.section==0) {
        
        NSDictionary * mediaDict = [_feedArray objectAtIndex:indexPath.row];
        
        id locationDict = [mediaDict objectForKey:@"location"];
        if ([locationDict isKindOfClass:[NSDictionary class]]) {
            NSString * locationName = [locationDict objectForKey:@"name"];
            if ([locationName isEqualToString:@""] || locationName==nil) {
                tempCell.textLabel.text = @"[unknown location]";
            } else {
                tempCell.textLabel.text = locationName;
                
            }
            
        } else {
            tempCell.textLabel.text = @"[unknown location]";
        }
        
        NSString * imageThumbURL = [[[mediaDict objectForKey:@"images"] objectForKey:@"thumbnail"] objectForKey:@"url"];
        
        __weak UITableViewCell * weakCell = tempCell;
        
        [tempCell.imageView setImageWithURLRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:imageThumbURL]]
                                  placeholderImage:nil
                                           success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
                                               
                                               weakCell.imageView.image=image;
                                               [weakCell setNeedsLayout];
                                           }
                                           failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
                                               
                                           }];
    }
    return tempCell;
}

-(void)getOlderMedia {
    
    if (_currentMaxID != nil) {
        NSString * feedURL = [_baseURL stringByAppendingString:_accessToken];
        
        if ([_currentMaxID isEqualToString:@""]) {
            [self refreshFeed];
            return;
        }
        
        feedURL = [feedURL stringByAppendingFormat:@"%@%@", @"&max_id=", _currentMaxID];
        
        NSURLRequest * feedRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:feedURL]];
        
        NSLog(@"%@",feedURL);
        
        AFJSONRequestOperation * feedOperation = [AFJSONRequestOperation JSONRequestOperationWithRequest:feedRequest success:^(NSURLRequest * request, NSHTTPURLResponse * response, id JSON){
            
            NSMutableArray * tempMediaArray = [NSMutableArray arrayWithArray:[JSON objectForKey:@"data"]];
            if (tempMediaArray.count == 0) {
                ((UILabel*)_display.tableView.tableFooterView).text = @"END of feed";
            }
            for (int i=tempMediaArray.count-1; i>=0; i--) {
                NSDictionary * mediaDict = [tempMediaArray objectAtIndex:i];
                if (![[mediaDict objectForKey:@"type"] isEqualToString:@"image"] ) {
                    [tempMediaArray removeObjectAtIndex:i];
                }
            }
            
            NSRange insertNewFeedRecordsRange = {_feedArray.count, tempMediaArray.count};
            [_feedArray insertObjects:tempMediaArray atIndexes:[NSIndexSet indexSetWithIndexesInRange:insertNewFeedRecordsRange]];
            
            _currentMaxID = [[_feedArray lastObject] objectForKey:@"id"];
            
            [_display.tableView reloadData];
            
        } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
            if (_feedArray.count>0) {
                _currentMaxID = [[_feedArray lastObject] objectForKey:@"id"];
            } else {
                _currentMaxID = @"";
            }
            
            [_display stopLoading];
        }];
        
        _currentMaxID = nil;
        [feedOperation start];
    }
}

- (id)init
{
    self = [super init];
    if (self) {
        _baseURL = @"https://api.instagram.com/v1/users/self/feed?";
        _feedArray = [[NSMutableArray alloc] init];
        _currentMinID = @"";
        _currentMaxID = @"";
    }
    return self;
}

@end
