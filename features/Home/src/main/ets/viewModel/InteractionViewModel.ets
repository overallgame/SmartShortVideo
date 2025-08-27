import { UIUtils } from '../utils/UIUtils'

// 交互状态枚举
export enum InteractionType {
  LIKE = 'like',
  COMMENT = 'comment',
  FAVORITE = 'favorite',
  SHARE = 'share',
  FOLLOW = 'follow'
}

// 交互事件接口
export interface InteractionEvent {
  onLikeChange?: (isLiked: boolean, count: number) => void
  onFavoriteChange?: (isFavorited: boolean, count: number) => void
  onCommentClick?: () => void
  onShareClick?: () => void
  onFollowClick?: () => void
}

// 交互数据接口
export interface InteractionData {
  likeCount: number
  commentCount: number
  favoriteCount: number
  shareCount: number
  isLiked: boolean
  isFavorited: boolean
  isFollowed: boolean
}

// 交互统计接口
interface InteractionStatistics {
  totalInteractions: number
  activeInteractions: number
}

// 交互按钮视图模型
export class InteractionViewModel {
  // 私有属性
  private _interactionData: InteractionData = {
    likeCount: 54000,
    commentCount: 1200,
    favoriteCount: 8900,
    shareCount: 560,
    isLiked: false,
    isFavorited: false,
    isFollowed: false
  }
  private _eventHandlers: InteractionEvent = {}

  // 构造函数
  constructor(initialData?: Partial<InteractionData>, eventHandlers?: InteractionEvent) {
    if (initialData) {
      // 手动合并初始数据
      if (initialData.likeCount !== undefined) {
        this._interactionData.likeCount = initialData.likeCount
      }
      if (initialData.commentCount !== undefined) {
        this._interactionData.commentCount = initialData.commentCount
      }
      if (initialData.favoriteCount !== undefined) {
        this._interactionData.favoriteCount = initialData.favoriteCount
      }
      if (initialData.shareCount !== undefined) {
        this._interactionData.shareCount = initialData.shareCount
      }
      if (initialData.isLiked !== undefined) {
        this._interactionData.isLiked = initialData.isLiked
      }
      if (initialData.isFavorited !== undefined) {
        this._interactionData.isFavorited = initialData.isFavorited
      }
      if (initialData.isFollowed !== undefined) {
        this._interactionData.isFollowed = initialData.isFollowed
      }
    }
    this._eventHandlers = eventHandlers || {}
  }

  // 公共属性访问器
  get isLiked(): boolean {
    return this._interactionData.isLiked
  }

  get isFavorited(): boolean {
    return this._interactionData.isFavorited
  }

  get isFollowed(): boolean {
    return this._interactionData.isFollowed
  }

  get likeCount(): number {
    return this._interactionData.likeCount
  }

  get commentCount(): number {
    return this._interactionData.commentCount
  }

  get favoriteCount(): number {
    return this._interactionData.favoriteCount
  }

  get shareCount(): number {
    return this._interactionData.shareCount
  }

  // 点赞管理
  /**
   * 切换点赞状态
   */
  toggleLike(): boolean {
    const newLikedState = !this._interactionData.isLiked
    const newCount = newLikedState
      ? this._interactionData.likeCount + 1
      : this._interactionData.likeCount - 1

    // 确保数量不为负数
    if (newCount < 0) {
      console.warn('InteractionViewModel: 点赞数不能为负数')
      return false
    }

    this._interactionData.isLiked = newLikedState
    this._interactionData.likeCount = newCount

    this._eventHandlers.onLikeChange?.(newLikedState, newCount)
    return true
  }

  /**
   * 设置点赞状态
   */
  setLiked(isLiked: boolean): boolean {
    if (this._interactionData.isLiked === isLiked) {
      return false
    }
    return this.toggleLike()
  }

  /**
   * 增加点赞数
   */
  incrementLikeCount(amount: number = 1): void {
    if (amount <= 0) {
      console.warn('InteractionViewModel: 增加数量必须大于0')
      return
    }
    this._interactionData.likeCount += amount
  }

  /**
   * 减少点赞数
   */
  decrementLikeCount(amount: number = 1): void {
    if (amount <= 0) {
      console.warn('InteractionViewModel: 减少数量必须大于0')
      return
    }
    this._interactionData.likeCount = Math.max(0, this._interactionData.likeCount - amount)
  }

  // 收藏管理
  /**
   * 切换收藏状态
   */
  toggleFavorite(): boolean {
    const newFavoritedState = !this._interactionData.isFavorited
    const newCount = newFavoritedState
      ? this._interactionData.favoriteCount + 1
      : this._interactionData.favoriteCount - 1

    // 确保数量不为负数
    if (newCount < 0) {
      console.warn('InteractionViewModel: 收藏数不能为负数')
      return false
    }

    this._interactionData.isFavorited = newFavoritedState
    this._interactionData.favoriteCount = newCount

    this._eventHandlers.onFavoriteChange?.(newFavoritedState, newCount)
    return true
  }

  /**
   * 设置收藏状态
   */
  setFavorited(isFavorited: boolean): boolean {
    if (this._interactionData.isFavorited === isFavorited) {
      return false
    }
    return this.toggleFavorite()
  }

  // 关注管理
  /**
   * 切换关注状态
   */
  toggleFollow(): boolean {
    this._interactionData.isFollowed = !this._interactionData.isFollowed
    this._eventHandlers.onFollowClick?.()
    return true
  }

  /**
   * 设置关注状态
   */
  setFollowed(isFollowed: boolean): boolean {
    if (this._interactionData.isFollowed === isFollowed) {
      return false
    }
    this._interactionData.isFollowed = isFollowed
    this._eventHandlers.onFollowClick?.()
    return true
  }

  // 评论和分享
  /**
   * 处理评论点击
   */
  handleCommentClick(): void {
    this._eventHandlers.onCommentClick?.()
  }

  /**
   * 处理分享点击
   */
  handleShareClick(): void {
    this._eventHandlers.onShareClick?.()
  }

  // 数量管理
  /**
   * 更新评论数
   */
  updateCommentCount(count: number): void {
    if (count < 0) {
      console.warn('InteractionViewModel: 评论数不能为负数')
      return
    }
    this._interactionData.commentCount = count
  }

  /**
   * 更新分享数
   */
  updateShareCount(count: number): void {
    if (count < 0) {
      console.warn('InteractionViewModel: 分享数不能为负数')
      return
    }
    this._interactionData.shareCount = count
  }

  /**
   * 增加评论数
   */
  incrementCommentCount(amount: number = 1): void {
    this.updateCommentCount(this._interactionData.commentCount + amount)
  }

  /**
   * 增加分享数
   */
  incrementShareCount(amount: number = 1): void {
    this.updateShareCount(this._interactionData.shareCount + amount)
  }

  // 格式化显示
  /**
   * 获取点赞数显示
   */
  getLikeCountDisplay(): string {
    return UIUtils.formatNumber(this._interactionData.likeCount)
  }

  /**
   * 获取评论数显示
   */
  getCommentCountDisplay(): string {
    return UIUtils.formatNumber(this._interactionData.commentCount)
  }

  /**
   * 获取收藏数显示
   */
  getFavoriteCountDisplay(): string {
    return UIUtils.formatNumber(this._interactionData.favoriteCount)
  }

  /**
   * 获取分享数显示
   */
  getShareCountDisplay(): string {
    return UIUtils.formatNumber(this._interactionData.shareCount)
  }

  // 数据管理
  /**
   * 获取交互数据
   */
  getInteractionData(): InteractionData {
    // 手动创建副本
    return {
      likeCount: this._interactionData.likeCount,
      commentCount: this._interactionData.commentCount,
      favoriteCount: this._interactionData.favoriteCount,
      shareCount: this._interactionData.shareCount,
      isLiked: this._interactionData.isLiked,
      isFavorited: this._interactionData.isFavorited,
      isFollowed: this._interactionData.isFollowed
    }
  }

  /**
   * 更新交互数据
   */
  updateInteractionData(data: Partial<InteractionData>): void {
    // 手动合并数据
    if (data.likeCount !== undefined) {
      this._interactionData.likeCount = data.likeCount
    }
    if (data.commentCount !== undefined) {
      this._interactionData.commentCount = data.commentCount
    }
    if (data.favoriteCount !== undefined) {
      this._interactionData.favoriteCount = data.favoriteCount
    }
    if (data.shareCount !== undefined) {
      this._interactionData.shareCount = data.shareCount
    }
    if (data.isLiked !== undefined) {
      this._interactionData.isLiked = data.isLiked
    }
    if (data.isFavorited !== undefined) {
      this._interactionData.isFavorited = data.isFavorited
    }
    if (data.isFollowed !== undefined) {
      this._interactionData.isFollowed = data.isFollowed
    }
  }

  /**
   * 重置交互数据
   */
  resetInteractionData(): void {
    this._interactionData = {
      likeCount: 0,
      commentCount: 0,
      favoriteCount: 0,
      shareCount: 0,
      isLiked: false,
      isFavorited: false,
      isFollowed: false
    }
  }

  // 事件管理
  /**
   * 设置事件处理器
   */
  setEventHandlers(handlers: InteractionEvent): void {
    // 手动合并事件处理器
    if (handlers.onLikeChange) {
      this._eventHandlers.onLikeChange = handlers.onLikeChange
    }
    if (handlers.onFavoriteChange) {
      this._eventHandlers.onFavoriteChange = handlers.onFavoriteChange
    }
    if (handlers.onCommentClick) {
      this._eventHandlers.onCommentClick = handlers.onCommentClick
    }
    if (handlers.onShareClick) {
      this._eventHandlers.onShareClick = handlers.onShareClick
    }
    if (handlers.onFollowClick) {
      this._eventHandlers.onFollowClick = handlers.onFollowClick
    }
  }

  /**
   * 清理资源
   */
  destroy(): void {
    this._eventHandlers = {}
  }

  // 状态查询
  /**
   * 获取当前状态描述
   */
  getStatusDescription(): string {
    return `点赞: ${this._interactionData.isLiked ? '是' : '否'}(${this.getLikeCountDisplay()}), ` +
      `收藏: ${this._interactionData.isFavorited ? '是' : '否'}(${this.getFavoriteCountDisplay()}), ` +
      `关注: ${this._interactionData.isFollowed ? '是' : '否'}`
  }

  /**
   * 检查是否有任何交互
   */
  hasAnyInteraction(): boolean {
    return this._interactionData.isLiked || this._interactionData.isFavorited || this._interactionData.isFollowed
  }

  /**
   * 获取交互统计
   */
  getInteractionStatistics(): InteractionStatistics {
    const totalInteractions = this._interactionData.likeCount + this._interactionData.commentCount +
    this._interactionData.favoriteCount + this._interactionData.shareCount
    const activeInteractions = [this._interactionData.isLiked, this._interactionData.isFavorited,
      this._interactionData.isFollowed].filter(Boolean).length

    return { totalInteractions, activeInteractions }
  }
}
