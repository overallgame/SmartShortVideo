import { VideoItem } from '../model/VideoModel'
import { UIConstants } from '../constants/UIConstants'
import { VideoConstants } from '../constants/VideoConstants'

// 视频覆盖层配置接口
interface OverlayConfig {
  showFullScreenButton?: boolean
  showProgressBar?: boolean
  showTimeDisplay?: boolean
}

@Component
export struct VideoOverlay {
  justifyContent() {
    throw new Error('Method not implemented.')
  }
  // 外部属性
  @Prop currentVideo: VideoItem | null
  @Prop isFullScreen: boolean
  // 事件回调
  onFullScreenChange?: (fullScreen: boolean) => void
  onProgressChange?: (progress: number) => void
  // 内部状态
  private config: OverlayConfig = {
    showFullScreenButton: true,
    showProgressBar: false,
    showTimeDisplay: false
  }

  build() {
    Column() {
      if (this.config.showFullScreenButton && !this.isFullScreen) {
        this.FullScreenButton()
      }

      if (this.config.showProgressBar) {
        this.ProgressBar()
      }

      if (this.config.showTimeDisplay) {
        this.TimeDisplay()
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.End)
    .alignItems(HorizontalAlign.Center)
  }

  // 全屏按钮
  @Builder
  FullScreenButton() {
    Row() {
      Image($r('app.media.background'))
        .width(VideoConstants.UI_CONFIG.FULLSCREEN_BUTTON_SIZE)
        .height(VideoConstants.UI_CONFIG.FULLSCREEN_BUTTON_SIZE)
        .fillColor(UIConstants.COLORS.TEXT_PRIMARY)

      Text('全屏观看')
        .fontSize(UIConstants.DESCRIPTION_CONFIG.TITLE_FONT_SIZE)
        .fontColor(UIConstants.COLORS.TEXT_PRIMARY)
        .margin({ left: UIConstants.LAYOUT_CONFIG.PADDING.MEDIUM })
    }
    .backgroundColor(UIConstants.COLORS.OVERLAY_BACKGROUND)
    .padding({
      left: UIConstants.LAYOUT_CONFIG.PADDING.MEDIUM,
      right: UIConstants.LAYOUT_CONFIG.PADDING.MEDIUM,
      top: UIConstants.LAYOUT_CONFIG.PADDING.SMALL,
      bottom: UIConstants.LAYOUT_CONFIG.PADDING.SMALL
    })
    .borderRadius(UIConstants.LAYOUT_CONFIG.BORDER_RADIUS.MEDIUM)
    .onClick(() => this.handleFullScreenClick())
  }

  // 进度条
  @Builder
  ProgressBar() {
    Row() {
      Progress({
        value: 0,
        total: 100,
        type: ProgressType.Linear
      })
        .width('100%')
        .height(4)
        .color(UIConstants.COLORS.PRIMARY)
        .backgroundColor(UIConstants.COLORS.TEXT_SECONDARY)
        .borderRadius(2)
    }
    .margin({ bottom: UIConstants.LAYOUT_CONFIG.PADDING.MEDIUM })
  }

  // 时间显示
  @Builder
  TimeDisplay() {
    Row() {
      Text('00:00')
        .fontSize(UIConstants.DESCRIPTION_CONFIG.TITLE_FONT_SIZE)
        .fontColor(UIConstants.COLORS.TEXT_PRIMARY)

      Text(' / ')
        .fontSize(UIConstants.DESCRIPTION_CONFIG.TITLE_FONT_SIZE)
        .fontColor(UIConstants.COLORS.TEXT_SECONDARY)

      Text('00:00')
        .fontSize(UIConstants.DESCRIPTION_CONFIG.TITLE_FONT_SIZE)
        .fontColor(UIConstants.COLORS.TEXT_PRIMARY)
    }
    .backgroundColor(UIConstants.COLORS.OVERLAY_BACKGROUND)
    .padding({
      left: UIConstants.LAYOUT_CONFIG.PADDING.MEDIUM,
      right: UIConstants.LAYOUT_CONFIG.PADDING.MEDIUM,
      top: UIConstants.LAYOUT_CONFIG.PADDING.SMALL,
      bottom: UIConstants.LAYOUT_CONFIG.PADDING.SMALL
    })
    .borderRadius(UIConstants.LAYOUT_CONFIG.BORDER_RADIUS.SMALL)
  }

  // 事件处理方法
  private handleFullScreenClick(): void {
    this.onFullScreenChange?.(true)
    console.log('VideoOverlay: 全屏按钮点击')
  }

  // 生命周期方法
  aboutToAppear() {
    console.log('VideoOverlay: 组件初始化')
  }

  aboutToUpdate() {
    if (!this.currentVideo) {
      console.warn('VideoOverlay: 视频数据无效')
    }
  }
}