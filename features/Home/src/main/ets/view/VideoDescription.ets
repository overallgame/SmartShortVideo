import { VideoItem } from '../model/VideoModel'
import { UIConstants } from '../constants/UIConstants'
import { UIUtils } from '../utils/UIUtils'

// 视频描述配置接口
interface DescriptionConfig {
  showAuthor?: boolean
  showTitle?: boolean
  maxTitleLines?: number
  enableTruncation?: boolean
  showBackground?: boolean
}

@Component
export struct VideoDescription {
  // 外部属性
  @Prop currentVideo: VideoItem | null
  // 事件回调
  onAuthorClick?: () => void
  onTitleClick?: () => void
  // 内部状态
  private config: DescriptionConfig = {
    showAuthor: true,
    showTitle: true,
    maxTitleLines: UIConstants.DESCRIPTION_CONFIG.MAX_LINES,
    enableTruncation: true,
    showBackground: true
  }

  build() {
    Column() {
      if (this.config.showAuthor) {
        this.AuthorSection()
      }

      if (this.config.showTitle) {
        this.TitleSection()
      }
    }
    .width('100%')
    .padding({
      left: UIConstants.DESCRIPTION_CONFIG.PADDING.LEFT,
      right: UIConstants.DESCRIPTION_CONFIG.PADDING.RIGHT,
      bottom: UIConstants.DESCRIPTION_CONFIG.PADDING.BOTTOM
    })
    .alignItems(HorizontalAlign.Start)
  }

  // 作者信息区域
  @Builder
  AuthorSection() {
    Row() {
      Text(this.getAuthorText())
        .fontSize(UIConstants.DESCRIPTION_CONFIG.AUTHOR_FONT_SIZE)
        .fontColor(UIConstants.COLORS.TEXT_PRIMARY)
        .fontWeight(FontWeight.Medium)
        .onClick(() => this.handleAuthorClick())
    }
    .margin({ bottom: UIConstants.LAYOUT_CONFIG.PADDING.MEDIUM })

  }

  // 标题区域
  @Builder
  TitleSection() {
    Text(this.getTitleText())
      .fontSize(UIConstants.DESCRIPTION_CONFIG.TITLE_FONT_SIZE)
      .fontColor(UIConstants.COLORS.TEXT_PRIMARY)
      .textAlign(TextAlign.Start)
      .maxLines(this.config.maxTitleLines)
      .textOverflow({ overflow: TextOverflow.Ellipsis })
      .backgroundColor(this.config.showBackground ? UIConstants.COLORS.DESCRIPTION_BACKGROUND : 'transparent')
      .padding({
        left: UIConstants.LAYOUT_CONFIG.PADDING.MEDIUM,
        right: UIConstants.LAYOUT_CONFIG.PADDING.MEDIUM,
        top: UIConstants.LAYOUT_CONFIG.PADDING.SMALL,
        bottom: UIConstants.LAYOUT_CONFIG.PADDING.SMALL
      })
      .borderRadius(UIConstants.LAYOUT_CONFIG.BORDER_RADIUS.SMALL)
      .onClick(() => this.handleTitleClick())
  }

  // 事件处理方法
  private handleAuthorClick(): void {
    this.onAuthorClick?.()
    console.log('VideoDescription: 作者点击')
  }

  private handleTitleClick(): void {
    this.onTitleClick?.()
    console.log('VideoDescription: 标题点击')
  }

  // 辅助方法
  private getAuthorText(): string {
    if (!this.currentVideo) {
      return '未知作者'
    }

    const author = this.currentVideo.author || ''

    if (this.config.enableTruncation) {
      return UIUtils.getDefaultText(author, '未知作者')
    }

    return author || '未知作者'
  }

  private getTitleText(): string {
    if (!this.currentVideo) {
      return '未知标题'
    }

    const title = this.currentVideo.title || ''

    if (this.config.enableTruncation) {
      return UIUtils.getDefaultText(title, '未知标题')
    }

    return title || '未知标题'
  }

  aboutToAppear() {
    console.log('VideoDescription: 组件初始化')
  }

  aboutToUpdate() {
    if (!this.currentVideo) {
      console.warn('VideoDescription: 视频数据无效')
    }
  }
}