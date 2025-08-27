import { HomeTab } from '../viewModel/HomeViewModel'
import { UIConstants } from '../constants/UIConstants'
import { UIUtils } from '../utils/UIUtils'

@Component
export struct TopNavigation {
  // 外部属性
  @Prop currentTab: HomeTab
  // 事件回调
  onTabChange?: (tab: HomeTab) => void
  onMenuClick?: () => void
  onSearchClick?: () => void
  // 内部状态
  @State private currentIndex: number = 0
  private tabs: HomeTab[] = [HomeTab.RECOMMEND, HomeTab.FOLLOW]

  build() {
    Row() {
      this.MenuButton()
      this.TabSection()
      this.SearchButton()
    }
    .width('100%')
    .height(UIConstants.NAVIGATION_CONFIG.HEIGHT)
    .backgroundColor($r('sys.color.black'))
    .justifyContent(FlexAlign.SpaceBetween)
    .alignItems(VerticalAlign.Center)
  }

  @Builder
  MenuButton() {
    Image($r('app.media.left_nav'))
      .width(UIConstants.NAVIGATION_CONFIG.ICON_SIZE)
      .height(UIConstants.NAVIGATION_CONFIG.ICON_SIZE)
      .fillColor(UIConstants.COLORS.TEXT_PRIMARY)
      .margin({ left: UIConstants.NAVIGATION_CONFIG.PADDING.LEFT })
      .onClick(() => this.handleMenuClick())
  }

  @Builder
  TabSection() {
    Row() {
      ForEach(this.tabs, (tab: HomeTab, index: number) => {
        this.TabItem(tab, index)
      })
    }
    .layoutWeight(1)
    .justifyContent(FlexAlign.Center)
  }

  @Builder
  TabItem(tab: HomeTab, index: number) {
    Text(tab)
      .fontSize(UIConstants.NAVIGATION_CONFIG.TAB_FONT_SIZE)
      .fontColor(this.getTabColor(tab))
      .fontWeight(this.getTabFontWeight(tab))
      .onClick(() => this.handleTabClick(tab, index))
      .margin({ right: this.getTabMargin(tab) })
  }

  @Builder
  SearchButton() {
    Image($r('app.media.search'))
      .width(UIConstants.NAVIGATION_CONFIG.ICON_SIZE)
      .height(UIConstants.NAVIGATION_CONFIG.ICON_SIZE)
      .fillColor(UIConstants.COLORS.TEXT_PRIMARY)
      .margin({ right: UIConstants.NAVIGATION_CONFIG.PADDING.RIGHT })
      .onClick(() => this.handleSearchClick())
  }

  private handleTabClick(tab: HomeTab, index: number): void {
    if (this.currentTab !== tab) {
      this.currentIndex = index
      this.onTabChange?.(tab)
      console.log(`TopNavigation: 切换到标签页 ${tab}`)
    }
  }

  private handleMenuClick(): void {
    // 通过事件回调交给父组件处理
    this.onMenuClick?.()
    console.log('TopNavigation: 菜单按钮点击 - 触发事件回调')
  }

  private handleSearchClick(): void {
    // 通过事件回调交给父组件处理
    this.onSearchClick?.()
    console.log('TopNavigation: 搜索按钮点击 - 触发事件回调')
  }

  private getTabColor(tab: HomeTab): string {
    return this.currentTab === tab
      ? UIConstants.COLORS.TEXT_PRIMARY
      : UIConstants.COLORS.TEXT_SECONDARY
  }

  private getTabFontWeight(tab: HomeTab): FontWeight {
    return UIUtils.getFontWeight(this.currentTab === tab)
  }

  private getTabMargin(tab: HomeTab): number {
    return tab === HomeTab.RECOMMEND ? 32 : 0
  }

  aboutToAppear() {
    this.currentIndex = this.tabs.indexOf(this.currentTab)
    if (this.currentIndex === -1) {
      this.currentIndex = 0
    }
    console.log(`TopNavigation: 组件初始化完成，当前标签页: ${this.currentTab}`)
  }

  aboutToUpdate() {
    const newIndex = this.tabs.indexOf(this.currentTab)
    if (newIndex !== -1 && newIndex !== this.currentIndex) {
      this.currentIndex = newIndex
      console.log(`TopNavigation: 外部状态同步，当前标签页: ${this.currentTab}`)
    }
  }
}