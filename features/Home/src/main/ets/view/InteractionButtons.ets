import { InteractionState } from '../viewModel/HomeViewModel'
import { UIConstants } from '../constants/UIConstants'

// 交互按钮配置接口
interface InteractionConfig {
  showAvatar?: boolean
  showFollowButton?: boolean
  enableAnimations?: boolean
  buttonSpacing?: number
}

@Component
export struct InteractionButtons {
  // 外部属性
  @Prop interactionState: InteractionState
  // 事件回调
  onLikeClick?: () => void
  onFavoriteClick?: () => void
  onCommentClick?: () => void
  onShareClick?: () => void
  onFollowClick?: () => void
  // 内部状态
  private config: InteractionConfig = {
    showAvatar: true,
    showFollowButton: true,
    enableAnimations: true,
    buttonSpacing: UIConstants.INTERACTION_CONFIG.MARGIN_BETWEEN
  }

  build() {
    Column() {
      if (this.config.showAvatar) {
        this.AvatarSection()
      }

      this.InteractionButtonsSection()
    }
    .alignItems(HorizontalAlign.Center)
  }

  // 头像区域
  @Builder
  AvatarSection() {
    Stack() {
      Image($r('app.media.background'))
        .width(UIConstants.INTERACTION_CONFIG.AVATAR_SIZE)
        .height(UIConstants.INTERACTION_CONFIG.AVATAR_SIZE)
        .borderRadius(UIConstants.INTERACTION_CONFIG.AVATAR_SIZE / 2)

      if (this.config.showFollowButton) {
        this.FollowButton()
      }
    }
    .margin({ bottom: this.config.buttonSpacing })
  }

  // 关注按钮
  @Builder
  FollowButton() {
    Circle()
      .width(UIConstants.INTERACTION_CONFIG.FOLLOW_BUTTON_SIZE)
      .height(UIConstants.INTERACTION_CONFIG.FOLLOW_BUTTON_SIZE)
      .fill(this.interactionState.isFollowed ? UIConstants.COLORS.SECONDARY : UIConstants.COLORS.PRIMARY)
      .position({
        x: UIConstants.INTERACTION_CONFIG.AVATAR_SIZE - UIConstants.INTERACTION_CONFIG.FOLLOW_BUTTON_SIZE,
        y: UIConstants.INTERACTION_CONFIG.AVATAR_SIZE - UIConstants.INTERACTION_CONFIG.FOLLOW_BUTTON_SIZE
      })
      .onClick(() => this.handleFollowClick())

    Text(this.interactionState.isFollowed ? '✓' : '+')
      .fontSize(UIConstants.INTERACTION_CONFIG.FONT_SIZE)
      .fontColor(UIConstants.COLORS.TEXT_PRIMARY)
      .fontWeight(FontWeight.Bold)
      .position({
        x: UIConstants.INTERACTION_CONFIG.AVATAR_SIZE - UIConstants.INTERACTION_CONFIG.FOLLOW_BUTTON_SIZE + 5,
        y: UIConstants.INTERACTION_CONFIG.AVATAR_SIZE - UIConstants.INTERACTION_CONFIG.FOLLOW_BUTTON_SIZE
      })
  }

  // 交互按钮区域
  @Builder
  InteractionButtonsSection() {
    Column() {
      // 点赞按钮
      this.InteractionButton(
        'like',
        this.interactionState.isLiked,
        this.formatCount(this.interactionState.likeCount),
        UIConstants.COLORS.PRIMARY
      )

      // 收藏按钮
      this.InteractionButton(
        'favorite',
        this.interactionState.isFavorited,
        this.formatCount(this.interactionState.favoriteCount),
        UIConstants.COLORS.SECONDARY
      )

      // 评论按钮
      this.InteractionButton(
        'comment',
        false,
        this.formatCount(this.interactionState.commentCount),
        UIConstants.COLORS.TEXT_PRIMARY
      )

      // 分享按钮
      this.InteractionButton(
        'share',
        false,
        this.formatCount(this.interactionState.shareCount),
        UIConstants.COLORS.TEXT_PRIMARY
      )
    }
  }

  // 通用交互按钮
  @Builder
  InteractionButton(
    type: string,
    isActive: boolean,
    count: string,
    _activeColor: string
  ) {
    Column() {
      Image(this.getButtonIcon(type, isActive))
        .width(UIConstants.INTERACTION_CONFIG.BUTTON_SIZE)
        .height(UIConstants.INTERACTION_CONFIG.BUTTON_SIZE)
        .onClick(() => this.handleButtonClick(type))

      Text(count)
        .fontSize(UIConstants.INTERACTION_CONFIG.FONT_SIZE)
        .fontColor(UIConstants.COLORS.TEXT_PRIMARY)
        .margin({ top: UIConstants.LAYOUT_CONFIG.PADDING.SMALL })
    }
    .margin({ bottom: this.config.buttonSpacing })
  }

  // 事件处理方法
  private handleButtonClick(type: string): void {
    switch (type) {
      case 'like':
        this.handleLikeClick()
        break
      case 'comment':
        this.handleCommentClick()
        break
      case 'favorite':
        this.handleFavoriteClick()
        break
      case 'share':
        this.handleShareClick()
        break
      default:
        console.warn(`未知的按钮类型: ${type}`)
    }
  }

  private handleLikeClick(): void {
    this.onLikeClick?.()
    console.log('InteractionButtons: 点赞按钮点击')
  }

  private handleCommentClick(): void {
    this.onCommentClick?.()
    console.log('InteractionButtons: 评论按钮点击')
  }

  private handleFavoriteClick(): void {
    this.onFavoriteClick?.()
    console.log('InteractionButtons: 收藏按钮点击')
  }

  private handleShareClick(): void {
    this.onShareClick?.()
    console.log('InteractionButtons: 分享按钮点击')
  }

  private handleFollowClick(): void {
    this.onFollowClick?.()
    console.log('InteractionButtons: 关注按钮点击')
  }

  private formatCount(count: number): string {
    if (count >= 10000) {
      return (count / 10000).toFixed(1) + 'w'
    } else if (count >= 1000) {
      return (count / 1000).toFixed(1) + 'k'
    } else {
      return count.toString()
    }
  }

  private getButtonIcon(type: string, isActive: boolean): Resource {
    switch (type) {
      case 'like':
        return isActive ? $r('app.media.like_fill') : $r('app.media.like')
      case 'favorite':
        return isActive ? $r('app.media.collection_fill') : $r('app.media.collection')
      case 'comment':
        return $r('app.media.comment')
      case 'share':
        return $r('app.media.share')
      default:
        return $r('app.media.background')
    }
  }
}