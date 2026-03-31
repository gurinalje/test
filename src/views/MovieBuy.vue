<template>
  <div class="page-container">
    <NavBar />
    <main class="content-container card">
      <el-steps :active="activeStep" finish-status="success" align-center style="margin-bottom: 40px;">
        <el-step title="1. 选择座位" />
        <el-step title="2. 确认订单并支付" />
        <el-step title="3. 购票完成" />
      </el-steps>

      <div v-if="activeStep === 0" class="step-content seat-step">
        <div class="seat-map-container">
          <div class="screen-curve">银幕中央</div>
          <div class="seat-grid">
            <div class="seat-row" v-for="(row, rowIndex) in seats" :key="rowIndex">
              <span class="row-num">{{ rowIndex + 1 }}</span>
              <div
                  v-for="(seat, colIndex) in row"
                  :key="colIndex"
                  class="seat"
                  :class="{ 'sold': seat === 1, 'selected': seat === 2, 'available': seat === 0 }"
                  @click="toggleSeat(rowIndex, colIndex)"
              ></div>
            </div>
          </div>
          <div class="seat-legend">
            <div class="legend-item"><div class="seat available"></div> 可选</div>
            <div class="legend-item"><div class="seat sold"></div> 已售</div>
            <div class="legend-item"><div class="seat selected"></div> 已选</div>
          </div>
        </div>

        <div class="movie-side-panel">
          <div class="movie-info-header">
            <div class="side-text">
              <h3>{{ scheduleInfo.movieName || '加载中...' }}</h3>
              <p>影厅：{{ scheduleInfo.hallName }}</p>
              <p>票价：<span style="color: #ed5565; font-weight: bold;">￥{{ scheduleInfo.fare }}</span> / 张</p>
            </div>
          </div>
          <el-divider />
          <div class="schedule-details">
            <p><strong>已选座位：</strong></p>
            <div style="display: flex; flex-wrap: wrap; gap: 5px; margin-bottom: 15px;">
              <el-tag v-for="seat in selectedSeats" :key="seat.rowIndex + '-' + seat.columnIndex" type="success" effect="dark">
                {{ seat.rowIndex + 1 }}排{{ seat.columnIndex + 1 }}座
              </el-tag>
              <span v-if="selectedSeats.length === 0" style="color: #999; font-size: 13px;">请在左侧点击选座</span>
            </div>
          </div>
          <div class="total-price-display">
            总计：<span class="price-text" style="color: #ed5565; font-weight: bold; font-size: 24px;">￥{{ totalFare.toFixed(2) }}</span>
          </div>
          <el-button type="primary" size="large" class="submit-btn" :disabled="selectedSeats.length === 0" @click="confirmSeats">
            🔒 确认选座 (锁定座位)
          </el-button>
        </div>
      </div>

      <div v-if="activeStep === 1" class="step-content pay-step" style="text-align: center; padding: 40px;">
        <h2>请选择支付方式</h2>
        <p style="color: #666; margin-bottom: 30px;">
          您已成功锁定 <strong>{{ selectedSeats.length }}</strong> 个座位，请在 15 分钟内完成支付。
          <br>待支付总额：<span style="color: #ed5565; font-size: 24px; font-weight: bold;">￥{{ totalFare.toFixed(2) }}</span>
        </p>

        <div style="display: flex; justify-content: center; gap: 30px;">
          <el-button type="success" size="large" @click="bankCardDialogVisible = true" style="width: 200px; height: 60px; font-size: 18px;">
            💳 银行卡支付
          </el-button>
          <el-button color="#f7d393" size="large" @click="handlePay(true)" style="width: 200px; height: 60px; font-size: 18px; color: #333;">
            👑 VIP 余额支付
          </el-button>
        </div>
        <el-button type="text" style="margin-top: 20px; color: #999;" @click="activeStep = 0">返回重选</el-button>
      </div>

      <div v-if="activeStep === 2" class="step-content success-step" style="text-align: center; padding: 60px;">
        <div style="font-size: 80px;">✅</div>
        <h2 style="margin-top: 20px;">🎉 购票成功！</h2>
        <p style="color: #666;">您的电影票已出票，请提前到影城取票观影。</p>
        <div style="margin-top: 30px;">
          <el-button type="primary" @click="router.push('/userBuy')">查看我的电影票</el-button>
          <el-button @click="router.push('/home')">返回首页</el-button>
        </div>
      </div>

      <el-dialog v-model="bankCardDialogVisible" title="银行卡支付" width="400px">
        <el-form :model="bankCardForm" label-width="80px">
          <el-form-item label="银行卡号">
            <el-input v-model="bankCardForm.account" placeholder="请输入您的银行卡号" clearable></el-input>
          </el-form-item>
          <el-form-item label="支付密码">
            <el-input v-model="bankCardForm.password" type="password" placeholder="请输入6位支付密码" show-password></el-input>
          </el-form-item>
        </el-form>
        <template #footer>
          <span class="dialog-footer">
            <el-button @click="bankCardDialogVisible = false">取消支付</el-button>
            <el-button type="primary" @click="confirmBankCardPay">确认付款</el-button>
          </span>
        </template>
      </el-dialog>

    </main>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import axios from 'axios'
import { ElMessage } from 'element-plus'
import NavBar from '../components/NavBar.vue' // 如果控制台还报NavBar找不到，请检查你实际的文件结构

const route = useRoute()
const router = useRouter()
const scheduleId = route.query.scheduleId

const activeStep = ref(0)
const scheduleInfo = ref({})
const seats = ref([])
const lockedTicketIds = ref([])

const bankCardDialogVisible = ref(false)
const bankCardForm = reactive({ account: '', password: '' })

// 🚀 核心排查点：用户数据获取
console.log("=== 正在获取本地用户信息 ===")
const userStr = localStorage.getItem('user')
console.log("【1】LocalStorage 中存储的用户数据:", userStr)
let currentUser = {}
try {
  currentUser = userStr ? JSON.parse(userStr) : {}
} catch (e) {
  console.error("解析用户数据失败:", e)
}
console.log("【2】解析后的 currentUser 对象:", currentUser)

const fetchSeatData = async () => {
  try {
    const res = await axios.get(`/api/ticket/get/occupiedSeats?scheduleId=${scheduleId}`)
    if (res.data.success) {
      scheduleInfo.value = res.data.content.scheduleItem || {}
      seats.value = res.data.content.seats || []
    }
  } catch (e) {
    console.error('获取座位失败:', e)
  }
}

const toggleSeat = (rowIndex, colIndex) => {
  if (seats.value[rowIndex][colIndex] === 1) return
  if (seats.value[rowIndex][colIndex] === 0) {
    seats.value[rowIndex][colIndex] = 2
  } else {
    seats.value[rowIndex][colIndex] = 0
  }
}

const selectedSeats = computed(() => {
  const res = []
  for (let r = 0; r < seats.value.length; r++) {
    for (let c = 0; c < seats.value[r].length; c++) {
      if (seats.value[r][c] === 2) res.push({ rowIndex: r, columnIndex: c })
    }
  }
  return res
})

const totalFare = computed(() => selectedSeats.value.length * (scheduleInfo.value.fare || 0))

// 确认选座 (锁座)
const confirmSeats = async () => {
  // 💣 拦截致命 Bug：如果没拿到真实的 ID，直接阻断！
  if (!currentUser || !currentUser.id) {
    console.error("🚨 致命异常：获取不到当前用户ID，如果继续往下走，会导致产生一张 0号用户 的幽灵票！")
    return ElMessage.error('账号状态异常（ID丢失），请务必退出重新登录！')
  }

  const payload = {
    userId: currentUser.id,
    scheduleId: parseInt(scheduleId),
    seats: selectedSeats.value
  }
  console.log("【3】发起锁座请求，发送给后端的参数:", payload)

  try {
    const res = await axios.post('/api/ticket/lockSeat', payload)
    console.log("【4】后端锁座接口返回的原始数据:", res.data)

    if (res.data.success) {
      const content = res.data.content
      if (content && content.ticketVOList) {
        lockedTicketIds.value = content.ticketVOList.map(t => t.id)
      } else if (Array.isArray(content)) {
        lockedTicketIds.value = content.map(t => t.id)
      } else if (content && content.id) {
        lockedTicketIds.value = [content.id]
      } else {
        lockedTicketIds.value = []
      }

      console.log("【5】前端解析出的最终票据 IDs:", lockedTicketIds.value)

      if (lockedTicketIds.value.length === 0) {
        return ElMessage.error('锁座异常：未能从后端获取到电影票 ID！')
      }
      activeStep.value = 1
    } else {
      ElMessage.error(res.data.message || '手慢了，座位刚被抢走啦！')
    }
  } catch (e) {
    console.error("前端解析或网络异常:", e)
  }
}

const confirmBankCardPay = async () => {
  if (!bankCardForm.account || !bankCardForm.password) {
    return ElMessage.warning('请完整填写银行卡号和密码！')
  }
  bankCardDialogVisible.value = false
  await handlePay(false)
}

const handlePay = async (isVip) => {
  console.log(`【6】准备发起支付，支付方式: ${isVip ? 'VIP' : '银行卡'}，票据IDs:`, lockedTicketIds.value)

  const url = isVip ? '/api/ticket/vip/buy' : '/api/ticket/buy'
  try {
    const searchParams = new URLSearchParams()
    lockedTicketIds.value.forEach(id => searchParams.append('ticketId', id))
    searchParams.append('couponId', 0)

    console.log("【7】最终发送的支付URL和参数:", `${url}?${searchParams.toString()}`)
    const res = await axios.post(`${url}?${searchParams.toString()}`)
    console.log("【8】支付接口返回数据:", res.data)

    if (res.data.success) {
      activeStep.value = 2 // 🎉 支付成功
    } else {
      ElMessage.error(res.data.message || (isVip ? 'VIP余额不足或未开通！' : '支付失败'))
    }
  } catch (e) {
    console.error('支付抛出异常:', e)
    ElMessage.error('支付抛出异常，请检查 F12 控制台')
  }
}

onMounted(() => {
  fetchSeatData()
})
</script>

<style scoped>
/* 保持所有样式不变 */
.page-container {
  min-height: 100vh;
  background-color: #f5f7fa;
  padding-bottom: 40px;
}

.content-container {
  max-width: 1000px;
  margin: 30px auto;
}

.card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  padding: 30px;
}

.seat-step {
  display: flex;
  gap: 40px;
}

.seat-map-container {
  flex: 1;
  display: flex;
  flex-direction: column;
  align-items: center;
}

.screen-curve {
  width: 80%;
  height: 30px;
  background: #e0e0e0;
  border-radius: 50% / 100% 100% 0 0;
  text-align: center;
  line-height: 30px;
  color: #666;
  font-size: 14px;
  margin-bottom: 40px;
}

.seat-grid {
  display: flex;
  flex-direction: column;
  gap: 10px;
}

.seat-row {
  display: flex;
  align-items: center;
  gap: 10px;
}

.row-num {
  width: 20px;
  text-align: right;
  color: #999;
  font-size: 14px;
  margin-right: 10px;
}

.seat {
  width: 30px;
  height: 30px;
  border-radius: 6px 6px 2px 2px;
  cursor: pointer;
  transition: 0.2s;
}

.seat.available {
  background-color: #e0e0e0;
}

.seat.available:hover {
  background-color: #1caf9a;
}

.seat.selected {
  background-color: #1caf9a;
  box-shadow: 0 2px 5px rgba(28, 175, 154, 0.4);
}

.seat.sold {
  background-color: #ed5565;
  cursor: not-allowed;
}

.seat-legend {
  display: flex;
  gap: 20px;
  margin-top: 40px;
}

.legend-item {
  display: flex;
  align-items: center;
  gap: 8px;
  font-size: 14px;
  color: #666;
}

.movie-side-panel {
  width: 320px;
  background: #fafafa;
  border: 1px solid #eee;
  border-radius: 8px;
  padding: 25px;
  display: flex;
  flex-direction: column;
}

.movie-info-header {
  display: flex;
  gap: 15px;
}

.side-text h3 {
  margin: 0 0 10px 0;
  font-size: 20px;
  color: #333;
}

.side-text p {
  margin: 0 0 5px 0;
  font-size: 14px;
  color: #666;
}

.schedule-details p {
  margin: 0 0 12px 0;
  font-size: 14px;
  color: #444;
}

.total-price-display {
  margin-top: auto;
  font-size: 16px;
  margin-bottom: 20px;
  text-align: right;
}

.submit-btn {
  width: 100%;
  border-radius: 20px;
}
</style>