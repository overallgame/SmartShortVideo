export class UIUtils {
  /**
   * 格式化数字显示
   */
  static formatNumber(num: number): string {
    if (num < 0) {
      num = 0
    }

    if (num >= 100000000) {
      return (num / 100000000).toFixed(1) + '亿'
    } else if (num >= 10000) {
      return (num / 10000).toFixed(1) + '万'
    } else if (num >= 1000) {
      return (num / 1000).toFixed(0) + 'k'
    }
    return num.toString()
  }

  /**
   * 获取状态颜色
   */
  static getStatusColor(isActive: boolean, activeColor: string, inactiveColor: string): string {
    return isActive ? activeColor : inactiveColor
  }

  /**
   * 获取字体粗细
   */
  static getFontWeight(isActive: boolean): FontWeight {
    return isActive ? FontWeight.Bold : FontWeight.Normal
  }

  /**
   * 截断文本
   */
  static truncateText(text: string, maxLength: number): string {
    if (!text || text.length <= maxLength) {
      return text
    }
    return text.substring(0, maxLength) + '...'
  }

  /**
   * 验证文本是否为空
   */
  static isEmptyText(text: string): boolean {
    return !text || text.trim().length === 0
  }

  /**
   * 获取默认文本
   */
  static getDefaultText(text: string, defaultText: string): string {
    return UIUtils.isEmptyText(text) ? defaultText : text
  }

  /**
   * 生成随机ID
   */
  static generateId(): string {
    return Date.now().toString(36) + Math.random().toString(36).substr(2)
  }

  /**
   * 防抖函数
   */
  static debounce(func: Function, delay: number): Function {
    let timeoutId: number = -1

    return (...args: number[]): void => {
      if (timeoutId !== -1) {
        clearTimeout(timeoutId);
      }
      timeoutId = setTimeout(() => {
        func(...args);
      }, delay) as number;
    }
  }

  /**
   * 节流函数
   */
  static throttle(func: Function, delay: number): Function {
    let lastCall = 0

    return (...args: number[]): void => {
      const now = Date.now();
      if (now - lastCall >= delay) {
        lastCall = now;
        func(...args);
      }
    }
  }

  /**
   * 验证数字是否有效
   */
  static isValidNumber(num: number): boolean {
    return typeof num === 'number' && !isNaN(num) && isFinite(num)
  }

  /**
   * 限制数字范围
   */
  static clampNumber(num: number, min: number, max: number): number {
    return Math.min(Math.max(num, min), max)
  }

  /**
   * 计算百分比
   */
  static calculatePercentage(value: number, total: number): number {
    if (total === 0) {
      return 0
    }
    return (value / total) * 100
  }

  /**
   * 格式化时间
   */
  static formatTime(seconds: number): string {
    if (!UIUtils.isValidNumber(seconds) || seconds < 0) {
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
}
