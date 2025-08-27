// 导航内边距配置接口
interface NavigationPadding {
  readonly LEFT: number
  readonly RIGHT: number
}

// 导航配置接口
interface NavigationConfig {
  readonly HEIGHT: number
  readonly TAB_FONT_SIZE: number
  readonly ICON_SIZE: number
  readonly PADDING: NavigationPadding
}

// 交互按钮配置接口
interface InteractionConfig {
  readonly AVATAR_SIZE: number
  readonly BUTTON_SIZE: number
  readonly FOLLOW_BUTTON_SIZE: number
  readonly MARGIN_BETWEEN: number
  readonly FONT_SIZE: number
}

// 描述内边距配置接口
interface DescriptionPadding {
  readonly LEFT: number
  readonly RIGHT: number
  readonly BOTTOM: number
}

// 视频描述配置接口
interface DescriptionConfig {
  readonly TITLE_FONT_SIZE: number
  readonly AUTHOR_FONT_SIZE: number
  readonly MAX_LINES: number
  readonly PADDING: DescriptionPadding
}

// 颜色配置接口
interface Colors {
  readonly PRIMARY: string
  readonly SECONDARY: string
  readonly TEXT_PRIMARY: string
  readonly TEXT_SECONDARY: string
  readonly OVERLAY_BACKGROUND: string
  readonly DESCRIPTION_BACKGROUND: string
}

// 动画配置接口
interface AnimationConfig {
  readonly DURATION: number
  readonly CURVE: Curve
}

// 圆角配置接口
interface BorderRadius {
  readonly SMALL: number
  readonly MEDIUM: number
  readonly LARGE: number
}

// 内边距配置接口
interface Padding {
  readonly SMALL: number
  readonly MEDIUM: number
  readonly LARGE: number
}

// 布局配置接口
interface LayoutConfig {
  readonly BORDER_RADIUS: BorderRadius
  readonly PADDING: Padding
}

export class UIConstants {
  // 导航配置
  static readonly NAVIGATION_CONFIG: NavigationConfig = {
    HEIGHT: 48,
    TAB_FONT_SIZE: 18,
    ICON_SIZE: 24,
    PADDING: {
      LEFT: 16,
      RIGHT: 16
    }
  }

  // 交互按钮配置
  static readonly INTERACTION_CONFIG: InteractionConfig = {
    AVATAR_SIZE: 48,
    BUTTON_SIZE: 32,
    FOLLOW_BUTTON_SIZE: 20,
    MARGIN_BETWEEN: 16,
    FONT_SIZE: 12
  }

  // 视频描述配置
  static readonly DESCRIPTION_CONFIG: DescriptionConfig = {
    TITLE_FONT_SIZE: 14,
    AUTHOR_FONT_SIZE: 16,
    MAX_LINES: 2,
    PADDING: {
      LEFT: 16,
      RIGHT: 80,
      BOTTOM: 16
    }
  }

  // 颜色配置
  static readonly COLORS: Colors = {
    PRIMARY: '#FF4757',
    SECONDARY: '#FFD700',
    TEXT_PRIMARY: '#FFFFFF',
    TEXT_SECONDARY: '#666666',
    OVERLAY_BACKGROUND: 'rgba(0, 0, 0, 0.7)',
    DESCRIPTION_BACKGROUND: 'rgba(0, 0, 0, 0.3)'
  }

  // 动画配置
  static readonly ANIMATION_CONFIG: AnimationConfig = {
    DURATION: 300,
    CURVE: Curve.EaseInOut
  }

  // 布局配置
  static readonly LAYOUT_CONFIG: LayoutConfig = {
    BORDER_RADIUS: {
      SMALL: 4,
      MEDIUM: 20,
      LARGE: 24
    },
    PADDING: {
      SMALL: 4,
      MEDIUM: 8,
      LARGE: 12
    }
  }
}
