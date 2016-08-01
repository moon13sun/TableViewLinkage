//
//  ViewController.m
//  TableViewLinkage
//
//  Created by leergou on 16/8/1.
//  Copyright © 2016年 WhiteHouse. All rights reserved.
//

#import "ViewController.h"

/**
 第三方框架 : Masonry
 */
//define this constant if you want to use Masonry without the 'mas_' prefix
#define MAS_SHORTHAND

//define this constant if you want to enable auto-boxing for default syntax
#define MAS_SHORTHAND_GLOBALS

// 导入头文件
#import <Masonry.h>




#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)


@interface ViewController ()<UITableViewDelegate,UITableViewDataSource,UICollectionViewDelegate,UICollectionViewDataSource>

// 顶部视图
@property (nonatomic,strong) UIView *bannerView;
// 按钮视图
@property (nonatomic,strong) UIView *buttonView;
// 两个按钮间的分割线
@property (nonatomic,strong) UIView *separatorView;
// bannerView 底部分割线
@property (nonatomic,strong) UIView *seperatorView;
// lineView --> 滚动的时候,指示条
@property (nonatomic,strong) UIView *lineView;
//第一个页面按钮
@property (nonatomic , strong) UIButton *firstPageBtn;
//第二个页面按钮
@property (nonatomic , strong) UIButton * secondPageBtn;
// collectionView的个数
@property (nonatomic , assign) NSInteger item;
// collectionView
@property (nonatomic , strong) UICollectionView * collectionView;

@end


static NSString *identifier = @"reuseCell";

@implementation ViewController



- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self setupUI];
    
    self.navigationItem.title = @"界面联动";
}

#pragma mark - 按钮点击事件
//第一个页面按钮 点击事件
- (void)firstPageBtnClick:(UIButton *)sender{
    
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:0 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}
//第二个页面按钮 点击事件
- (void)secondPageBtnClick:(UIButton *)sender{
    [self.collectionView scrollToItemAtIndexPath:[NSIndexPath indexPathForItem:1 inSection:0] atScrollPosition:UICollectionViewScrollPositionNone animated:YES];
}

#pragma mark - tableview dataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 50;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier forIndexPath:indexPath];
    if (self.item == 0) {
        
        cell.textLabel.text = [NSString stringWithFormat:@"第1个页面,第%ld行",indexPath.row + 1];
    }else{
        cell.textLabel.text = [NSString stringWithFormat:@"第二个页面,第%ld行",indexPath.row + 1];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
        cell.frame = CGRectMake(0, 0, SCREEN_WIDTH, 100);
    }
    return cell;
}

#pragma mark - collectionView dataSource
- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 2;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"collection" forIndexPath:indexPath];
    
    self.item = indexPath.item;
    
    UITableView * tableView;
    
    if (self.item == 0) {
        tableView = [[UITableView alloc]init];
    }else{
        tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        tableView.rowHeight = 60;
        tableView.sectionHeaderHeight = 20;
        tableView.sectionFooterHeight = 0;
        tableView.tableHeaderView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 0, CGFLOAT_MIN)];
    }
    
    [cell.contentView addSubview:tableView];
    
    [tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:identifier];
    tableView.dataSource = self;
    
    [tableView makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(cell.contentView);
        make.left.equalTo(cell.contentView);
        make.size.equalTo(cell.contentView.frame.size);
    }];
    return cell;
}

#pragma mark - scrollView(collectionView) delegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    CGFloat  f = self.collectionView.contentOffset.x / self.collectionView.frame.size.width;
    
    if (f > 0.5) {
        [UIView animateWithDuration:0.5 animations:^{
            
            CGFloat width = self.lineView.bounds.size.width;
            
            self.lineView.transform = CGAffineTransformMakeTranslation(SCREEN_WIDTH - width - 70, 0);
        }];
        [self.firstPageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [self.secondPageBtn  setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        
    }else{
        [UIView animateWithDuration:0.5 animations:^{
            self.lineView.transform =  CGAffineTransformIdentity;
        }];
        [self.firstPageBtn setTitleColor:[UIColor greenColor] forState:UIControlStateNormal];
        [self.secondPageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
    }
}

#pragma mark - setupUI
- (void)setupUI {
    
    // MARK: 1.添加子控件
    // bannerView
    [self.view addSubview:self.bannerView];
    // bannerView底部 分割线
    [self.view addSubview:self.seperatorView];
    // 按钮视图
    [self.view addSubview:self.buttonView];
    //第一个页面按钮
    [self.buttonView addSubview:self.firstPageBtn];
    //第二个页面按钮
    [self.buttonView addSubview:self.secondPageBtn];
    // 两个按钮之间的 分割线
    [self.buttonView addSubview:self.separatorView];
    // 滚动指示视图
    [self.view addSubview:self.lineView];
    // collectionView
    [self.view addSubview:self.collectionView];
    
    // MARK: 2.添加约束
    [self.bannerView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.view).offset(64);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(140);
        
    }];
    
    [self.seperatorView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.bannerView.mas_bottom);
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.height.mas_equalTo(2);
    }];
    
    [self.buttonView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.seperatorView.mas_bottom);
        make.height.mas_equalTo(50);
    }];
    
    [self.firstPageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.buttonView);
        make.left.mas_equalTo(self.buttonView).offset(40);
    }];
    
    [self.secondPageBtn makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.mas_equalTo(self.buttonView);
        make.right.mas_equalTo(self.buttonView).offset(-40);
    }];
    
    [self.separatorView makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.mas_equalTo(self.view);
        make.width.mas_equalTo(1);
        make.height.mas_equalTo(32);
        make.centerY.mas_equalTo(self.buttonView);
    }];
    
    [self.lineView makeConstraints:^(MASConstraintMaker *make) {
        make.top.mas_equalTo(self.buttonView.mas_bottom).offset(-1);
        make.left.mas_equalTo(self.firstPageBtn.mas_left).offset(-5);
        make.right.mas_equalTo(self.firstPageBtn.mas_right).offset(5);
        make.height.mas_equalTo(2);
    }];
    
    [self.collectionView makeConstraints:^(MASConstraintMaker *make) {
        make.leading.mas_equalTo(self.view);
        make.trailing.mas_equalTo(self.view);
        make.top.mas_equalTo(self.lineView.mas_bottom);
        make.bottom.mas_equalTo(self.view.bottom).offset(-50);
    }];
}

#pragma mark - 懒加载
- (UIView *)bannerView{
    if (!_bannerView) {
        _bannerView = [[UIView alloc]init];
        _bannerView.backgroundColor = [UIColor lightGrayColor];
    }
    return _bannerView;
}
- (UIView *)buttonView{
    if (!_buttonView) {
        _buttonView = [[UIView alloc]init];
        _buttonView.backgroundColor = [UIColor whiteColor];
    }
    return _buttonView;
}

- (UIButton *)firstPageBtn{
    if (!_firstPageBtn) {
        _firstPageBtn = [[UIButton alloc]init];
        [_firstPageBtn setTitle:@"第一个页面" forState:UIControlStateNormal];
        [_firstPageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        
        [_firstPageBtn addTarget:self action:@selector(firstPageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _firstPageBtn;
}

- (UIButton *)secondPageBtn{
    if (!_secondPageBtn) {
        _secondPageBtn = [[UIButton alloc]init];
        [_secondPageBtn setTitle:@"第二个页面" forState:UIControlStateNormal];
        [_secondPageBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [_secondPageBtn addTarget:self action:@selector(secondPageBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _secondPageBtn;
}

- (UIView *)separatorView{
    if (!_separatorView) {
        _separatorView = [[UIView alloc]init];
        _separatorView.backgroundColor = [UIColor purpleColor];
    }
    return _separatorView;
}

- (UIView *)seperatorView{
    if (!_seperatorView) {
        _seperatorView = [[UIView alloc]init];
        _seperatorView.backgroundColor = [UIColor redColor];
    }
    return _seperatorView;
}

- (UIView *)lineView{
    if (!_lineView) {
        _lineView = [[UIView alloc]init];
        _lineView.backgroundColor = [UIColor redColor];
    }
    return _lineView;
}

- (UICollectionView *)collectionView{
    if (!_collectionView) {
        
        UICollectionViewFlowLayout * flowLayou = [[UICollectionViewFlowLayout alloc]init];
        flowLayou.itemSize = CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT == 667?360:429);
        flowLayou.minimumLineSpacing = 0;
        flowLayou.minimumInteritemSpacing = 0;
        flowLayou.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _collectionView = [[UICollectionView alloc]initWithFrame:CGRectZero collectionViewLayout:flowLayou];
        _collectionView.showsVerticalScrollIndicator = NO;
        _collectionView.dataSource = self;
        _collectionView.bounces = NO;
        _collectionView.delegate = self;
        _collectionView.pagingEnabled = YES;
        [_collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"collection"];
    }
    return _collectionView;
}

@end












