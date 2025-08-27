import { VideoItem } from "../model/VideoModel"

// 主页面状态枚举
export enum HomeTab {
  RECOMMEND = '推荐',
  FOLLOW = '关注'
}

// 交互状态接口
export interface InteractionState {
  isLiked: boolean
  likeCount: number
  isFavorited: boolean
  favoriteCount: number
  commentCount: number
  shareCount: number
  isFollowed: boolean
}

// 主页面事件接口
export interface HomeEvent {
  onTabChange?: (tab: HomeTab) => void
  onFullScreenChange?: (isFullScreen: boolean) => void
  onVideoIndexChange?: (index: number) => void
  onVideoListChange?: (videoList: VideoItem[]) => void
  onInteractionChange?: (videoIndex: number, type: string, newState: InteractionState) => void
}

// 主页面视图模型
export class HomeViewModel {
  // 私有属性
  private _currentTab: HomeTab = HomeTab.RECOMMEND
  private _isFullScreen: boolean = false
  private _currentVideoIndex: number = 0
  private _videoList: VideoItem[] = []
  private _interactionStates: Map<number, InteractionState> = new Map()
  private _eventHandlers: HomeEvent = {}

  // 构造函数
  constructor(eventHandlers?: HomeEvent) {
    this._eventHandlers = eventHandlers || {}
  }

  // 公共属性访问器
  get currentTab(): HomeTab {
    return this._currentTab
  }

  get isFullScreen(): boolean {
    return this._isFullScreen
  }

  get currentVideoIndex(): number {
    return this._currentVideoIndex
  }

  get videoList(): VideoItem[] {
    return [...this._videoList] // 返回副本防止外部修改
  }

  get videoCount(): number {
    return this._videoList.length
  }

  get currentVideo(): VideoItem | null {
    return this.getCurrentVideo()
  }

  get currentInteractionState(): InteractionState {
    return this.getInteractionState(this._currentVideoIndex)
  }

  // 标签页管理
  /**
   * 切换标签页
   */
  switchTab(tab: HomeTab): void {
    if (this._currentTab === tab) {
      return
    }

    this._currentTab = tab
    this._eventHandlers.onTabChange?.(tab)
  }

  /**
   * 获取可用标签页列表
   */
  getAvailableTabs(): HomeTab[] {
    return [HomeTab.RECOMMEND, HomeTab.FOLLOW]
  }

  /**
   * 检查是否为推荐标签页
   */
  isRecommendTab(): boolean {
    return this._currentTab === HomeTab.RECOMMEND
  }

  /**
   * 检查是否为关注标签页
   */
  isFollowTab(): boolean {
    return this._currentTab === HomeTab.FOLLOW
  }

  // 全屏管理
  /**
   * 切换全屏状态
   */
  toggleFullScreen(fullScreen?: boolean): void {
    const newFullScreenState = fullScreen !== undefined ? fullScreen : !this._isFullScreen

    if (this._isFullScreen === newFullScreenState) {
      return
    }

    this._isFullScreen = newFullScreenState
    this._eventHandlers.onFullScreenChange?.(this._isFullScreen)
  }

  /**
   * 设置全屏状态
   */
  setFullScreen(isFullScreen: boolean): void {
    this.toggleFullScreen(isFullScreen)
  }

  /**
   * 进入全屏模式
   */
  enterFullScreen(): void {
    this.setFullScreen(true)
  }

  /**
   * 退出全屏模式
   */
  exitFullScreen(): void {
    this.setFullScreen(false)
  }

  // 视频索引管理
  /**
   * 更新当前视频索引
   */
  updateVideoIndex(index: number): void {
    if (index < 0 || index >= this._videoList.length) {
      console.warn('HomeViewModel: 视频索引超出范围')
      return
    }

    if (this._currentVideoIndex === index) {
      return
    }

    this._currentVideoIndex = index
    this._eventHandlers.onVideoIndexChange?.(index)
  }

  /**
   * 设置视频索引
   */
  setVideoIndex(index: number): void {
    this.updateVideoIndex(index)
  }

  /**
   * 获取视频索引
   */
  getVideoIndex(): number {
    return this._currentVideoIndex
  }

  /**
   * 播放下一个视频
   */
  nextVideo(): boolean {
    if (this._videoList.length === 0) {
      return false
    }

    const nextIndex = (this._currentVideoIndex + 1) % this._videoList.length
    this.updateVideoIndex(nextIndex)
    return true
  }

  /**
   * 播放上一个视频
   */
  previousVideo(): boolean {
    if (this._videoList.length === 0) {
      return false
    }

    const prevIndex = this._currentVideoIndex === 0
      ? this._videoList.length - 1
      : this._currentVideoIndex - 1
    this.updateVideoIndex(prevIndex)
    return true
  }

  // 视频列表管理
  /**
   * 设置视频列表
   */
  setVideoList(videoList: VideoItem[]): void {
    if (!Array.isArray(videoList)) {
      console.warn('HomeViewModel: 视频列表无效')
      return
    }

    this._videoList = [...videoList]

    // 如果当前索引超出范围，重置为0
    if (this._currentVideoIndex >= this._videoList.length) {
      this._currentVideoIndex = 0
    }

    // 初始化交互状态
    this._initializeInteractionStates()

    this._eventHandlers.onVideoListChange?.(this._videoList)
  }

  /**
   * 获取当前视频
   */
  getCurrentVideo(): VideoItem | null {
    if (this._videoList.length === 0 ||
      this._currentVideoIndex < 0 ||
      this._currentVideoIndex >= this._videoList.length) {
      return null
    }
    return this._videoList[this._currentVideoIndex]
  }

  // 交互状态管理
  /**
   * 获取指定视频的交互状态
   */
  getInteractionState(videoIndex: number): InteractionState {
    if (!this._interactionStates.has(videoIndex)) {
      // 返回默认状态
      return {
        isLiked: false,
        likeCount: 0,
        isFavorited: false,
        favoriteCount: 0,
        commentCount: 0,
        shareCount: 0,
        isFollowed: false
      }
    }
    return this._interactionStates.get(videoIndex)!
  }

  /**
   * 切换点赞状态
   */
  toggleLike(videoIndex: number): boolean {
    const state = this.getInteractionState(videoIndex)
    const newState: InteractionState = {
      isLiked: !state.isLiked,
      likeCount: state.isLiked ? state.likeCount - 1 : state.likeCount + 1,
      isFavorited: state.isFavorited,
      favoriteCount: state.favoriteCount,
      commentCount: state.commentCount,
      shareCount: state.shareCount,
      isFollowed: state.isFollowed
    }

    this._interactionStates.set(videoIndex, newState)
    this._eventHandlers.onInteractionChange?.(videoIndex, 'like', newState)
    return true
  }

  /**
   * 切换收藏状态
   */
  toggleFavorite(videoIndex: number): boolean {
    const state = this.getInteractionState(videoIndex)
    const newState: InteractionState = {
      isLiked: state.isLiked,
      likeCount: state.likeCount,
      isFavorited: !state.isFavorited,
      favoriteCount: state.isFavorited ? state.favoriteCount - 1 : state.favoriteCount + 1,
      commentCount: state.commentCount,
      shareCount: state.shareCount,
      isFollowed: state.isFollowed
    }

    this._interactionStates.set(videoIndex, newState)
    this._eventHandlers.onInteractionChange?.(videoIndex, 'favorite', newState)
    return true
  }

  /**
   * 切换关注状态
   */
  toggleFollow(videoIndex: number): boolean {
    const state = this.getInteractionState(videoIndex)
    const newState: InteractionState = {
      isLiked: state.isLiked,
      likeCount: state.likeCount,
      isFavorited: state.isFavorited,
      favoriteCount: state.favoriteCount,
      commentCount: state.commentCount,
      shareCount: state.shareCount,
      isFollowed: !state.isFollowed
    }

    this._interactionStates.set(videoIndex, newState)
    this._eventHandlers.onInteractionChange?.(videoIndex, 'follow', newState)
    return true
  }

  /**
   * 增加评论数量
   */
  incrementCommentCount(videoIndex: number): void {
    const state = this.getInteractionState(videoIndex)
    const newState: InteractionState = {
      isLiked: state.isLiked,
      likeCount: state.likeCount,
      isFavorited: state.isFavorited,
      favoriteCount: state.favoriteCount,
      commentCount: state.commentCount + 1,
      shareCount: state.shareCount,
      isFollowed: state.isFollowed
    }

    this._interactionStates.set(videoIndex, newState)
    this._eventHandlers.onInteractionChange?.(videoIndex, 'comment', newState)
  }

  /**
   * 增加分享数量
   */
  incrementShareCount(videoIndex: number): void {
    const state = this.getInteractionState(videoIndex)
    const newState: InteractionState = {
      isLiked: state.isLiked,
      likeCount: state.likeCount,
      isFavorited: state.isFavorited,
      favoriteCount: state.favoriteCount,
      commentCount: state.commentCount,
      shareCount: state.shareCount + 1,
      isFollowed: state.isFollowed
    }

    this._interactionStates.set(videoIndex, newState)
    this._eventHandlers.onInteractionChange?.(videoIndex, 'comment', newState)
  }

  // 私有方法
  /**
   * 初始化交互状态
   */
  private _initializeInteractionStates(): void {
    this._interactionStates.clear()

    // 为每个视频初始化默认交互状态
    this._videoList.forEach((_, index) => {
      this._interactionStates.set(index, {
        isLiked: false,
        likeCount: Math.floor(Math.random() * 1000) + 100, // 随机初始值
        isFavorited: false,
        favoriteCount: Math.floor(Math.random() * 500) + 50,
        commentCount: Math.floor(Math.random() * 200) + 20,
        shareCount: Math.floor(Math.random() * 100) + 10,
        isFollowed: false
      })
    })
  }

  // 事件管理
  /**
   * 设置事件处理器
   */
  setEventHandlers(handlers: HomeEvent): void {
    // 手动合并事件处理器
    if (handlers.onTabChange) {
      this._eventHandlers.onTabChange = handlers.onTabChange
    }
    if (handlers.onFullScreenChange) {
      this._eventHandlers.onFullScreenChange = handlers.onFullScreenChange
    }
    if (handlers.onVideoIndexChange) {
      this._eventHandlers.onVideoIndexChange = handlers.onVideoIndexChange
    }
    if (handlers.onVideoListChange) {
      this._eventHandlers.onVideoListChange = handlers.onVideoListChange
    }
    if (handlers.onInteractionChange) {
      this._eventHandlers.onInteractionChange = handlers.onInteractionChange
    }
  }

  /**
   * 清理资源
   */
  destroy(): void {
    this._eventHandlers = {}
    this._interactionStates.clear()
  }

  // 状态查询
  /**
   * 获取当前状态描述
   */
  getStatusDescription(): string {
    return `当前标签: ${this._currentTab}, 全屏: ${this._isFullScreen ? '是' :
      '否'}, 视频索引: ${this._currentVideoIndex}, 视频总数: ${this._videoList.length}`
  }

  /**
   * 检查是否可以切换标签页
   */
  canSwitchTab(): boolean {
    return !this._isFullScreen // 全屏时不允许切换标签页
  }

  /**
   * 检查是否可以进入全屏
   */
  canEnterFullScreen(): boolean {
    return !this._isFullScreen
  }

  /**
   * 检查是否可以退出全屏
   */
  canExitFullScreen(): boolean {
    return this._isFullScreen
  }

  /**
   * 检查是否有视频
   */
  hasVideos(): boolean {
    return this._videoList.length > 0
  }

  /**
   * 检查是否可以播放下一个视频
   */
  canPlayNext(): boolean {
    return this._videoList.length > 1
  }

  /**
   * 检查是否可以播放上一个视频
   */
  canPlayPrevious(): boolean {
    return this._videoList.length > 1
  }
}