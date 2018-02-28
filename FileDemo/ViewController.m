//
//  ViewController.m
//  FileDemo
//
//  Created by Ryan on 2018/2/26.
//  Copyright © 2018年 Ryan. All rights reserved.
//

#import "ViewController.h"
#import "ZRFileManager.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UILabel *pathLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;


/**
 文件夹目录
 */
@property (nonatomic, copy) NSString *fileDir;

/**
 文件路径
 */
@property (nonatomic, copy) NSString *filePath;

@end

@implementation ViewController

- (NSString *)fileDir {
    if (_fileDir == nil) {
        _fileDir = [NSString stringWithFormat:@"%@/Caches", [ZRFileManager documentPath]];
    }
    return _fileDir;
}

- (NSString *)filePath {
    if (_filePath == nil) {
        _filePath = [NSString stringWithFormat:@"%@/img.jpg", self.fileDir];
    }
    return _filePath;
}

- (void)viewDidLoad {
    [super viewDidLoad];
 
    [self reloadData];
}


- (void)reloadData {
    
    if ([ZRFileManager isExistsAtPath: self.filePath] == NO) {
        self.pathLabel.text = @"文件不存在";
        self.sizeLabel.text = @"";
        self.imageView.image = nil;
    } else {
        self.pathLabel.text = [NSString stringWithFormat:@"文件路径：%@", self.filePath];
        self.sizeLabel.text = [NSString stringWithFormat:@"文件大小：%ldK", (long)[ZRFileManager fileSizeWithPath:self.filePath]];
        [ZRFileManager asyncFileWithPath:self.filePath succ:^(NSData *data) {
            self.imageView.image = [UIImage imageWithData:data];
        } fail:^{
            
        }];
    }
    
}

- (IBAction)addBtnClick:(id)sender {
 
    
    NSData *data = UIImagePNGRepresentation([UIImage imageNamed:@"img.png"]);
    [ZRFileManager saveFileWithDirPath: self.fileDir fileName: @"img.jpg" data:data succ:^{
        [self reloadData];
    } fail:^{

    }];
    
}

- (IBAction)cleanCacheBtnClick:(id)sender {
    [ZRFileManager deleteFileWithPath:self.fileDir succ:^{
        [self reloadData];
    } fail:^{
        
    }];
}

@end
