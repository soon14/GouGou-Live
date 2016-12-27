//
//  PlayBackViewController.m
//  GouGou-Live
//
//  Created by ma c on 16/12/25.
//  Copyright © 2016年 LXq. All rights reserved.
//

#import "PlayBackViewController.h"
// 播放器
#import "PlayerBackTopView.h"
#import "PlayerBackDownView.h"
#import <AVFoundation/AVFoundation.h>

#import "LivingCenterView.h"
#import "LivingSendMessageView.h" // 编辑弹幕信息
#import "TalkingViewController.h"
#import "ServiceViewController.h"
#import "DogShowViewController.h"
#import "SellerShowViewController.h"

@interface PlayBackViewController ()<UIScrollViewDelegate>
// 回放
{
    BOOL _isSliding; // 是否正在滑动
    NSTimer *_timer;
    id _playTimeObserver; // 观察者
    BOOL isFinish; // 播放完毕
}
#pragma mark
#pragma mark - 回放
@property (strong, nonatomic) UIView *playerView;
@property (nonatomic, strong) AVPlayerItem *playerItem; /**<  */
@property (nonatomic, strong) AVPlayerLayer *playerLayer; /**<  */
@property (nonatomic, strong) AVPlayer *playBackPlayer; /**<  */

@property (strong, nonatomic) PlayerBackTopView *topView;
@property (strong, nonatomic) UILabel *liveTitleLabel;
@property (strong, nonatomic) UIButton *playbackBtn;

@property (strong, nonatomic) PlayerBackDownView *downView;
@property (strong, nonatomic) UISlider *progressSlider;
@property (strong, nonatomic) UILabel *beginTimeLabel;
@property (strong, nonatomic) UILabel *endTimeLabel;
@property (strong, nonatomic) UIProgressView *progressView;
@property (strong, nonatomic) UIButton *playBtn;
@property (strong, nonatomic) UIButton *playscreenBtn;
@property(nonatomic, strong) TalkingViewController *talkingVc; /**< 弹窗控制器 */
/** 底部scrollview */
@property (strong, nonatomic) UIScrollView *baseScrollView;
/** 选择按钮 */
@property (strong, nonatomic) LivingCenterView *centerView;
/** 按钮名字 */
@property (strong, nonatomic) NSArray *childTitles;
/** 按钮未选中图片 */
@property (strong, nonatomic) NSArray *childNormalImages;
/** 按钮选中图片 */
@property (strong, nonatomic) NSArray *childSelectImages;

/** 子控制器 */
@property (strong, nonatomic) NSMutableArray *childVCS;
@property(nonatomic, strong) UIViewController *lastVC; /**< 上一个控制器 */

// 播放状态
@property (nonatomic, assign) BOOL isPlaying;

@property (nonatomic, strong) NSString *playBackURL; /**< 回放地址 */

@property (nonatomic, strong) UILabel *playAlert; /**< 播放提示 */

@property (nonatomic, assign) CGPoint scrollPoint; /**< 滑动位置 */
@end

@implementation PlayBackViewController
- (void)viewDidLoad {
    [super viewDidLoad];
    // 子视图
    [self makeSubVcConstraint];
    [self setNavBarItem];
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBarHidden = YES;
    // 请求直播
    
    [self getRequestPlayBackURL];
    [self playbackInitUI];
    
    // 设置直播参数
    self.liveTitleLabel.text = _liverName;
//    [self.watchLabel setTitle:_watchCount forState:(UIControlStateNormal)];
    
    //    [self collectionBtn];
    // 设置navigationBar的透明效果
    [self.navigationController.navigationBar setAlpha:0];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleBlack];
    self.hidesBottomBarWhenPushed = YES;
    
    // 请求播放信息
    //    [self getRequestLiveMessage];
    // 设置直播参数
//    self.roomNameLabel.text = _liverName;
//    [self.watchLabel setTitle:_watchCount forState:(UIControlStateNormal)];
    
    DLog(@"%@",_watchCount);
    // 添加观看观看历史
    if ([UserInfos getUser]) {
        NSDictionary *dictHistory = @{
                                      @"id":_liveID,
                                      @"user_id":[UserInfos sharedUser].ID
                                      };
        [self getRequestWithPath:API_Add_view_history params:dictHistory success:^(id successJson) {
        } error:^(NSError *error) {
            DLog(@"%@", error);
        }];
    }
    if (_isLandscape) {//横屏
        [self forceOrientationLandscapeRight];
    }
}
- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.hidesBottomBarWhenPushed = YES;
    [self.navigationController.navigationBar setAlpha:1];
    [self.navigationController.navigationBar setBarStyle:UIBarStyleDefault];
    // 取消横屏
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [self forceOrientation:UIInterfaceOrientationPortrait];
    }
    [self pause];
}

#pragma mark
#pragma mark - 回放
// 回放
- (void)getRequestPlayBackURL {
    NSDictionary *dict = @{@"live_id":_liveID};

    [self getRequestWithPath:API_PlayBack params:dict success:^(id successJson) {
        DLog(@"%@", successJson);
        NSDictionary *playInfo= [successJson[@"data"] firstObject];
        self.playBackURL = [playInfo objectForKey:@"live"];
        [self updatePlayerWithURL:[NSURL URLWithString:self.playBackURL]];
        [self play];
    } error:^(NSError *error) {
        DLog(@"%@", error);
    }];
}

#pragma mark - Action
- (AVPlayer *)playBackPlayer{
    if (!_playBackPlayer) {
        _playBackPlayer = [AVPlayer playerWithPlayerItem:_playerItem];
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:_playBackPlayer];
        _isSliding = NO;
        DLog(@"%@", NSStringFromCGRect(self.playerView.frame));
        _playerLayer.frame = self.playerView.bounds;
        [self.playerView.layer addSublayer:_playerLayer];
    }
    return _playBackPlayer;
}
- (void)updatePlayerWithURL:(NSURL *)url {
    _playerItem = [AVPlayerItem playerItemWithURL:url]; // create item
    [_playBackPlayer  replaceCurrentItemWithPlayerItem:_playerItem]; // replaceCurrentItem
    [self addObserverAndNotification]; // 添加观察者，发布通知
}

- (void)ClickBackButtonAction:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
    // 取消横屏
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
        [self forceOrientation:UIInterfaceOrientationPortrait];
    }
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
//    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
//    if (orientation == UIInterfaceOrientationLandscapeLeft || orientation == UIInterfaceOrientationLandscapeRight) {
//        self.livetopView.hidden = !self.livetopView.hidden;
//        self.livingImageView.hidden = !self.livetopView.hidden;
//        self.watchLabel.hidden = !self.livetopView.hidden;
//    }
        [UIView animateWithDuration:0.3 animations:^{
            self.topView.hidden = !self.topView.hidden;
            self.downView.hidden = !self.downView.hidden;
        }];
}
- (void)clickPlayOrPauseAction:(UIButton *)sender {
    sender.selected = !sender.selected;
    if (_isPlaying) {
        [self pause];
    } else {
        [self play];
    }
}

- (void)playerSliderTouchDown:(id)sender {
    [self pause];
}

- (void)playerSliderTouchUpInside:(id)sender {
    _isSliding = NO; // 滑动结束
    [self play];
}

// 不要拖拽的时候改变， 手指抬起来后缓冲完成再改变
- (void)playerSliderValueChanged:(id)sender {
    _isSliding = YES;
    [self pause];
    // 跳转到拖拽秒处
    CMTime changedTime = CMTimeMakeWithSeconds(self.progressSlider.value, 1.0);
    DLog(@"%.2f", self.progressSlider.value);
    [_playerItem seekToTime:changedTime completionHandler:^(BOOL finished) {
        // 跳转完成后 继续播放
        [self play];
    }];
}

//  添加观察者 、通知 、监听播放进度
- (void)addObserverAndNotification {
    [self.playerItem addObserver:self forKeyPath:@"status" options:(NSKeyValueObservingOptionNew) context:nil]; // 观察status属性， 一共有三种属性
    [self.playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil]; // 观察缓冲进度
    [self addNotification]; // 添加通知
}

// 观察播放进度
- (void)monitoringPlayback:(AVPlayerItem *)item {
    __weak typeof(self)WeakSelf = self;
    
    // 播放进度, 每秒执行30次， CMTime 为30分之一秒
    _playTimeObserver = [_playBackPlayer addPeriodicTimeObserverForInterval:CMTimeMake(1, 30.0) queue:dispatch_get_main_queue() usingBlock:^(CMTime time) {
        // 当前播放秒
        float currentPlayTime = (double)item.currentTime.value/ item.currentTime.timescale;
        // 更新slider, 如果正在滑动则不更新
        if (_isSliding == NO) {
            [WeakSelf updateVideoSlider:currentPlayTime];
        }
        isFinish = NO;
    }];
}

// 更新滑动条
- (void)updateVideoSlider:(float)currentTime {
    self.progressSlider.value = currentTime;
    self.beginTimeLabel.text = [NSString convertTime:currentTime];
}

#pragma mark 添加通知
- (void)addNotification {
    // 播放完成通知
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playbackFinished:) name:AVPlayerItemDidPlayToEndTimeNotification object:nil];
}

- (void)playbackFinished:(NSNotification *)notification {
    DLog(@"视频播放完成通知");
    _playerItem = [notification object];
    isFinish = YES;
}

#pragma mark KVO - status
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context {
    AVPlayerItem *item = (AVPlayerItem *)object;
    if ([keyPath isEqualToString:@"status"]) {
        // 判断status 的 状态
        AVPlayerItemStatus status = [[change objectForKey:@"new"] intValue]; // 获取更改后的状态
        if (status == AVPlayerStatusReadyToPlay) {
            NSLog(@"准备播放");
            // CMTime 本身是一个结构体
            CMTime duration = item.duration; // 获取视频长度
            NSLog(@"%.2f", CMTimeGetSeconds(duration));
            // 设置视频时间
            [self setMaxDuration:CMTimeGetSeconds(duration)];
            // 播放
            [self play];
            
            [self monitoringPlayback:self.playerItem]; // 监听播放
            self.playAlert.hidden = YES;
        } else if (status == AVPlayerStatusFailed) {
            DLog(@"AVPlayerStatusFailed");
            [self showAlert:@"播放失败"];
            self.playAlert.hidden = NO;
        } else {
            DLog(@"AVPlayerStatusUnknown");
        }
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        NSTimeInterval timeInterval = [self availableDurationRanges]; // 缓冲时间
        CGFloat totalDuration = CMTimeGetSeconds(_playerItem.duration); // 总时间
        [self.progressView setProgress:timeInterval / totalDuration animated:YES];
    }
}

// 设置最大时间
- (void)setMaxDuration:(CGFloat)duration {
    self.progressSlider.maximumValue = duration; // maxValue = CMGetSecond(item.duration)
    self.endTimeLabel.text = [NSString convertTime:duration];
}
// 已缓冲进度
- (NSTimeInterval)availableDurationRanges {
    NSArray *loadedTimeRanges = [_playerItem loadedTimeRanges]; // 获取item的缓冲数组
    // discussion Returns an NSArray of NSValues containing CMTimeRanges
    
    // CMTimeRange 结构体 start duration 表示起始位置 和 持续时间
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue]; // 获取缓冲区域
    float startSeconds = CMTimeGetSeconds(timeRange.start);
    float durationSeconds = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval result = startSeconds + durationSeconds; // 计算总缓冲时间 = start + duration
    return result;
}

#pragma mark - 播放 暂停
- (void)play {
    _isPlaying = YES;
    if (isFinish) {
        // 是否无限循环
        [_playerItem seekToTime:kCMTimeZero]; // 跳转到初始
    }
    [self.playBackPlayer play]; // 调用avplayer 的play方法
    DLog(@"播放");
}

- (void)pause {
    _isPlaying = NO;
    [self.playBackPlayer pause];
    DLog(@"暂停");
}

#pragma mark
#pragma mark - 回放约束
- (void)playbackInitUI {
    self.edgesForExtendedLayout = 0;
    [self.playerView bringSubviewToFront:self.topView];
    [self.playerView bringSubviewToFront:self.downView];
    
    [self.view addSubview:self.playerView];
    [self.playerView addSubview:self.topView];
    [self.topView addSubview:self.playbackBtn];
    [self.topView addSubview:self.liveTitleLabel];
    [self.playerView addSubview:self.downView];
    [self.downView addSubview:self.playBtn];
    [self.downView addSubview:self.beginTimeLabel];
    [self.downView addSubview:self.progressView];
    [self.progressView addSubview:self.progressSlider];
    [self.downView addSubview:self.endTimeLabel];
    [self.downView addSubview:self.playscreenBtn];
    [self.playerView addSubview:self.playAlert];
   
    // 提前
    [self makePlayLeacsecBackConstraints];
}
- (void)makePlayLeacsecBackConstraints {
    [self.playerView remakeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.view);
        make.top.equalTo(self.view.top);
        make.height.equalTo(245);
    }];
    [self.topView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.left.right.equalTo(self.playerView);
        make.height.equalTo(54);
    }];
    [self.playbackBtn remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY).offset(10);
        make.left.equalTo(self.topView.left).offset(20);
    }];
    [self.liveTitleLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.topView.centerY).offset(10);
        make.left.equalTo(self.topView.left).offset(40);
        make.right.equalTo(self.topView.right).offset(-20);
    }];
    [self.downView remakeConstraints:^(MASConstraintMaker *make) {
        make.bottom.left.right.equalTo(self.playerView);
        make.height.equalTo(44);
    }];
    [self.playBtn remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.centerY);
        make.left.equalTo(self.downView.left).offset(20);
    }];
    [self.beginTimeLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.centerY);
        make.left.equalTo(self.playBtn.right).offset(10);
    }];
    [self.progressView remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.centerY);
        make.left.equalTo(self.downView.left).offset(90);
        make.right.equalTo(self.downView.right).offset(-90);
    }];
    [self.progressSlider remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.centerY);
        make.left.equalTo(self.downView.left).offset(90);
        make.right.equalTo(self.downView.right).offset(-90);
    }];
    [self.playscreenBtn remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.centerY);
        make.right.equalTo(self.downView.right).offset(-10);
    }];
    [self.endTimeLabel remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(self.downView.centerY);
        make.right.equalTo(self.downView.right).offset(-40);
    }];
    [self.playAlert remakeConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.playerView.center);
    }];
}
#pragma mark - 回放控件
- (UIButton *)playscreenBtn {
    if (!_playscreenBtn) {
        _playscreenBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_playscreenBtn setImage:[UIImage imageNamed:@"缩小"] forState:(UIControlStateNormal)];
        [_playscreenBtn addTarget:self action:@selector(clickScreenButtonAction:) forControlEvents:(UIControlEventTouchDown)];
    }
    return _playscreenBtn;
}
- (UISlider *)progressSlider {
    if (!_progressSlider) {
        _progressSlider = [[UISlider alloc] init];
        _progressSlider.minimumValue = 0;
        _progressSlider.value = 0;
        [_progressSlider setThumbImage:[UIImage imageNamed:@"椭圆-7"] forState:(UIControlStateNormal)];
        
        [_progressSlider addTarget:self action:@selector(playerSliderTouchDown:) forControlEvents:(UIControlEventTouchDown)];
        [_progressSlider addTarget:self action:@selector(playerSliderTouchUpInside:) forControlEvents:(UIControlEventTouchUpInside)];
        [_progressSlider addTarget:self action:@selector(playerSliderValueChanged:) forControlEvents:(UIControlEventValueChanged)];
        
    }
    return _progressSlider;
}
- (UIProgressView *)progressView {
    if (!_progressView) {
        _progressView = [[UIProgressView alloc] initWithProgressViewStyle:(UIProgressViewStyleDefault)];
        _progressView.progress = 0;
    }
    return _progressView;
}
- (UILabel *)endTimeLabel {
    if (!_endTimeLabel) {
        _endTimeLabel = [[UILabel alloc] init];
        _endTimeLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _endTimeLabel.text = @"00:00";
        _endTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _endTimeLabel;
}
- (UILabel *)beginTimeLabel {
    if (!_beginTimeLabel) {
        _beginTimeLabel = [[UILabel alloc] init];
        _beginTimeLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _beginTimeLabel.text = @"00:00";
        _beginTimeLabel.font = [UIFont systemFontOfSize:12];
    }
    return _beginTimeLabel;
}
- (UIButton *)playBtn {
    if (!_playBtn) {
        _playBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_playBtn setImage:[UIImage imageNamed:@"播放"] forState:(UIControlStateNormal)];
        [_playBtn setImage:[UIImage imageNamed:@"暂停"] forState:(UIControlStateSelected)];
        
        [_playBtn addTarget:self action:@selector(clickPlayOrPauseAction:) forControlEvents:(UIControlEventTouchDown)];
    }
    return _playBtn;
}
- (PlayerBackDownView *)downView {
    if (!_downView) {
        _downView = [[PlayerBackDownView alloc] init];
        _downView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
    }
    return _downView;
}
- (UILabel *)liveTitleLabel {
    if (!_liveTitleLabel) {
        _liveTitleLabel = [[UILabel alloc] init];
        _liveTitleLabel.text = @"标题";
        _liveTitleLabel.textColor = [UIColor colorWithHexString:@"#ffffff"];
        _liveTitleLabel.font = [UIFont systemFontOfSize:13];
    }
    return _liveTitleLabel;
}
- (UIButton *)playbackBtn {
    if (!_playbackBtn) {
        _playbackBtn = [UIButton buttonWithType:(UIButtonTypeCustom)];
        [_playbackBtn setImage:[UIImage imageNamed:@"返回-拷贝"] forState:(UIControlStateNormal)];
        [_playbackBtn addTarget:self action:@selector(ClickBackButtonAction:) forControlEvents:(UIControlEventTouchDown)];
    }
    return _playbackBtn;
}
- (PlayerBackTopView *)topView {
    if (!_topView) {
        _topView = [[PlayerBackTopView alloc] init];
        _topView.backgroundColor = [UIColor colorWithHexString:@"#999999"];
        
    }
    return _topView;
}
- (UIView *)playerView {
    if (!_playerView) {
        _playerView = [[UIView alloc] init];
        _playerView.backgroundColor = [UIColor colorWithHexString:@"#f0f0f0"];
    }
    return _playerView;
}
- (UILabel *)playAlert {
    if (!_playAlert) {
        _playAlert = [[UILabel alloc] init];
        _playAlert.text = @"播放失败";
        _playAlert.font = [UIFont systemFontOfSize:14];
        _playAlert.hidden = YES;
        _playAlert.tintColor = [UIColor colorWithHexString:@"#ffffff"];
    }
    return _playAlert;
}
#pragma mark
#pragma mark - 回放全屏

#pragma mark
#pragma mark - ---
- (void)dealloc {
    [self removeObserveAndNOtification];
    [_playBackPlayer removeTimeObserver:_playTimeObserver]; // 移除playTimeObserver
}
- (void)removeObserveAndNOtification {
    [_playBackPlayer replaceCurrentItemWithPlayerItem:nil];
    [_playerItem removeObserver:self forKeyPath:@"status"];
    [_playerItem removeObserver:self forKeyPath:@"loadedTimeRanges"];
    [_playBackPlayer removeTimeObserver:_playTimeObserver];
    _playTimeObserver = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
// 切换横屏
- (void)forceOrientation: (UIInterfaceOrientation)orientation {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget: [UIDevice currentDevice]];
        int val = orientation;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
}
- (void)clickScreenButtonAction:(UIButton *)btn {
    UIDeviceOrientation orientation = [UIDevice currentDevice].orientation;
    if (orientation == UIInterfaceOrientationLandscapeLeft | orientation == UIInterfaceOrientationLandscapeRight) { // 转竖屏
        [self forceOrientationPriate];
    }else if (orientation == UIDeviceOrientationPortrait) { // 转横屏
        [self forceOrientationLandscapeRight];
    }
}
// 横屏转竖屏
- (void)forceOrientationPriate {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationPortrait;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    _isLandscape = YES;
    _playerLayer.frame = self.playerView.bounds;
    self.baseScrollView.hidden = NO;
    self.centerView.hidden = NO;
//    [self.playerView remakeConstraints:^(MASConstraintMaker *make) {
//        make.left.right.equalTo(self.view);
//        make.top.equalTo(self.view.top);
//        make.height.equalTo(245);
//    }];
    [self makePlayLeacsecBackConstraints];
    self.playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, 245);
}
// 竖屏转横屏
- (void)forceOrientationLandscapeRight {
    if ([[UIDevice currentDevice] respondsToSelector:@selector(setOrientation:)]) {
        SEL selector = NSSelectorFromString(@"setOrientation:");
        NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];
        [invocation setSelector:selector];
        [invocation setTarget:[UIDevice currentDevice]];
        int val = UIInterfaceOrientationLandscapeRight;
        [invocation setArgument:&val atIndex:2];
        [invocation invoke];
    }
    [UIViewController attemptRotationToDeviceOrientation];
    _isLandscape = NO;
    [self.playerView remakeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(UIEdgeInsetsMake(0, 0, 0, 0));
    }];
    _playerLayer.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);

    self.baseScrollView.hidden = YES;
    self.centerView.hidden = YES;
    
}
// 1. 设置样式
- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent; // 白色的
}
// 2. 横屏时显示 statusBar
- (BOOL)prefersStatusBarHidden {
    return NO; // 显示
}
// 3. 设置隐藏动画
- (UIStatusBarAnimation)preferredStatusBarUpdateAnimation {
    return UIStatusBarAnimationNone;
}

#pragma mark
#pragma mark - LiveAction子视图
// 子控制器约束
- (void)makeSubVcConstraint {
    [self.view addSubview:self.centerView];
    [self.view addSubview:self.baseScrollView];
    
    [self.centerView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.view.top).offset(245);
        make.size.equalTo(CGSizeMake(SCREEN_WIDTH, 45));
    }];
    
    [self.baseScrollView remakeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.centerView.bottom);
        make.left.right.bottom.equalTo(self.view);
    }];
    // 子控制器
    [self addChildViewControllers];
}
- (NSMutableArray *)childVCS {
    if (!_childVCS) {
        _childVCS = [NSMutableArray array];
        [_childVCS addObject:@"0"];
        [_childVCS addObject:@"1"];
        [_childVCS addObject:@"2"];
        [_childVCS addObject:@"3"];
    }
    return _childVCS;
}
- (void)addChildViewControllers {
    
    self.talkingVc.tableView.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - 290);
    [self.childVCS replaceObjectAtIndex:0 withObject:_talkingVc];
    [self.view addSubview:self.talkingVc.tableView];
    [self addChildViewController:_talkingVc];
    
    // 狗狗
    DogShowViewController *dogShowVC = [[DogShowViewController alloc] init];
    dogShowVC.liverIcon = self.liverIcon;
    dogShowVC.liverName = self.liverName;
    dogShowVC.liverID = _liverId;
    dogShowVC.dogInfos = self.doginfos;
    [self.childVCS replaceObjectAtIndex:1 withObject:dogShowVC];
    [self addChildViewController:dogShowVC];
    
    if (_liverId.length == 0) {
        _liverId = EaseTest_Liver;
    }
    // 客服
    ServiceViewController *serviceVC = [[ServiceViewController alloc] initWithConversationChatter:_liverId conversationType:(EMConversationTypeChat)];
    serviceVC.liverImgUrl = _liverIcon;
    serviceVC.liverName = _liverName;
    [self.childVCS replaceObjectAtIndex:2 withObject:serviceVC];
    [self addChildViewController:serviceVC];
    // 商家
    SellerShowViewController *sellerShowVC = [[SellerShowViewController alloc] init];
    sellerShowVC.liverIcon = _liverIcon;
    sellerShowVC.liverName = _liverName;
    sellerShowVC.authorId = _liverId;
    [self.childVCS replaceObjectAtIndex:3 withObject:sellerShowVC];
    [self addChildViewController:sellerShowVC];
    
    // 将子控制器的view 加载到MainVC的ScrollView上  这里用的是加载时的屏幕宽
    self.baseScrollView.contentSize = CGSizeMake([UIScreen mainScreen].bounds.size.width * self.childTitles.count, 0);
    
    // 设置contentView加载时的位置
    self.baseScrollView.contentOffset = CGPointMake(0, 0);
    
    // 减速结束加载控制器视图 代理
    self.baseScrollView.delegate = self;
    
    // 进入后第一次加载hot
    //    [self scrollViewDidEndDecelerating:self.baseScrollView];
}
- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    // 每个子控制器的宽高
    CGFloat width = self.view.frame.size.width;
    CGFloat height = self.view.frame.size.height - 290;
    
    // 偏移量 - x
    // 如果是通过点击狗狗卡片进入的,滑到狗狗位置
    //    if (_isDogCard) {
    //        [scrollView setContentOffset:CGPointMake(width, 0)];
    //    }
    CGFloat offset = scrollView.contentOffset.x;
    
    // 获取视图的索引
    NSInteger index = offset / width;
    
    //根据索引返回vc的引用
    UIViewController *childVC = self.childVCS[index];
    
    // 判断当前vc是否加载过
    if ([childVC isViewLoaded]) {
        if(![childVC isKindOfClass:[TalkingViewController class]]) {
            [self.talkingVc.tableView reloadData];
        }
        return;
    };
    
    // 给没加载过的控制器设置frame
    childVC.view.frame = CGRectMake(offset, 0, width, height);
    DLog(@"%@", NSStringFromCGRect(childVC.view.frame));
    // 添加控制器视图到contentScrollView上
    [scrollView addSubview:childVC.view];
    
#pragma mark - 隐藏键盘
    if ([self.lastVC isKindOfClass:[TalkingViewController class]]) {
        
        self.talkingVc = (TalkingViewController *)self.lastVC;
        
        [self.talkingVc.textField resignFirstResponder];
        
    }else if ([self.lastVC isKindOfClass:NSClassFromString(@"ServiceViewController")]){
        
        ServiceViewController *serviceVC = (ServiceViewController *)self.lastVC;
        
        [serviceVC.textField resignFirstResponder];
    }
    
    self.lastVC = childVC;
    self.scrollPoint = scrollView.contentOffset;
}
// 减速结束时调用 加载子控制器view的方法
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    
    // 传的调用这个代理方法的scrollview
    [self scrollViewDidEndScrollingAnimation:scrollView];
}
- (UIScrollView *)baseScrollView {
    if (!_baseScrollView) {
        _baseScrollView = [[UIScrollView alloc] initWithFrame:CGRectZero];
        _baseScrollView.scrollEnabled = NO;
        _baseScrollView.pagingEnabled = YES;
        _baseScrollView.showsVerticalScrollIndicator = NO;
    }
    return _baseScrollView;
}
- (LivingCenterView *)centerView {
    
    if (!_centerView) {
        _centerView = [[LivingCenterView alloc] init];
        
        __weak typeof(self) weakSelf = self;
        _centerView.talkBlock = ^(UIButton *btn){
            CGPoint center = CGPointMake(0 * SCREEN_WIDTH, weakSelf.baseScrollView.contentOffset.y);
            
            [weakSelf.baseScrollView setContentOffset:center animated:YES];
            return YES;
        };
        _centerView.dogBlock = ^(UIButton *btn){
            CGPoint center = CGPointMake(1 * SCREEN_WIDTH, weakSelf.baseScrollView.contentOffset.y);
            [weakSelf.baseScrollView setContentOffset:center animated:YES];
            
            return YES;
        };
        _centerView.serviceBlock = ^(UIButton *btn){
            CGPoint center = CGPointMake(2 * SCREEN_WIDTH, weakSelf.baseScrollView.contentOffset.y);
            
            [weakSelf.baseScrollView setContentOffset:center animated:YES];
            return YES;
        };
        _centerView.sellerBlock = ^(UIButton *btn){
            CGPoint center = CGPointMake(3 * SCREEN_WIDTH, weakSelf.baseScrollView.contentOffset.y);
            
            [weakSelf.baseScrollView setContentOffset:center animated:YES];
            return YES;
        };
    }
    return _centerView;
}
- (TalkingViewController *)talkingVc {
    if (!_talkingVc) {
        _talkingVc = [[TalkingViewController alloc] initWithConversationChatter:_chatRoomID conversationType:(EMConversationTypeChatRoom)];
        _talkingVc.tableView.backgroundColor = [UIColor whiteColor];
        _talkingVc.roomID = _chatRoomID;
    }
    return _talkingVc;
}

- (NSArray *)childTitles {
    if (!_childTitles) {
        _childTitles = @[@"聊天", @"狗狗", @"客服", @"认证商家"];
    }
    return _childTitles;
}
@end