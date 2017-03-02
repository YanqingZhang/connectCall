//
//  AboutAppViewController.m
//  SmartCity
//
//  Created by 维世投资 on 16/3/15.
//  Copyright © 2016年 维世投资. All rights reserved.
//

#import "AboutAppViewController.h"
#import "SubmitIdeaViewController.h"

@interface AboutAppViewController ()<UIAlertViewDelegate>{
    NSString * mianze;
    UIView* myAlert;
}

@property (weak, nonatomic) IBOutlet UILabel *versionLable;
@end

@implementation AboutAppViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"关于爱互助";
    
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    CFShow((__bridge CFTypeRef)(infoDictionary));
    // app版本
    NSString *app_Version = [infoDictionary objectForKey:@"CFBundleShortVersionString"];
    _versionLable.text = [NSString stringWithFormat:@"v%@",app_Version];
    
    mianze = [NSString stringWithFormat:@"1、	访问、浏览或使用爱互助软件，以下统称“爱互助”，表明您已阅读、理解并同意本条款。\n\n2、	不论在何种情况下，爱互助对由于信息网络设备维护、信息网络连接故障、智能终端、通讯或其他系统的故障、其他不可抗力或第三方的不作为而造成的不能服务或延迟服务不承担责任。\n\n3、	无论在任何情况下（包括但不限于疏忽原因），由于使用爱互助上的信息或由爱互助平台链接的信息，或其他与爱互助平台链接的网站信息，对您或他人所造成任何的损失或伤害（包括直接、间接、特别或后果性的损失或损害，例如收入或利润之损失，智能终端系统之损坏或数据丢失等后果），均由使用者自行承担责任（包括但不限于疏忽责任）。\n\n4、	爱互助所载的信息，包括但不限于文本、图片、语音、数据、观点、网页或链接，虽然力图准确和详尽，但爱互助并不就其所包含的信息和内容的准确、完整、充分和可靠性做任何承诺。爱互助表明不对这些信息和内容的错误或遗漏承担责任，也不对这些信息和内容作出任何明示或默示、包括但不限于没有侵犯第三方权利、质量和没有智能终端病毒的保证。\n\n5、	爱互助只是为从事为老服务的双方提供了一平台，并不涉及双方具体的服务事项，若出现任何非本软件故障导致的纠纷和事故，由双方自行承担全部责任。\n\n6、	本声明未涉及的问题请参见国家有关法律法规，当本声明与国家有关法律法规冲突时，以国家法律法规为准。\n\n7、	本软件相关声明版权及其修改权、更新权和最终解释权均属维世（上海）发展有限公司所有。"];
    [self loadSubView];
    
}
-(void)loadSubView{
    CGRect rect = CGRectMake(0, 0, SCREEN_WIDTH, 44);
    
    UILabel* lineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, CGRectGetMaxY(_versionLable.frame)+4.5, SCREEN_WIDTH, 0.5)];
    lineLable.backgroundColor = [UIColor lightGrayColor];
    [self.view addSubview:lineLable];
    
    rect.origin.y = CGRectGetMaxY(_versionLable.frame)+5;
    [self.view addSubview:[self creatItemWithFrame:rect andTitle:@"免责声明" andTag:1] ];
    rect.origin.y = CGRectGetMaxY(rect);
    [self.view addSubview:[self creatItemWithFrame:rect andTitle:@"客服电话" andTag:2] ];
    rect.origin.y = CGRectGetMaxY(rect);
    [self.view addSubview:[self creatItemWithFrame:rect andTitle:@"投诉建议" andTag:3] ];
    
        //免责声明
    myAlert = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    myAlert.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.3];
    [[[UIApplication sharedApplication]keyWindow] addSubview:myAlert];
    
    double panleWidth = SCREEN_WIDTH-20;
    double panleHeight = SCREEN_HEIGHT - 40;
    
    UITextView* textPanle = [[UITextView alloc]initWithFrame:CGRectMake(10, 20, panleWidth, panleHeight)];
    textPanle.backgroundColor = WHITE_COLOR;
    textPanle.layer.cornerRadius = 5;
    textPanle.layer.masksToBounds = YES;
    [myAlert addSubview:textPanle];
    
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, panleWidth, 40)];
    lable.font = [UIFont systemFontOfSize:16];
    lable.text = @"免责声明";
    lable.textColor = [UIColor blackColor];
    lable.textAlignment = NSTextAlignmentCenter;
    [textPanle addSubview:lable];
    
    UITextView* textView = [[UITextView alloc]initWithFrame:CGRectMake(15, 50, panleWidth-30, panleHeight-100)];
    [textPanle addSubview:textView];
    textView.editable = NO;
    
//    textView.attributedText = [[NSAttributedString alloc]initWithString:mianze];
//    textView.textAlignment = NSTextAlignmentLeft
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(50, panleHeight-45, panleWidth-100, 40)];
    [button addTarget:self action:@selector(panleHidden) forControlEvents:UIControlEventTouchUpInside];
    [button setTitle:@"确定" forState:UIControlStateNormal];
    [button setTitleColor:UIColorFromHexstring(0x51c5d4) forState:UIControlStateNormal];
    
    [textPanle addSubview:button];
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineHeightMultiple = 20.f;
    paragraphStyle.maximumLineHeight = 25.f;
    paragraphStyle.minimumLineHeight = 15.f;
    paragraphStyle.headIndent = 20.0f;
    paragraphStyle.firstLineHeadIndent = 0.f;
    paragraphStyle.alignment = NSTextAlignmentJustified;
    
    NSDictionary *attributes = @{ NSFontAttributeName:[UIFont systemFontOfSize:14], NSParagraphStyleAttributeName:paragraphStyle, NSForegroundColorAttributeName:[UIColor colorWithRed:76./255. green:75./255. blue:71./255. alpha:1]
                                  };
    textView.attributedText = [[NSAttributedString alloc]initWithString:mianze attributes:attributes];

//    textPanle.backgroundColor = [UIColor redColor];
//    button.backgroundColor = ORANGE_COLOR;
//    textView.backgroundColor = GREEN_COLOR;
    myAlert.alpha = 0.0;
    
    [textPanle bringSubviewToFront:button];
}
-(void)panleHidden{
    myAlert.alpha = 0.0;
}

-(void)introduceClick{
//    UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"免责声明" message:mianze delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil];
//    
//   [alertView show];

    myAlert.alpha = 1.0;
    
}

-(void)callWaiter{
    
    NSString* urlStr = [NSString stringWithFormat:@"tel://%@",HelpMobile];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlStr]];
}
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        [self callWaiter];
    }
}

-(void)buttonPressed:(UIButton*)sender{
    int index = (int)sender.tag;
    if (index == 1) {
        [self introduceClick];
    }else if (index == 2){
        UIAlertView* alertView = [[UIAlertView alloc]initWithTitle:@"提示" message:@"即将使用您的电话呼叫客服（4000039596），产生的费用由运营商收取，详情请咨询当地服务运营商。" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定",nil];
        [alertView show];
    }else{
        SubmitIdeaViewController* vc = [[SubmitIdeaViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}

-(UIView*)creatItemWithFrame:(CGRect)rect andTitle:(NSString*)title andTag:(int)tag{
    UIView* tempView = [[UIView alloc]initWithFrame:rect];
    tempView.backgroundColor = WHITE_COLOR;
    UILabel* lable = [[UILabel alloc]initWithFrame:CGRectMake(15, 12, SCREEN_WIDTH, 20)];
    lable.text = title;
    lable.font = [UIFont fontWithName:@"Arial-BoldItalicMT" size:15];
    lable.textAlignment = NSTextAlignmentLeft;
    [tempView addSubview:lable];
    
    UIButton* button = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = tag;
    [tempView addSubview:button];
    
    UIImageView* moreRight = [[UIImageView alloc]initWithFrame:CGRectMake(SCREEN_WIDTH-30, (rect.size.height-20)/2.0, 20, 20)];
    moreRight.image = IMAGE(@"moreRight.png");
    [tempView addSubview:moreRight];
    
    UILabel* lineLable = [[UILabel alloc]initWithFrame:CGRectMake(0, rect.size.height-0.5, SCREEN_WIDTH, 0.5)];
    lineLable.backgroundColor = [UIColor lightGrayColor];
    [tempView addSubview:lineLable];

    return tempView;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
