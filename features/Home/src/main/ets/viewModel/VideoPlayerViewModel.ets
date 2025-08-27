import { VideoUtils } from '../utils/VideoUtils'
import { VideoConstants } from '../constants/VideoConstants'

// 视频播放状态枚举
export enum VideoPlayState {
  IDLE = 'idle',
  LOADING = 'loading',
  PLAYING = 'playing',
  PAUSED = 'paused',
  ERROR = 'error',
  FINISHED = 'finished'
}

// 视频播放器事件接口
export interface VideoPlayerEvent {
  onPlayStateChange?: (state: VideoPlayState) => void
  onError?: (error: string) => void
  onVideoRequestChange?: (direction: 'next' | 'previous' | 'specific', index?: number) => void
}

export class VideoPlayerViewModel {
  private _playState: VideoPlayState = VideoPlayState.IDLE
  private _showControls: boolean = false
  private _isFullScreen: boolean = false
  private _controlHideTimer: number = -1
  private _eventHandlers: VideoPlayerEvent = {}

  constructor(eventHandlers?: VideoPlayerEvent) {
    this._eventHandlers = eventHandlers || {}
    this._playState = VideoPlayState.IDLE
  }

  get playState(): VideoPlayState {
    return this._playState
  }

  get isPlaying(): boolean {
    return this._playState === VideoPlayState.PLAYING
  }

  get showControls(): boolean {
    return this._showControls
  }

  get isFullScreen(): boolean {
    return this._isFullScreen
  }

  // 播放控制方法
  /**
   * 切换播放/暂停状态
   */
  togglePlay(videoController?: VideoController): void {
    if (this._playState === VideoPlayState.ERROR) {
      this._retryPlay(videoController)
      return
    }

    if (this._playState === VideoPlayState.PLAYING) {
      this.pause(videoController)
    } else {
      this.play(videoController)
    }
  }

  /**
   * 播放视频
   */
  play(videoController?: VideoController): void {
    if (this._playState === VideoPlayState.PLAYING) {
      return
    }

    this._playState = VideoPlayState.PLAYING
    this._showControls = true
    this._startControlTimer()

    // 控制视频播放器
    if (videoController) {
      try {
        console.log('开始播放视频')
      } catch (error) {
        console.error('VideoPlayerViewModel: 播放视频失败', error)
        this._handleError(VideoUtils.getErrorMessage('PLAY_FAILED'))
      }
    }

    this._eventHandlers.onPlayStateChange?.(this._playState)
  }

  /**
   * 暂停视频
   */
  pause(videoController?: VideoController): void {
    if (this._playState === VideoPlayState.PAUSED) {
      return
    }

    this._playState = VideoPlayState.PAUSED
    this._showControls = true
    this._startControlTimer()

    // 控制视频播放器
    if (videoController) {
      try {
        console.log('暂停视频')
      } catch (error) {
        console.error('VideoPlayerViewModel: 暂停视频失败', error)
      }
    }

    this._eventHandlers.onPlayStateChange?.(this._playState)
  }

  /**
   * 请求播放下一个视频
   */
  requestNextVideo(): void {
    this._eventHandlers.onVideoRequestChange?.('next')
  }

  /**
   * 请求播放上一个视频
   */
  requestPreviousVideo(): void {
    this._eventHandlers.onVideoRequestChange?.('previous')
  }

  /**
   * 请求跳转到指定视频
   */
  requestJumpToVideo(index: number): void {
    this._eventHandlers.onVideoRequestChange?.('specific', index)
  }

  // 全屏控制
  /**
   * 切换全屏状态
   */
  toggleFullScreen(): void {
    this._isFullScreen = !this._isFullScreen
  }

  /**
   * 设置全屏状态
   */
  setFullScreen(fullScreen: boolean): void {
    this._isFullScreen = fullScreen
  }

  // 状态管理方法
  /**
   * 设置播放状态
   */
  setPlayState(state: VideoPlayState): void {
    if (this._playState === state) {
      return
    }

    this._playState = state

    // 根据状态调整控制按钮显示
    if (state === VideoPlayState.PLAYING || state === VideoPlayState.PAUSED) {
      this._showControls = true
      this._startControlTimer()
    } else if (state === VideoPlayState.ERROR) {
      this._showControls = true
      this._clearControlTimer()
    } else {
      this._showControls = false
      this._clearControlTimer()
    }

    this._eventHandlers.onPlayStateChange?.(state)
  }

  /**
   * 显示控制按钮
   */
  setShowControls(show: boolean): void {
    this._showControls = show
    if (show) {
      this._startControlTimer()
    } else {
      this._clearControlTimer()
    }
  }

  /**
   * 显示控制按钮
   */
  showControlsMethod(): void {
    this.setShowControls(true)
  }

  /**
   * 隐藏控制按钮
   */
  hideControls(): void {
    this.setShowControls(false)
  }

  // 私有辅助方法
  /**
   * 开始控制按钮隐藏计时器
   */
  private _startControlTimer(): void {
    this._clearControlTimer()
    this._controlHideTimer = setTimeout(() => {
      this._showControls = false
      this._controlHideTimer = -1
    }, VideoConstants.GESTURE_CONFIG.CONTROL_HIDE_DELAY) as number
  }

  /**
   * 清除控制按钮隐藏计时器
   */
  private _clearControlTimer(): void {
    if (this._controlHideTimer !== -1) {
      clearTimeout(this._controlHideTimer)
      this._controlHideTimer = -1
    }
  }

  /**
   * 处理错误
   */
  private _handleError(errorMessage: string): void {
    this._playState = VideoPlayState.ERROR
    this._showControls = true
    this._clearControlTimer()

    console.error('VideoPlayerViewModel:', errorMessage)
    this._eventHandlers.onError?.(errorMessage)
    this._eventHandlers.onPlayStateChange?.(this._playState)
  }

  /**
   * 重试播放
   */
  private _retryPlay(videoController?: VideoController): void {
    this._playState = VideoPlayState.LOADING
    this._eventHandlers.onPlayStateChange?.(this._playState)

    if (videoController) {
      try {
        console.log('重试播放视频')
      } catch (error) {
        console.error('VideoPlayerViewModel: 重试播放失败', error)
        this._handleError(VideoUtils.getErrorMessage('RETRY_FAILED'))
      }
    }
  }

  /**
   * 设置事件处理器
   */
  setEventHandlers(handlers: VideoPlayerEvent): void {
    // 合并事件处理器
    if (handlers.onPlayStateChange) {
      this._eventHandlers.onPlayStateChange = handlers.onPlayStateChange
    }
    if (handlers.onError) {
      this._eventHandlers.onError = handlers.onError
    }
    if (handlers.onVideoRequestChange) {
      this._eventHandlers.onVideoRequestChange = handlers.onVideoRequestChange
    }
  }

  /**
   * 清理资源
   */
  destroy(): void {
    this._clearControlTimer()
    this._eventHandlers = {}
  }
}