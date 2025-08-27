// 视频数据模型
export interface VideoItem {
  id: string
  url: string
  title: string
  description: string
  author: string
  // 视频相关属性
  thumbnail?: string        // 视频缩略图
  duration?: number         // 视频时长（秒）
  format?: string          // 视频格式
}

// 视频列表数据
export class VideoData {
  static getVideoList(): VideoItem[] {
    return [
      {
        id: '1',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
        title: 'MC我的世界:变异铁傀儡来袭!究竟什么才能击败它? #我的世...展开',
        description: '麦琪我怎么会拿这种事情',
        author: '@MC杰杰&麦琪',
        thumbnail: 'https://example.com/thumb1.jpg',
        duration: 180,
        format: 'mp4'
      },
      {
        id: '2',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
        title: '我的世界生存模式:建造豪华别墅 #建筑 #生存...展开',
        description: '今天我们来建造一个超级豪华的别墅',
        author: '@建筑大师',
        thumbnail: 'https://example.com/thumb2.jpg',
        duration: 240,
        format: 'mp4'
      },
      {
        id: '3',
        url: 'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
        title: '红石机关教程:自动农场 #红石 #教程...展开',
        description: '学会这个红石机关，轻松实现自动化',
        author: '@红石专家',
        thumbnail: 'https://example.com/thumb3.jpg',
        duration: 120,
        format: 'mp4'
      }
    ]
  }
}
