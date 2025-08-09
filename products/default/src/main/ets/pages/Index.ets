import { BreakpointSystem } from 'utils';
import { BreakpointTypeEnum } from 'utils/src/main/ets/utils/BreakpointSystem';

@Entry
@Component
struct Index {
  @State currentIndex: number = 0;
  @StorageProp('currentBreakpoint') currentBreakpoint: string = BreakpointTypeEnum.MD;
  private tabsController : TabsController = new TabsController();
  private breakpointSystem: BreakpointSystem = new BreakpointSystem();

  aboutToAppear() {
    this.breakpointSystem.register();
  }

  aboutToDisappear() {
    this.breakpointSystem.unregister();
  }

  @Builder
  tabBarBuilder(title: string, targetIndex: number, selectedIcon: Resource, unselectIcon: Resource) {
    Column() {
      Image(this.currentIndex === targetIndex ? selectedIcon : unselectIcon)
        .width(24)
        .height(24)
      Text(title)
        .fontFamily('HarmonyHeiTi-Medium')
        .fontSize(10)
        .fontColor(this.currentIndex === targetIndex ? '#ffffff' : 'rgba(0,0,0,0.60)')
        .textAlign(TextAlign.Center)
        .lineHeight(14)
        .fontWeight(500)
        .margin({ top: 4 })
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }

  @Builder
  uploadTabBarBuilder(targetIndex: number) {
    Column() {
      Stack() {
        Rect()
          .width(44)
          .height(33)
          .radius(8)
          .fill($r('sys.color.comp_background_list_card'))
          .shadow({
            radius: 4,
            color: 'rgba(0,0,0,0.1)',
            offsetX: 0,
            offsetY: 2
          })
        Text('+')
          .fontSize(24)
          .fontWeight(FontWeight.Bold)
          .fontColor($r('sys.color.black'))
      }
    }
    .width('100%')
    .height('100%')
    .justifyContent(FlexAlign.Center)
    .alignItems(HorizontalAlign.Center)
    .onClick(() => {
      this.currentIndex = targetIndex;
      this.tabsController.changeIndex(targetIndex);
    })
  }

  build() {
    Tabs({
      barPosition: this.currentBreakpoint === BreakpointTypeEnum.LG ?
      BarPosition.Start :
      BarPosition.End,
      controller: this.tabsController
    }) {
      TabContent() {

        }.tabBar(this.tabBarBuilder("首页", 0 , $r("app.media.home_full"), $r("app.media.home")))

      TabContent() {

      }.tabBar(this.uploadTabBarBuilder(1))

      TabContent() {

      }.tabBar(this.tabBarBuilder("我", 2, $r("app.media.mine_full"), $r("app.media.mine")))
    }
    .scrollable(false)
    .vertical(this.currentBreakpoint === BreakpointTypeEnum.LG ? true : false)
    .divider({
      strokeWidth: 0.5,
      color: '#0D182431'
    })
    .backgroundColor('#2c2c2c')
    .padding({ top: 36, bottom: 28 })
  }
}