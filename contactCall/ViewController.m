//
//  ViewController.m
//  contactCall
//
//  Created by 维世投资 on 16/5/6.
//  Copyright © 2016年 张彦青. All rights reserved.
//

#import "ViewController.h"
#import <AddressBook/AddressBook.h>
#import "PeopleModel.h"
//#import "AboutAppViewController.h"

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height)

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate,UIScrollViewDelegate>{
    NSMutableArray* tableDataSource;
   ABAddressBookRef addBook;
    UIButton *showNumPadButton;
    
    CGRect halfRect;
    CGRect fullRect;
    
    //搜索
}

@property (strong, nonatomic) IBOutlet UIView *bottomView;
@property (weak, nonatomic) IBOutlet UILabel *displayLable;
@property (strong, nonatomic) UITableView *tableView;


@property (nonatomic,retain) NSMutableDictionary *contactDic;
@property (nonatomic,retain) NSMutableArray *searchByName;
@property (nonatomic,retain) NSMutableArray *searchByPhone;

@end

@implementation ViewController

-(void)about{
    
}

#pragma mark --- 搜索
- (void)search {
    [[SearchCoreManager share] SearchWithFunc:KDailSearchFunction searchText:_displayLable.text searchArray:nil nameMatch:_searchByName phoneMatch:_searchByPhone];

    [self.tableView reloadData];
}

-(void)initData{
    
    NSMutableDictionary *dic = [[NSMutableDictionary alloc] init];
    self.contactDic = dic;//搜索库
    
    NSMutableArray *nameIDArray = [[NSMutableArray alloc] init];
    self.searchByName = nameIDArray;//搜索字段
    
    NSMutableArray *phoneIDArray = [[NSMutableArray alloc] init];
    self.searchByPhone = phoneIDArray;//搜索字段
    
    //添加到搜索库
    for (int i = 1; i < tableDataSource.count; i ++) {
        PeopleModel* apeople = tableDataSource[i];
        [[SearchCoreManager share] AddContact:apeople.localID name:apeople.name phone:apeople.phoneArray];
        [self.contactDic setObject:apeople forKey:apeople.localID];
    }
    [_tableView reloadData];
}

-(void)hiddenNumberPad{
    _tableView.frame = fullRect;
    showNumPadButton.hidden = NO;
    _bottomView.hidden = YES;
    [self.view bringSubviewToFront:showNumPadButton];
}
-(void)showNumberPad{
    _tableView.frame = halfRect;
    showNumPadButton.hidden = YES;
    _bottomView.hidden = NO;
    [self.view bringSubviewToFront:_bottomView];
}

- (IBAction)keyClick:(id)sender {
    UIButton* button = (UIButton*)sender;
    int tagIndex = (int)button.tag;
    
    if (tagIndex == 97) {
        [self hiddenNumberPad];
        return;
    }else if (tagIndex == 99){//退格
        [self backSpace];
        return;
    }else if (tagIndex == 98){
        NSString* urlStr = [NSString stringWithFormat:@"tel://%@",_displayLable.text];
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];//呼叫显示号码
        return;
    }else if (tagIndex == 11){//*
        self.displayLable.text = [NSString stringWithFormat:@"%@*",self.displayLable.text];
    }else if (tagIndex == 12){
        self.displayLable.text = [NSString stringWithFormat:@"%@#",self.displayLable.text];
    }else{
        self.displayLable.text = [NSString stringWithFormat:@"%@%d",self.displayLable.text,tagIndex];
    }
    [self search];
}

-(void)backSpace{
    NSString* str = _displayLable.text;
    if (str.length>=2) {
        _displayLable.text = [str substringToIndex:str.length-1];
           [self search];

    }else if(str.length >0){
        _displayLable.text = @"";
        [self search];
        
    }else{
        return;
    }

}
-(void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self hiddenNumberPad];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
    _tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_displayLable.superview.frame), SCREEN_WIDTH, SCREEN_HEIGHT-300-CGRectGetMaxY(_displayLable.superview.frame))];
    _tableView.delegate = self;
    _tableView.dataSource = self;
    [self.view addSubview:_tableView];
    
    _bottomView = [[UIView alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-300, SCREEN_WIDTH, 300)];
    _bottomView.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:_bottomView];
    
    UIButton* about = [[UIButton alloc]initWithFrame:CGRectMake(10, 5, 60, 40)];
    [about setTitle:@"关于" forState:UIControlStateNormal];
    [about addTarget:self action:@selector(about) forControlEvents:UIControlEventTouchUpInside];
    
    showNumPadButton = [[UIButton alloc]initWithFrame:CGRectMake(SCREEN_WIDTH/2-30, SCREEN_HEIGHT-80, 60, 60)];
    showNumPadButton.backgroundColor = UIColorFromHexstring(0x9acd32);
    showNumPadButton.layer.cornerRadius = 30;
    showNumPadButton.layer.masksToBounds = YES;
    UIImageView* imageView = [[UIImageView alloc]initWithFrame:CGRectMake(15, 15, 30, 30)];
    imageView.image = [UIImage imageNamed:@"keypad"];
    [showNumPadButton addSubview:imageView];
    [showNumPadButton addTarget:self action:@selector(showNumberPad) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:showNumPadButton];
    showNumPadButton.hidden = YES;
    
    tableDataSource = [[NSMutableArray alloc]init];
    addBook = nil;
    
    [self addBottom];//添加自己的数字键盘

    self.view.backgroundColor = [UIColor colorWithRed:239/255.0f green:1 blue:206.0/255.0f alpha:1];
    _tableView.backgroundColor = [UIColor colorWithRed:239/255.0f green:1 blue:206.0/255.0f alpha:1];
    
}

-(void)famtterViewSize{

    halfRect = _tableView.frame;
    halfRect.size.height = _bottomView.frame.origin.y - halfRect.origin.y + 10;
    
    fullRect = halfRect;
    fullRect.size.height = SCREEN_HEIGHT-halfRect.origin.y;
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    
    [self famtterViewSize];
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
  
    [self getDataFromSystemAccess];
}

-(void)creatAButtonWithFrame:(CGRect)frame andTitle:(NSString*)title andSubTitle:(NSString*)subtitle andTag:(int)tag{
    UIButton*  button = [[UIButton alloc]initWithFrame:frame];
    button.tag = tag;
    
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 3, SCREEN_WIDTH/3, 40)];
    if ([title isEqualToString:@"隐藏"]) {
        CGRect rect = button.bounds;
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width/2-15, rect.size.height/2-10, 30, 20)];
        imageV.image = [UIImage imageNamed:@"keypad_hide"];
        [button addSubview:imageV];
    }else if ([title isEqualToString:@"回退"]) {
        CGRect rect = button.bounds;
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width/2-17, rect.size.height/2-10, 34, 20)];
        imageV.image = [UIImage imageNamed:@"backspace"];
        [button addSubview:imageV];
        
        UILongPressGestureRecognizer* lgp = [[UILongPressGestureRecognizer alloc]initWithTarget:self action:@selector(longPress)];
        [button addGestureRecognizer:lgp];
        
    }else if ([title isEqualToString:@"拨号"]) {
        CGRect rect = button.bounds;
        UIImageView* imageV = [[UIImageView alloc]initWithFrame:CGRectMake(rect.size.width/2-25, rect.size.height/2-25, 50, 50)];
        imageV.image = [UIImage imageNamed:@"call"];
        [button addSubview:imageV];
    }else{
        lable.text = title;
    }
    
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor blackColor];
    lable.font = [UIFont systemFontOfSize:30];
    [button addSubview:lable];
    
    lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 42, SCREEN_WIDTH/3, 10)];
    lable.text = subtitle;
    lable.textAlignment = NSTextAlignmentCenter;
    lable.textColor = [UIColor grayColor];
    lable.font = [UIFont systemFontOfSize:12];
    [button addSubview:lable];
    [button addTarget:self action:@selector(keyClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [_bottomView addSubview:button];

}

-(void)longPress{
    _displayLable.text = @"";
    [self search];
}

-(void)addBottom{
    double offset = 5;
    NSArray* array = [NSArray arrayWithObjects:
                      @"1",@"2", @"3",@"4",@"5",@"6",@"7", @"8",@"9",nil];
    NSArray* arraySub = [NSArray arrayWithObjects:
                      @"",@"ABC", @"DEF",@"GHI",@"JKL",@"MNO",@"PQRS", @"TUV",@"WXYZ",nil];
    for (int i = 0; i<9; i++) {
        [self creatAButtonWithFrame:CGRectMake((i%3)*SCREEN_WIDTH/3, (i/3)*60+offset, SCREEN_WIDTH/3, 60) andTitle:array[i] andSubTitle:arraySub[i] andTag:i+1];
    }
    
    [self creatAButtonWithFrame:CGRectMake(0, 180+offset, SCREEN_WIDTH/3, 50) andTitle:@"*" andSubTitle:@"" andTag:11];
    
    [self creatAButtonWithFrame:CGRectMake(SCREEN_WIDTH/3, 180+offset, SCREEN_WIDTH/3, 50) andTitle:@"0" andSubTitle:@"+" andTag:0];
    
    [self creatAButtonWithFrame:CGRectMake(2*SCREEN_WIDTH/3, 180 +offset, SCREEN_WIDTH/3, 50) andTitle:@"#" andSubTitle:@"" andTag:12];
    
    [self creatAButtonWithFrame:CGRectMake(0, 240+offset , SCREEN_WIDTH/3, 50) andTitle:@"隐藏" andSubTitle:@"" andTag:97];
    
    [self creatAButtonWithFrame:CGRectMake(SCREEN_WIDTH/3, 240+offset, SCREEN_WIDTH/3, 50) andTitle:@"拨号" andSubTitle:@"" andTag:98];
    
    [self creatAButtonWithFrame:CGRectMake(2*SCREEN_WIDTH/3, 240+offset, SCREEN_WIDTH/3, 50) andTitle:@"回退" andSubTitle:@"" andTag:99];
    
}

-(void)getDataFromSystemAccess{
    int __block tip=0;
    //声明一个通讯簿的引用
    
    //因为在IOS6.0之后和之前的权限申请方式有所差别，这里做个判断
    if ([[UIDevice currentDevice].systemVersion floatValue]>=6.0) {
        //创建通讯簿的引用
        addBook=ABAddressBookCreateWithOptions(NULL, NULL);
        //创建一个出事信号量为0的信号
        dispatch_semaphore_t sema=dispatch_semaphore_create(0);
        //申请访问权限
        ABAddressBookRequestAccessWithCompletion(addBook, ^(bool greanted, CFErrorRef error)        {
            //greanted为YES是表示用户允许，否则为不允许
            if (!greanted) {
                tip=1;
            }else{
                [self getContectFromSystem];
            }
            //发送一次信号
            dispatch_semaphore_signal(sema);
        });
        //等待信号触发
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }else{
        //IOS6之前
        addBook =ABAddressBookCreate();
    }
    if (tip) {
        //做一个友好的提示
        UIAlertView * alart = [[UIAlertView alloc]initWithTitle:@"温馨提示" message:@"请您设置允许APP访问您的通讯录\nSettings>General>Privacy" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alart show];
        
        return;
    }
}

-(void)getContectFromSystem{
    //获取所有联系人的数组
    CFArrayRef allLinkPeople = ABAddressBookCopyArrayOfAllPeople(addBook);
    //获取联系人总数
    CFIndex number = ABAddressBookGetPersonCount(addBook);
    //进行遍历
    for (NSInteger i=0; i<number; i++) {
        //获取联系人对象的引用
        ABRecordRef  people = CFArrayGetValueAtIndex(allLinkPeople, i);
        //获取当前联系人名字
        NSString*firstName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonFirstNameProperty));
        //获取当前联系人姓氏
        NSString*lastName=(__bridge NSString *)(ABRecordCopyValue(people, kABPersonLastNameProperty));

        if (!lastName) {
            lastName = @"";
        }
        if (!firstName) {
            firstName = @"";
        }

        NSMutableArray * phoneArr = [[NSMutableArray alloc]init];
        ABMultiValueRef phones= ABRecordCopyValue(people, kABPersonPhoneProperty);
        for (NSInteger j=0; j<ABMultiValueGetCount(phones); j++) {
            [phoneArr addObject:(__bridge NSString *)(ABMultiValueCopyValueAtIndex(phones, j))];
        }
        
        NSString* name =  [NSString stringWithFormat:@"%@%@",lastName,firstName];

        [tableDataSource addObject:[PeopleModel instanceWithName:name andLocalID:[NSNumber numberWithInt:i] andPhoneArray:phoneArr]];
    }
    
    [self initData];//初始化search数据源
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.displayLable.text length] <= 0) {
        return [self.contactDic count];
    } else {
        return [self.searchByName count] + [self.searchByPhone count];
    }
}
-(UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indentifier = @"Cell";
    UITableViewCell *cell = (UITableViewCell*)[_tableView dequeueReusableCellWithIdentifier:indentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:indentifier] ;
        cell.selectionStyle=UITableViewCellSelectionStyleBlue;
    }
    
    if ([self.displayLable.text length] <= 0) {
        PeopleModel *contact = [[self.contactDic allValues] objectAtIndex:indexPath.row];
        cell.textLabel.text = contact.name;
        if (contact.phoneArray.count > 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ ···",contact.phoneArray.firstObject];
        }else if (contact.phoneArray.count == 1) {
            cell.detailTextLabel.text = [NSString stringWithFormat:@"%@",contact.phoneArray.firstObject];
        }else{
            cell.detailTextLabel.text = @"";
        }

        cell.contentView.backgroundColor = [UIColor colorWithRed:239/255.0f green:1 blue:206.0/255.0f alpha:1];
        return cell;
    }
    
    NSNumber *localID = nil;
    NSMutableString *matchString = [NSMutableString string];
    NSMutableArray *matchPos = [NSMutableArray array];
    if (indexPath.row < [self.searchByName count]) {
        localID = [self.searchByName objectAtIndex:indexPath.row];
        
        //姓名匹配 获取对应匹配的拼音串 及高亮位置
        if ([self.displayLable.text length]) {
            [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
        }
    } else {
        localID = [self.searchByPhone objectAtIndex:indexPath.row-[self.searchByName count]];
        NSMutableArray *matchPhones = [NSMutableArray array];
        
        //号码匹配 获取对应匹配的号码串 及高亮位置
        if ([self.displayLable.text length]) {
            [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
            [matchString appendString:[matchPhones objectAtIndex:0]];
        }
    }
    PeopleModel *contact = [self.contactDic objectForKey:localID];
    
    cell.textLabel.text = contact.name;
    cell.detailTextLabel.text = matchString;
    cell.contentView.backgroundColor = [UIColor colorWithRed:239/255.0f green:1 blue:206.0/255.0f alpha:1];
    return cell;

}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    
    PeopleModel *contact;
    if ([self.displayLable.text length] <= 0) {
        contact = [[self.contactDic allValues] objectAtIndex:indexPath.row];
        
    }else{
        
        NSNumber *localID = nil;
        NSMutableString *matchString = [NSMutableString string];
        NSMutableArray *matchPos = [NSMutableArray array];
        if (indexPath.row < [self.searchByName count]) {
            localID = [self.searchByName objectAtIndex:indexPath.row];
            
            //姓名匹配 获取对应匹配的拼音串 及高亮位置
            if ([self.displayLable.text length]) {
                [[SearchCoreManager share] GetPinYin:localID pinYin:matchString matchPos:matchPos];
            }
        } else {
            localID = [self.searchByPhone objectAtIndex:indexPath.row-[self.searchByName count]];
            NSMutableArray *matchPhones = [NSMutableArray array];
            
            //号码匹配 获取对应匹配的号码串 及高亮位置
            if ([self.displayLable.text length]) {
                [[SearchCoreManager share] GetPhoneNum:localID phone:matchPhones matchPos:matchPos];
                [matchString appendString:[matchPhones objectAtIndex:0]];
            }
        }
        contact = [self.contactDic objectForKey:localID];
    }
    
    if (indexPath.row%3 == 0) {
        NSString* urlStr = [NSString stringWithFormat:@"tel://%@",contact.phoneArray.firstObject];
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
    }else if (indexPath.row%3 == 1){
        NSString *num = [[NSString alloc] initWithFormat:@"telprompt://%@",contact.phoneArray.firstObject]; //而这个方法则打电话前先弹框  是否打电话 然后打完电话之后回到程序中 网上说这个方法可能不合法 无法通过审核
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:num]]; //拨号
    }else{
        NSURL *phoneURL = [NSURL URLWithString:[NSString stringWithFormat:@"tel:%@",contact.phoneArray.firstObject]];
        
        
        UIWebView* phoneCallWebView = [[UIWebView alloc] initWithFrame:CGRectZero];// 这个webView只是一个后台的容易 不需要add到页面上来  效果跟方法二一样 但是这个方法是合法的
        
        [phoneCallWebView loadRequest:[NSURLRequest requestWithURL:phoneURL]];

    }
}
@end
