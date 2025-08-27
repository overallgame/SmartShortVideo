// 播放状态接口
interface PlayStates {
  readonly IDLE: string
  readonly LOADING: string
  readonly PLAYING: string
  readonly PAUSED: string
  readonly ERROR: string
  readonly FINISHED: string
}

// 手势配置接口
interface GestureConfig {
  readonly SWIPE_THRESHOLD: number
  readonly CONTROL_HIDE_DELAY: number
  readonly MIN_SWIPE_DISTANCE: number
}

// 内边距配置接口
interface PaddingConfig {
  readonly SMALL: number
  readonly MEDIUM: number
  readonly LARGE: number
}

// UI配置接口
interface UIConfig {
  readonly CONTROL_BUTTON_SIZE: number
  readonly LOADING_INDICATOR_SIZE: number
  readonly FULLSCREEN_BUTTON_SIZE: number
  readonly BORDER_RADIUS: number
  readonly PADDING: PaddingConfig
}

// 颜色配置接口
interface Colors {
  readonly OVERLAY_BACKGROUND: string
  readonly ERROR_BACKGROUND: string
  readonly LOADING_BACKGROUND: string
  readonly FULLSCREEN_BACKGROUND: string
}

// 动画配置接口
interface AnimationConfig {
  readonly DURATION: number
  readonly CURVE: Curve
}

// 错误消息接口
interface ErrorMessages {
  readonly PLAY_FAILED: string
  readonly LOAD_FAILED: string
  readonly NETWORK_ERROR: string
  readonly RETRY_FAILED: string
  readonly UNKNOWN_ERROR: string
}

// 成功消息接口
interface SuccessMessages {
  readonly PLAY_SUCCESS: string
  readonly LOAD_SUCCESS: string
}

// 视频播放器常量配置
export class VideoConstants {
  // 播放状态
  static readonly PLAY_STATES: PlayStates = {
    IDLE: 'idle',
    LOADING: 'loading',
    PLAYING: 'playing',
    PAUSED: 'paused',
    ERROR: 'error',
    FINISHED: 'finished'
  }
  // 手势配置
  static readonly GESTURE_CONFIG: GestureConfig = {
    SWIPE_THRESHOLD: 100, // 滑动阈值
    CONTROL_HIDE_DELAY: 3000, // 控制按钮隐藏延迟（毫秒）
    MIN_SWIPE_DISTANCE: 50       // 最小滑动距离
  }
  // UI配置
  static readonly UI_CONFIG: UIConfig = {
    CONTROL_BUTTON_SIZE: 80, // 控制按钮大小
    LOADING_INDICATOR_SIZE: 80, // 加载指示器大小
    FULLSCREEN_BUTTON_SIZE: 24, // 全屏按钮大小
    BORDER_RADIUS: 20, // 圆角半径
    PADDING: {
      SMALL: 8,
      MEDIUM: 12,
      LARGE: 16
    } as PaddingConfig
  }
  // 颜色配置
  static readonly COLORS: Colors = {
    OVERLAY_BACKGROUND: 'rgba(0, 0, 0, 0.5)',
    ERROR_BACKGROUND: 'rgba(255, 0, 0, 0.7)',
    LOADING_BACKGROUND: 'rgba(0, 0, 0, 0.7)',
    FULLSCREEN_BACKGROUND: 'rgba(0, 0, 0, 0.7)'
  }
  // 动画配置
  static readonly ANIMATION_CONFIG: AnimationConfig = {
    DURATION: 300, // 动画持续时间（毫秒）
    CURVE: Curve.EaseInOut       // 动画曲线
  }
  // 错误消息
  static readonly ERROR_MESSAGES: ErrorMessages = {
    PLAY_FAILED: '播放失败',
    LOAD_FAILED: '加载失败',
    NETWORK_ERROR: '网络错误',
    RETRY_FAILED: '重试失败',
    UNKNOWN_ERROR: '未知错误'
  }
  // 成功消息
  static readonly SUCCESS_MESSAGES: SuccessMessages = {
    PLAY_SUCCESS: '播放成功',
    LOAD_SUCCESS: '加载成功'
  }
}
