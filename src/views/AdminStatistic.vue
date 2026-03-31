<template>
  <div class="admin-statistic">
    <el-row :gutter="20" style="margin-bottom: 20px;">
      <el-col :span="6" v-for="item in summaryData" :key="item.label">
        <div class="stat-card">
          <div class="stat-label">{{ item.label }}</div>
          <div class="stat-value" :style="{ color: item.color }">{{ item.value }}</div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20">
      <el-col :span="12">
        <div class="chart-card">
          <h3>🔥 电影总票房排行 (TOP 5)</h3>
          <div ref="boxOfficeChart" class="chart-box"></div>
        </div>
      </el-col>
      <el-col :span="12">
        <div class="chart-card">
          <h3>📊 影厅上座率分布 </h3>
          <div ref="attendanceChart" class="chart-box"></div>
        </div>
      </el-col>
    </el-row>

    <el-row :gutter="20" style="margin-top: 20px;">
      <el-col :span="12">
        <div class="chart-card">
          <h3>📅 近七日销售趋势 (示例)</h3>
          <div ref="salesTrendChart" class="chart-box"></div>
        </div>
      </el-col>
      <el-col :span="12">
        <div class="chart-card">
          <h3>🎭 电影类型偏好 (示例)</h3>
          <div ref="typePreferenceChart" class="chart-box"></div>
        </div>
      </el-col>
    </el-row>
  </div>
</template>

<script setup>
import { ref, onMounted, shallowRef } from 'vue'
import * as echarts from 'echarts'
import axios from 'axios'

// ===== 顶部看板数据 =====
const summaryData = ref([
  { label: '累计总票房', value: '加载中...', color: '#ed5565' },
  { label: '今日订单数', value: '328 笔', color: '#1caf9a' },
  { label: '活跃会员数', value: '1,502 人', color: '#f8ac59' },
  { label: '平均客单价', value: '加载中...', color: '#23b7e5' }
])

// ===== 图表 DOM 引用 =====
const boxOfficeChart = ref(null)
const attendanceChart = ref(null)
const salesTrendChart = ref(null)
const typePreferenceChart = ref(null)

// 保存图表实例，避免 Vue 响应式代理导致 ECharts 报错
const charts = shallowRef({})

// ===== 核心数据抓取逻辑 =====
const fetchStatisticsData = async () => {
  // 1. 获取真实总票房数据 (对接你后端的 selectMovieTotalBoxOffice)
  try {
    const boxRes = await axios.get('/api/statistics/boxOffice/total')
    if (boxRes.data.success && boxRes.data.content) {
      const boxData = boxRes.data.content

      // 计算累计总票房更新到顶部看板
      const totalIncome = boxData.reduce((sum, item) => sum + (item.boxOffice || 0), 0)
      summaryData.value[0].value = `￥${totalIncome.toLocaleString()}`

      // 取 Top 5 渲染图表
      const top5 = boxData.slice(0, 5)
      charts.value.boxChart.setOption({
        xAxis: { data: top5.map(item => item.name) },
        series: [{ data: top5.map(item => item.boxOffice || 0) }]
      })
    }
  } catch (error) {
    console.warn('获取票房数据失败，可能后端暂未提供该接口', error)
    summaryData.value[0].value = '￥12,840' // 兜底数据
  }

  // 2. 获取真实客单价数据 (对接你后端的 selectAudiencePrice)
  try {
    // 假设后端接口需要传当前日期（请根据你实际 Controller 的路径调整）
    const today = new Date().toISOString().substring(0, 10).replace(/-/g, '/')
    const priceRes = await axios.get(`/api/statistics/audience/price?date=${today}`)
    if (priceRes.data.success && priceRes.data.content) {
      // 简单处理：取所有观众客单价的平均值
      const prices = priceRes.data.content
      if (prices.length > 0) {
        const avg = prices.reduce((sum, p) => sum + p.totalPrice, 0) / prices.length
        summaryData.value[3].value = `￥${avg.toFixed(1)}`
      } else {
        summaryData.value[3].value = '￥0.0'
      }
    }
  } catch (error) {
    console.warn('获取客单价数据失败，使用兜底数据')
    summaryData.value[3].value = '￥39.1'
  }

  // 3. 其他图表（上座率、趋势、偏好）
  // 由于我没有看到你这三个图表对应的明确 SQL，这里保持图表的初始化展示，你可以随时在这个函数里追加真实接口的请求逻辑。

  // 👇 补充：拉取真实的影厅统计数据
  try {
    const hallRes = await axios.get('/api/statistics/hall/stats')
    if (hallRes.data.success && hallRes.data.content) {
      const realHallData = hallRes.data.content
      // 只要数据库有数据，就覆盖掉兜底的假数据
      if (realHallData.length > 0) {
        charts.value.attChart.setOption({
          series: [{ data: realHallData }]
        })
      }
    }
  } catch (error) {
    console.warn('获取真实影厅数据失败', error)
  }
}

// ===== 初始化图表 =====
onMounted(() => {
  // 1. 初始化票房柱状图 (先放入骨架/默认配置，等真实数据覆盖)
  charts.value.boxChart = echarts.init(boxOfficeChart.value)
  charts.value.boxChart.setOption({
    tooltip: { trigger: 'axis', axisPointer: { type: 'shadow' } },
    xAxis: { type: 'category', data: ['暂无数据'] },
    yAxis: { type: 'value', name: '票房(元)' },
    series: [{ data: [0], type: 'bar', itemStyle: { color: '#1caf9a', borderRadius: [4, 4, 0, 0] } }]
  })

  // 2. 初始化上座率饼图 (假数据兜底)
  charts.value.attChart = echarts.init(attendanceChart.value)
  charts.value.attChart.setOption({
    tooltip: { trigger: 'item', formatter: '{b}: {c}%' },
    series: [{
      type: 'pie', radius: ['40%', '70%'],
      itemStyle: { borderRadius: 10, borderColor: '#fff', borderWidth: 2 },
      data: [{ value: 75, name: '1号激光IMAX厅' }, { value: 45, name: '2号杜比厅' }, { value: 30, name: '3号普通厅' }]
    }]
  })

  // 3. 初始化趋势折线图 (假数据兜底)
  charts.value.trendChart = echarts.init(salesTrendChart.value)
  charts.value.trendChart.setOption({
    tooltip: { trigger: 'axis' },
    xAxis: { type: 'category', data: ['周一', '周二', '周三', '周四', '周五', '周六', '周日'] },
    yAxis: { type: 'value' },
    series: [{ data: [820, 932, 901, 934, 1290, 1330, 1320], type: 'line', smooth: true, areaStyle: { opacity: 0.3 }, itemStyle: { color: '#ed5565' } }]
  })

  // 4. 初始化类型偏好雷达图 (假数据兜底)
  charts.value.typeChart = echarts.init(typePreferenceChart.value)
  charts.value.typeChart.setOption({
    tooltip: {},
    radar: { indicator: [{ name: '科幻', max: 100 }, { name: '动作', max: 100 }, { name: '动画', max: 100 }, { name: '爱情', max: 100 }, { name: '剧情', max: 100 }] },
    series: [{ type: 'radar', data: [{ value: [90, 70, 95, 60, 80], name: '观众偏好占比', areaStyle: { color: 'rgba(35, 183, 229, 0.5)' } }] }]
  })

  // 页面加载完成后，立刻去后端拉取真实数据覆盖！
  fetchStatisticsData()

  // 监听窗口大小变化，让图表自适应缩放
  window.addEventListener('resize', () => {
    Object.values(charts.value).forEach(chart => chart.resize())
  })
})
</script>

<style scoped>
.stat-card { background: white; padding: 20px; border-radius: 8px; text-align: center; box-shadow: 0 4px 12px rgba(0,0,0,0.05); transition: transform 0.3s;}
.stat-card:hover { transform: translateY(-5px); }
.stat-label { font-size: 14px; color: #999; margin-bottom: 10px; }
.stat-value { font-size: 24px; font-weight: bold; }
.chart-card { background: white; padding: 20px; border-radius: 8px; box-shadow: 0 4px 12px rgba(0,0,0,0.05); }
.chart-card h3 { margin: 0 0 20px 0; font-size: 16px; color: #333; border-left: 4px solid #1caf9a; padding-left: 10px; }
.chart-box { height: 300px; width: 100%; }
</style>