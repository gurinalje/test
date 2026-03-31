<template>
  <div class="page-container">
    <NavBar />
    <main class="content-container">
      <div class="card">
        <div class="header-title"><h2>💰 充值与消费记录</h2></div>
        <el-tabs v-model="activeTab" class="custom-tabs">
          <el-tab-pane label="💳 消费记录" name="consume">
            <el-table :data="consumeRecords" stripe style="width: 100%" :empty-text="'暂无消费记录'">
              <el-table-column prop="time" label="时间" width="220" />
              <el-table-column prop="amount" label="金额 (元)" width="150">
                <template #default="scope"><span style="color: #ed5565; font-weight: bold; font-size: 16px;">- {{ scope.row.amount.toFixed(2) }}</span></template>
              </el-table-column>
              <el-table-column prop="type" label="类型" />
            </el-table>
          </el-tab-pane>
          <el-tab-pane label="💎 充值记录" name="charge">
            <el-table :data="chargeRecords" stripe style="width: 100%" :empty-text="'暂无充值记录'">
              <el-table-column prop="time" label="时间" width="220" />
              <el-table-column prop="amount" label="金额 (元)" width="150">
                <template #default="scope"><span style="color: #1caf9a; font-weight: bold; font-size: 16px;">+ {{ scope.row.amount.toFixed(2) }}</span></template>
              </el-table-column>
              <el-table-column prop="type" label="类型" />
            </el-table>
          </el-tab-pane>
        </el-tabs>
      </div>
    </main>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import axios from 'axios'
import NavBar from '../components/NavBar.vue'

const activeTab = ref('consume')
const consumeRecords = ref([])
const chargeRecords = ref([])
const userId = sessionStorage.getItem('id') || 1

// 获取真实账单记录（自带无敌兜底演示防线）
// 修改后的 fetchHistory：只说真话，不加滤镜
const fetchHistory = async () => {
  try {
    const res = await axios.get(`/api/get/history?userId=${userId}`)

    if (res.data.success && res.data.content) {
      const allRecords = res.data.content
      consumeRecords.value = []
      chargeRecords.value = []

      allRecords.forEach(record => {
        const item = {
          time: record.time ? record.time.replace('T', ' ').substring(0, 19) : '',
          amount: Math.abs(record.amount || 0),
          type: record.description || '消费记录'
        }

        if (record.amount < 0 || record.type === 0) {
          consumeRecords.value.push(item)
        } else {
          chargeRecords.value.push(item)
        }
      })
    }
  } catch (error) {
    console.error('获取账单真实接口报错了:', error)
  }
}

onMounted(() => fetchHistory())
</script>

<style scoped>
.page-container {
  min-height: 100vh;
  background-color: #f5f7fa;
  padding-bottom: 40px;
}

.content-container {
  max-width: 1000px;
  margin: 40px auto;
}

.card {
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
  padding: 30px;
}

.header-title h2 {
  margin-top: 0;
  margin-bottom: 20px;
  color: #333;
  border-left: 5px solid #1caf9a;
  padding-left: 10px;
}

.custom-tabs {
  margin-top: 20px;
}
</style>