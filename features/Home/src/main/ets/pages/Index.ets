import { VideoPlayer } from '../view/VideoPlayer'
import { InteractionButtons } from '../view/InteractionButtons'
import { TopNavigation } from '../view/TopNavigation'
import { VideoDescription } from '../view/VideoDescription'
import { VideoOverlay } from '../view/VideoOverlay'
import { HomeViewModel, HomeTab, InteractionState } from '../viewModel/HomeViewModel'
import { VideoData } from '../model/VideoModel'

@Entry
@Component
struct Index {
  @State homeViewModel: HomeViewModel = new HomeViewModel()
  // 事件处理器
  private handleTabChange = (tab: HomeTab) => {
    this.homeViewModel.switchTab(tab)
  }
  private handleFullScreenChange = (isFullScreen: boolean) => {
    this.homeViewModel.toggleFullScreen(isFullScreen)
  }
  private handleVideoIndexChange = (index: number) => {
    this.homeViewModel.updateVideoIndex(index)
  }
  private handleMenuClick = () => {
    console.log('Index: 处理菜单点击 - 唤出左侧NavigationView')
  }
  private handleSearchClick = () => {
    console.log('Index: 处理搜索点击 - 跳转搜索页面')
  }
  private handleLikeClick = () => {
    this.homeViewModel.toggleLike(this.homeViewModel.currentVideoIndex)
  }
  private handleFavoriteClick = () => {
    this.homeViewModel.toggleFavorite(this.homeViewModel.currentVideoIndex)
  }
  private handleCommentClick = () => {
    this.homeViewModel.incrementCommentCount(this.homeViewModel.currentVideoIndex)
  }
  private handleShareClick = () => {
    this.homeViewModel.incrementShareCount(this.homeViewModel.currentVideoIndex)
  }
  private handleFollowClick = () => {
    this.homeViewModel.toggleFollow(this.homeViewModel.currentVideoIndex)
  }
  private handleAuthorClick = () => {
    console.log('Index: 作者点击 - 跳转到作者页面')
  }
  private handleTitleClick = () => {
    console.log('Index: 标题点击 - 显示视频详情')
  }

  build() {
    Stack() {
      Column()
        .width('100%')
        .height('100%')
        .backgroundColor($r('sys.color.black'))

      Column() {
        TopNavigation({
          currentTab: this.homeViewModel.currentTab,
          onTabChange: this.handleTabChange,
          onMenuClick: this.handleMenuClick,
          onSearchClick: this.handleSearchClick
        })

        this.MainContentArea()
      }
      .width('100%')
      .height('100%')
    }
  }

  @Builder
  MainContentArea() {
    Stack() {
      // 视频播放器
      VideoPlayer({
        isFullScreen: this.homeViewModel.isFullScreen,
        currentVideoIndex: this.homeViewModel.currentVideoIndex,
        videoList: this.homeViewModel.videoList,
        onFullScreenChange: this.handleFullScreenChange,
        onVideoIndexChange: this.handleVideoIndexChange
      })

      // 非全屏时的覆盖层组件
      if (!this.homeViewModel.isFullScreen) {
        this.NonFullScreenOverlays()
      }
    }
    .width('100%')
    .layoutWeight(1)
  }

  @Builder
  NonFullScreenOverlays() {
    Stack() {
      // VideoOverlay({
      //   currentVideo: this.homeViewModel.currentVideo,
      //   isFullScreen: this.homeViewModel.isFullScreen,
      //   onFullScreenChange: this.handleFullScreenChange
      // })

      InteractionButtons({
        interactionState: this.homeViewModel.currentInteractionState,
        onLikeClick: this.handleLikeClick,
        onFavoriteClick: this.handleFavoriteClick,
        onCommentClick: this.handleCommentClick,
        onShareClick: this.handleShareClick,
        onFollowClick: this.handleFollowClick
      })
      .position({ x: '100%', y: '50%' })
      .translate({ x: -60, y: -100 })

      VideoDescription({
        currentVideo: this.homeViewModel.currentVideo,
        onAuthorClick: this.handleAuthorClick,
        onTitleClick: this.handleTitleClick
      })
      .position({ x: 0, y: '100%' })
      .translate({ y: -80 })
    }
    .width('100%')
    .height('100%')
  }

  aboutToAppear() {
    // 设置事件处理器
    this.homeViewModel.setEventHandlers({
      onTabChange: (tab: HomeTab) => {
        console.log(`切换到标签页: ${tab}`)
      },
      onFullScreenChange: (isFullScreen: boolean) => {
        console.log(`全屏状态变化: ${isFullScreen ? '进入全屏' : '退出全屏'}`)
      },
      onVideoIndexChange: (index: number) => {
        console.log(`视频索引变化: ${index}`)
      },
      onVideoListChange: (videoList) => {
        console.log(`视频列表变化: ${videoList.length} 个视频`)
      },
      onInteractionChange: (videoIndex: number, type: string, newState: InteractionState) => {
        console.log(`交互状态变化: 视频${videoIndex}, 类型${type}, 新状态:`, newState)
      }
    })

    // 初始化视频列表
    this.homeViewModel.setVideoList(VideoData.getVideoList())
  }

  aboutToDisappear() {
    this.homeViewModel.destroy()
  }
}