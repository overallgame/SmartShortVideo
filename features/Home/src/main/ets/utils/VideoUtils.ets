import { VideoItem } from '../model/VideoModel'
import { VideoPlayState } from '../viewModel/VideoPlayerViewModel'
import { VideoConstants } from '../constants/VideoConstants'

// 视频播放器工具类
export class VideoUtils {
  /**
   * 验证视频URL是否有效
   */
  static isValidVideoUrl(url: string): boolean {
    if (!url || typeof url !== 'string') {
      return false
    }

    // 简单的URL格式验证
    const urlPattern = /^https?:\/\/.+/i
    return urlPattern.test(url)
  }

  /**
   * 验证视频列表是否有效
   */
  static isValidVideoList(videoList: VideoItem[]): boolean {
    if (!Array.isArray(videoList)) {
      return false
    }

    return videoList.every(video => VideoUtils.isValidVideoItem(video))
  }

  /**
   * 验证单个视频项是否有效
   */
  static isValidVideoItem(video: VideoItem): boolean {
    if (!video || typeof video !== 'object') {
      return false
    }

    // 直接访问属性而不是使用索引访问
    return video.id !== undefined && video.id !== null &&
      video.url !== undefined && video.url !== null &&
      video.title !== undefined && video.title !== null &&
      video.description !== undefined && video.description !== null &&
      video.author !== undefined && video.author !== null
  }

  /**
   * 格式化视频时长
   */
  static formatDuration(seconds: number): string {
    if (!seconds || seconds < 0) {
      return '00:00'
    }

    const hours = Math.floor(seconds / 3600)
    const minutes = Math.floor((seconds % 3600) / 60)
    const secs = Math.floor(seconds % 60)

    if (hours > 0) {
      return `${hours.toString().padStart(2, '0')}:${minutes.toString().padStart(2, '0')}:${secs.toString()
        .padStart(2, '0')}`
    } else {
      return `${minutes.toString().padStart(2, '0')}:${secs.toString().padStart(2, '0')}`
    }
  }

  /**
   * 格式化文件大小
   */
  static formatFileSize(bytes: number): string {
    if (!bytes || bytes < 0) {
      return '0 B'
    }

    const units = ['B', 'KB', 'MB', 'GB', 'TB']
    let size = bytes
    let unitIndex = 0

    while (size >= 1024 && unitIndex < units.length - 1) {
      size /= 1024
      unitIndex++
    }

    return `${size.toFixed(1)} ${units[unitIndex]}`
  }

  /**
   * 获取播放状态对应的图标
   */
  static getPlayStateIcon(state: VideoPlayState): string {
    switch (state) {
      case VideoPlayState.PLAYING:
        return '⏸️'
      case VideoPlayState.PAUSED:
      case VideoPlayState.IDLE:
      case VideoPlayState.FINISHED:
        return '▶️'
      case VideoPlayState.ERROR:
        return '🔄'
      case VideoPlayState.LOADING:
        return '⏳'
      default:
        return '▶️'
    }
  }

  /**
   * 获取播放状态对应的描述文本
   */
  static getPlayStateText(state: VideoPlayState): string {
    switch (state) {
      case VideoPlayState.PLAYING:
        return '播放中'
      case VideoPlayState.PAUSED:
        return '已暂停'
      case VideoPlayState.IDLE:
        return '待播放'
      case VideoPlayState.FINISHED:
        return '播放完成'
      case VideoPlayState.ERROR:
        return '播放错误'
      case VideoPlayState.LOADING:
        return '加载中'
      default:
        return '未知状态'
    }
  }

  /**
   * 获取错误消息
   */
  static getErrorMessage(errorType: string): string {
    const errorMessages = VideoConstants.ERROR_MESSAGES
    switch (errorType) {
      case 'PLAY_FAILED':
        return errorMessages.PLAY_FAILED
      case 'LOAD_FAILED':
        return errorMessages.LOAD_FAILED
      case 'NETWORK_ERROR':
        return errorMessages.NETWORK_ERROR
      case 'RETRY_FAILED':
        return errorMessages.RETRY_FAILED
      case 'UNKNOWN_ERROR':
        return errorMessages.UNKNOWN_ERROR
      default:
        return errorMessages.UNKNOWN_ERROR
    }
  }

  /**
   * 获取成功消息
   */
  static getSuccessMessage(successType: string): string {
    const successMessages = VideoConstants.SUCCESS_MESSAGES
    switch (successType) {
      case 'PLAY_SUCCESS':
        return successMessages.PLAY_SUCCESS
      case 'LOAD_SUCCESS':
        return successMessages.LOAD_SUCCESS
      default:
        return successMessages.LOAD_SUCCESS
    }
  }

  /**
   * 计算视频索引（支持循环）
   */
  static calculateVideoIndex(currentIndex: number, direction: string, totalCount: number): number {
    if (totalCount === 0) {
      return 0
    }

    if (direction === 'next') {
      return currentIndex < totalCount - 1 ? currentIndex + 1 : 0
    } else {
      return currentIndex > 0 ? currentIndex - 1 : totalCount - 1
    }
  }

  /**
   * 验证视频索引是否有效
   */
  static isValidVideoIndex(index: number, totalCount: number): boolean {
    return index >= 0 && index < totalCount
  }

  /**
   * 防抖函数
   */
  static debounce(func: Function, delay: number): Function {
    let timeoutId: number = -1

    return (...args: number[]): void => {
      if (timeoutId !== -1) {
        clearTimeout(timeoutId)
      }
      timeoutId = setTimeout(() => {
        func(...args)
      }, delay) as number
    }
  }

  /**
   * 节流函数
   */
  static throttle(func: Function, delay: number): Function {
    let lastCall = 0

    return (...args: number[]): void => {
      const now = Date.now()
      if (now - lastCall >= delay) {
        lastCall = now
        func(...args)
      }
    }
  }

  /**
   * 生成唯一ID
   */
  static generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2)
  }

  /**
   * 深拷贝对象
   */
  static deepClone(obj: object): object {
    if (obj === null || typeof obj !== 'object') {
      return obj
    }

    if (obj instanceof Date) {
      return new Date(obj.getTime())
    }

    if (obj instanceof Array) {
      const clonedArray: object[] = []
      for (let i = 0; i < obj.length; i++) {
        clonedArray[i] = VideoUtils.deepClone(obj[i])
      }
      return clonedArray
    }

    if (typeof obj === 'object') {
      const clonedObj: Record<string, object> = {}
      const keys = Object.keys(obj)
      for (let i = 0; i < keys.length; i++) {
        const key = keys[i]
        clonedObj[key] = VideoUtils.deepClone(obj[key])
      }
      return clonedObj
    }

    return obj
  }
}
