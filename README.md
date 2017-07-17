# MKPageView
自己封装的一个很好用的pageView，类似网易新闻~~~

使用方式


    self.automaticallyAdjustsScrollViewInsets = NO;//注意：如果有导航控制器一定要加这一句，否则，标题栏则不能正确显示位置
    
    NSMutableArray *vcArray = [NSMutableArray array];
    for (NSInteger i = 0; i < 7; i++) {
        UIViewController *vc = [[UIViewController alloc]init];
        vc.view.backgroundColor = [self getRandomColor];
        [vcArray addObject:vc];
    }
    MKPageViewStyle *pageViewStyle = [[MKPageViewStyle alloc]init];
    pageViewStyle.titleViewH = 44.;
    
    NSArray *titleArray = @[@"热点",@"国际新闻",@"国内新闻",@"体育",@"国际新闻A",@"国内新闻A",@"体育A"];
    
    MKPageView *pageView = [[MKPageView alloc]initWithFrame:CGRectMake(0, 64, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height - 64) pageViewStyle:pageViewStyle titleArray:titleArray controllerArray:vcArray parentVc:self];
    [self.view addSubview:pageView];


![image](https://github.com/MikeWang1010/MKPageView/blob/master/pageView.png)
