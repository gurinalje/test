<template>
  <div class="page-container">
    <NavBar />

    <main class="content-container">
      <div class="movie-container">
        <div class="panel-header">
          <span class="panel-title">🔥 热映电影</span>
          <span class="panel-more" @click="router.push('/movie')">全部 ></span>
        </div>
        <div class="movie-list card">
          <el-empty v-if="nowPlaying.length === 0" description="暂无热映电影" style="width: 100%;" />

          <div class="movie-item" v-for="movie in nowPlaying" :key="movie.id">
            <div class="movie-poster" @click="goToDetail(movie.id)">
              <img :src="movie.posterUrl || movie.poster" alt="poster" />
              <div class="movie-overlay">
                <div class="movie-info">{{ movie.name }}</div>
              </div>
            </div>
            <el-button type="primary" class="action-btn" @click="goToBuy(movie.id)">购 票</el-button>
          </div>
        </div>

        <div class="panel-header" style="margin-top: 40px;">
          <span class="panel-title">⏳ 即将上映</span>
        </div>
        <div class="movie-list card">
          <el-empty v-if="comingSoon.length === 0" description="暂无即将上映" style="width: 100%;" />

          <div class="movie-item" v-for="movie in comingSoon" :key="movie.id">
            <div class="movie-poster" @click="goToDetail(movie.id)">
              <img :src="movie.posterUrl || movie.poster" alt="poster" />
              <div class="movie-overlay">
                <div class="movie-info">{{ movie.name }}</div>
              </div>
            </div>
            <el-button type="warning" plain class="action-btn" @click="goToPreview(movie.id)">预 览</el-button>
          </div>
        </div>
      </div>

      <aside class="statistic-container">
        <p class="panel-title">📈 影院票房排行</p>
        <div class="stat-list card">
          <div class="stat-item" v-for="(item, index) in boxOffice" :key="index">
            <span class="stat-name"><span class="rank">{{ index + 1 }}</span> {{ item.name }}</span>
            <span class="stat-value">￥ {{ item.value }}</span>
          </div>
        </div>

        <p class="panel-title" style="margin-top: 30px;">🌟 最受欢迎影星 (示例)</p>
        <div class="stat-list card">
          <div class="stat-item" v-for="(actor, index) in popularActors" :key="index">
            <span class="stat-name"><span class="rank">{{ index + 1 }}</span> {{ actor.name }}</span>
            <span class="stat-value">{{ actor.value }} 票</span>
          </div>
        </div>
      </aside>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import NavBar from '../components/NavBar.vue'
import axios from 'axios' // 👉 引入 axios 发送网络请求

const router = useRouter()

// 页面跳转方法
// 👇 全部替换为真实的路由跳转，携带当前电影的 ID 传递给下一个页面
const goToDetail = (id) => router.push(`/movieDetail?id=${id}`)
const goToBuy = (id) => router.push(`/movieDetail?id=${id}`)
const goToPreview = (id) => router.push(`/movieDetail?id=${id}`)

// ======== 响应式数据 ========
const nowPlaying = ref([])
const comingSoon = ref([])
const boxOffice = ref([])

// 演员排行因为后端没有现成接口，暂时用假数据兜底，保证页面美观
const popularActors = ref([
  { name: '吴京', value: 9982 },
  { name: '沈腾', value: 8541 },
  { name: '刘德华', value: 7654 }
])

// ======== 核心：从后端抓取真实数据 ========
const fetchHomeData = async () => {
// 1. 获取所有电影 (智能按时间分类)
  try {
    const movieRes = await axios.get('/api/movie/all/exclude/off')
    if (movieRes.data.success) {
      const allMovies = movieRes.data.content
      const now = new Date() // 获取当前时间

      // 🌟 核心业务逻辑：通过比对上映时间和当前时间来智能分类
      nowPlaying.value = allMovies.filter(m => {
        // 如果后端传的字段叫 startDate 或者 start_date
        const releaseDate = new Date(m.startDate || m.start_date)
        return releaseDate <= now
      })

      comingSoon.value = allMovies.filter(m => {
        const releaseDate = new Date(m.startDate || m.start_date)
        return releaseDate > now
      })
    }
  } catch (error) {
    console.error('获取真实电影列表失败，请检查接口路径', error)
  }

  // 2. 获取真实票房排行 (直接复用我们后台修好的神仙接口)
  try {
    const boxRes = await axios.get('/api/statistics/boxOffice/total')
    if (boxRes.data.success && boxRes.data.content) {
      // 取前 5 名，并映射成我们页面需要的 name 和 value 格式
      boxOffice.value = boxRes.data.content.slice(0, 5).map(item => ({
        name: item.name,
        value: item.boxOffice || 0
      }))
    }
  } catch (error) {
    console.warn('获取真实票房失败', error)
  }
}

// 页面加载时执行
onMounted(() => {
  fetchHomeData()
})
</script>

<style scoped>
/* (下方的 CSS 代码完全没动，保留你原本完美的设计) */
.page-container { min-height: 100vh; background-color: #f5f7fa; }
.content-container { display: flex; max-width: 1200px; margin: 30px auto; gap: 30px; }
.card { background: #fff; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); padding: 20px; }
.panel-header { display: flex; justify-content: space-between; align-items: center; margin-bottom: 15px; padding-left: 10px; border-left: 5px solid #1caf9a; }
.panel-title { font-size: 20px; font-weight: bold; color: #333; }
.panel-more { color: #1caf9a; cursor: pointer; font-size: 14px; }
.movie-container { flex: 1; }
.movie-list { display: flex; flex-wrap: wrap; gap: 25px; }
.movie-item { width: 140px; display: flex; flex-direction: column; }
.movie-poster { width: 140px; height: 196px; border-radius: 6px; overflow: hidden; position: relative; cursor: pointer; box-shadow: 0 2px 8px rgba(0,0,0,0.1); transition: transform 0.3s; }
.movie-poster:hover { transform: translateY(-5px); }
.movie-poster img { width: 100%; height: 100%; object-fit: cover; }
.movie-overlay { position: absolute; bottom: 0; width: 100%; height: 40px; background: linear-gradient(transparent, rgba(0,0,0,0.8)); display: flex; align-items: flex-end; padding: 8px; box-sizing: border-box; }
.movie-info { color: white; font-size: 14px; white-space: nowrap; overflow: hidden; text-overflow: ellipsis; }
.action-btn { margin-top: 10px; width: 100%; border-radius: 20px; }
.statistic-container { width: 300px; }
.stat-list { display: flex; flex-direction: column; gap: 15px; }
.stat-item { display: flex; justify-content: space-between; align-items: center; padding-bottom: 10px; border-bottom: 1px dashed #eee; }
.stat-item:last-child { border-bottom: none; padding-bottom: 0; }
.stat-name { font-size: 15px; color: #444; }
.rank { display: inline-block; width: 20px; height: 20px; background-color: #1caf9a; color: white; text-align: center; line-height: 20px; border-radius: 3px; margin-right: 5px; font-size: 12px; }
.stat-item:nth-child(1) .rank { background-color: #ed5565; }
.stat-item:nth-child(2) .rank { background-color: #f8ac59; }
.stat-item:nth-child(3) .rank { background-color: #f8ac59; }
.stat-value { color: #ed5565; font-weight: bold; }
</style>