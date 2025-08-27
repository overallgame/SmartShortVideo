import { VideoPlayerViewModel, VideoPlayState, VideoPlayerEvent } from '../viewModel/VideoPlayerViewModel'
import { VideoItem } from '../model/VideoModel'
import { VideoConstants } from '../constants/VideoConstants'
import { VideoUtils } from '../utils/VideoUtils'

// 视频播放器组件配置接口
interface VideoPlayerConfig {
  autoPlay?: boolean
  showControls?: boolean
  enableGesture?: boolean
  controlHideDelay?: number
}

@Component
export struct VideoPlayer {
  @Prop isFullScreen: boolean
  @Prop currentVideoIndex: number
  @Prop videoList: VideoItem[]
  // 事件回调
  onFullScreenChange?: (fullScreen: boolean) => void
  onVideoIndexChange?: (index: number) => void
  onPlayStateChange?: (state: VideoPlayState) => void
  onError?: (error: string) => void
  // 内部状态
  @State viewModel: VideoPlayerViewModel = new VideoPlayerViewModel()
  private videoController = new VideoController()
  private config: VideoPlayerConfig = {
    autoPlay: true,
    showControls: true,
    enableGesture: true,
    controlHideDelay: VideoConstants.GESTURE_CONFIG.CONTROL_HIDE_DELAY
  }

  build() {
    Stack() {
      this.VideoPlayerComponent()
      this.OverlayComponents()
    }
    .width('100%')
    .height('100%')
  }

  // 视频播放器组件
  @Builder
  VideoPlayerComponent() {
    Video({
      src: this.getCurrentVideoUrl(),
      controller: this.videoController
    })
      .width('100%')
      .height('100%')
      .objectFit(ImageFit.Cover)
      .autoPlay(this.config.autoPlay)
      .controls(false)
      .onStart(() => this.handleVideoStart())
      .onPause(() => this.handleVideoPause())
      .onError(() => this.handleVideoError())
      .onPrepared(() => this.handleVideoPrepared())
      .onFinish(() => this.handleVideoFinish())
      .onClick(() => this.handleVideoClick())
      .gesture(
        PanGesture({ fingers: 1, direction: PanDirection.Vertical })
          .onActionEnd((event: GestureEvent) => {
            const threshold = VideoConstants.GESTURE_CONFIG.SWIPE_THRESHOLD

            if (event.offsetY > threshold) {
              // 向下滑动，请求播放上一个视频
              this.viewModel.requestPreviousVideo()
            } else if (event.offsetY < -threshold) {
              // 向上滑动，请求播放下一个视频
              this.viewModel.requestNextVideo()
            }
          })
      )
  }

  // 覆盖层组件
  @Builder
  OverlayComponents() {
    // 加载状态指示器
    if (this.viewModel.playState === VideoPlayState.LOADING) {
      this.LoadingIndicator()
    }

    // 错误状态指示器
    if (this.viewModel.playState === VideoPlayState.ERROR) {
      this.ErrorIndicator()
    }

    // 播放控制按钮
    if (this.viewModel.showControls &&
      this.viewModel.playState !== VideoPlayState.LOADING &&
      this.viewModel.playState !== VideoPlayState.ERROR) {
      this.PlayControlButton()
    }

    // 全屏退出按钮
    if (this.isFullScreen) {
      this.FullScreenExitButton()
    }
  }

  // 加载指示器
  @Builder
  LoadingIndicator() {
    Stack() {
      Circle()
        .width(VideoConstants.UI_CONFIG.LOADING_INDICATOR_SIZE)
        .height(VideoConstants.UI_CONFIG.LOADING_INDICATOR_SIZE)
        .fill(VideoConstants.COLORS.LOADING_BACKGROUND)

      Text('加载中...')
        .fontSize(16)
        .fontColor($r('sys.color.comp_background_list_card'))
    }
    .position({ x: '50%', y: '50%' })
    .translate({
      x: -VideoConstants.UI_CONFIG.LOADING_INDICATOR_SIZE / 2,
      y: -VideoConstants.UI_CONFIG.LOADING_INDICATOR_SIZE / 2
    })
  }

  // 错误指示器
  @Builder
  ErrorIndicator() {
    Stack() {
      Circle()
        .width(VideoConstants.UI_CONFIG.LOADING_INDICATOR_SIZE)
        .height(VideoConstants.UI_CONFIG.LOADING_INDICATOR_SIZE)
        .fill(VideoConstants.COLORS.ERROR_BACKGROUND)

      Text(VideoUtils.getErrorMessage('PLAY_FAILED'))
        .fontSize(16)
        .fontColor($r('sys.color.comp_background_list_card'))
    }
    .position({ x: '50%', y: '50%' })
    .translate({
      x: -VideoConstants.UI_CONFIG.LOADING_INDICATOR_SIZE / 2,
      y: -VideoConstants.UI_CONFIG.LOADING_INDICATOR_SIZE / 2
    })
    .onClick(() => this.handleRetryClick())
  }

  // 播放控制按钮
  @Builder
  PlayControlButton() {
    Stack() {
      Circle()
        .width(VideoConstants.UI_CONFIG.CONTROL_BUTTON_SIZE)
        .height(VideoConstants.UI_CONFIG.CONTROL_BUTTON_SIZE)
        .fill(VideoConstants.COLORS.OVERLAY_BACKGROUND)

      Text(VideoUtils.getPlayStateIcon(this.viewModel.playState))
        .fontSize(40)
        .fontColor($r('sys.color.comp_background_list_card'))
    }
    .position({ x: '50%', y: '50%' })
    .translate({
      x: -VideoConstants.UI_CONFIG.CONTROL_BUTTON_SIZE / 2,
      y: -VideoConstants.UI_CONFIG.CONTROL_BUTTON_SIZE / 2
    })
    .onClick(() => this.handlePlayButtonClick())
  }

  // 全屏退出按钮
  @Builder
  FullScreenExitButton() {
    Row() {
      Image($r('app.media.background'))
        .width(VideoConstants.UI_CONFIG.FULLSCREEN_BUTTON_SIZE)
        .height(VideoConstants.UI_CONFIG.FULLSCREEN_BUTTON_SIZE)
        .fillColor($r('sys.color.comp_background_list_card'))
      Text('退出全屏')
        .fontSize(14)
        .fontColor($r('sys.color.comp_background_list_card'))
        .margin({ left: VideoConstants.UI_CONFIG.PADDING.SMALL })
    }
    .backgroundColor(VideoConstants.COLORS.FULLSCREEN_BACKGROUND)
    .padding({
      left: VideoConstants.UI_CONFIG.PADDING.MEDIUM,
      right: VideoConstants.UI_CONFIG.PADDING.MEDIUM,
      top: VideoConstants.UI_CONFIG.PADDING.SMALL,
      bottom: VideoConstants.UI_CONFIG.PADDING.SMALL
    })
    .borderRadius(VideoConstants.UI_CONFIG.BORDER_RADIUS)
    .position({
      x: VideoConstants.UI_CONFIG.PADDING.LARGE,
      y: VideoConstants.UI_CONFIG.PADDING.LARGE
    })
    .onClick(() => this.handleFullScreenExit())
  }

  // 事件处理方法
  private handleVideoStart(): void {
    this.viewModel.setPlayState(VideoPlayState.PLAYING)
  }

  private handleVideoPause(): void {
    this.viewModel.setPlayState(VideoPlayState.PAUSED)
  }

  private handleVideoError(): void {
    console.error('视频播放出错')
    this.viewModel.setPlayState(VideoPlayState.ERROR)
  }

  private handleVideoPrepared(): void {
    this.viewModel.setPlayState(VideoPlayState.PLAYING)
  }

  private handleVideoFinish(): void {
    this.viewModel.setPlayState(VideoPlayState.FINISHED)
    this.viewModel.requestNextVideo()
  }

  private handleVideoClick(): void {
    this.viewModel.togglePlay(this.videoController)
  }

  private handlePlayButtonClick(): void {
    this.viewModel.togglePlay(this.videoController)
  }

  private handleRetryClick(): void {
    this.viewModel.setPlayState(VideoPlayState.LOADING)
    this.videoController.start()
  }

  private handleFullScreenExit(): void {
    this.onFullScreenChange?.(false)
  }

  // 辅助方法
  private getCurrentVideoUrl(): string {
    if (this.videoList.length === 0 ||
      this.currentVideoIndex < 0 ||
      this.currentVideoIndex >= this.videoList.length) {
      return ''
    }
    const currentVideo = this.videoList[this.currentVideoIndex]
    return currentVideo?.url || ''
  }

  private initializeViewModel(): void {
    // 设置事件处理器
    const eventHandlers: VideoPlayerEvent = {
      onPlayStateChange: (state: VideoPlayState) => {
        console.log(`播放状态变化: ${VideoUtils.getPlayStateText(state)}`)
        this.onPlayStateChange?.(state)
      },
      onError: (error: string) => {
        console.error(`视频播放错误: ${error}`)
        this.onError?.(error)
      },
      onVideoRequestChange: (direction: 'next' | 'previous' | 'specific', index?: number) => {
        console.log(`视频切换请求: ${direction}${index !== undefined ? `, 索引: ${index}` : ''}`)

        let newIndex: number
        if (direction === 'next') {
          newIndex = (this.currentVideoIndex + 1) % this.videoList.length
        } else if (direction === 'previous') {
          newIndex = this.currentVideoIndex === 0
            ? this.videoList.length - 1
            : this.currentVideoIndex - 1
        } else {
          newIndex = index || 0
        }

        // 通知父组件视频索引变化
        this.onVideoIndexChange?.(newIndex)
      }
    }

    this.viewModel.setEventHandlers(eventHandlers)
  }

  private syncExternalState(): void {
    if (this.isFullScreen !== this.viewModel.isFullScreen) {
      this.viewModel.setFullScreen(this.isFullScreen)
    }
  }

  aboutToAppear() {
    this.initializeViewModel()
    this.syncExternalState()
  }

  aboutToUpdate() {
    this.syncExternalState()
  }

  aboutToDisappear() {
    this.viewModel.destroy()
  }
}