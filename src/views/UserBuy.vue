<template>
  <div class="page-container">
    <NavBar />
    <main class="content-container card">
      <h2 style="margin-bottom: 20px; color: #333;">🎟️ 我的电影票</h2>

      <el-table :data="ticketList" stripe style="width: 100%" empty-text="您还没有买过电影票哦">
        <el-table-column prop="movieName" label="电影名称" min-width="180">
          <template #default="scope">
            <strong>{{ scope.row.movieName }}</strong>
          </template>
        </el-table-column>
        <el-table-column prop="hallName" label="影厅" width="150" />
        <el-table-column label="座位" width="120">
          <template #default="scope">
            <el-tag effect="plain">{{ scope.row.row + 1 }}排{{ scope.row.column + 1 }}座</el-tag>
          </template>
        </el-table-column>
        <el-table-column label="放映时间" width="200">
          <template #default="scope">
            <span style="color: #666;">{{ scope.row.startTime }}</span>
          </template>
        </el-table-column>
        <el-table-column label="订单状态" width="120" align="center">
          <template #default="scope">
            <el-tag :type="scope.row.state === '已完成' ? 'success' : (scope.row.state === '已失效' ? 'info' : 'warning')">
              {{ scope.row.state }}
            </el-tag>
          </template>
        </el-table-column>
      </el-table>
    </main>
  </div>
</template>

<script setup>
import {ref, onMounted} from 'vue'
import axios from 'axios'
import {ElMessage} from 'element-plus'
import NavBar from '../components/NavBar.vue'

const ticketList = ref([])
const currentUser = JSON.parse(localStorage.getItem('user') || '{}')

const fetchTickets = async () => {
  if (!currentUser.id) {
    return ElMessage.warning('请先登录查看电影票')
  }

  try {
    const res = await axios.get(`/api/ticket/get/${currentUser.id}`)
    if (res.data.success) {
      // 后端的 ShowTicketVO 已经帮我们把名字和时间整理得非常漂亮了，直接用！
      ticketList.value = res.data.content || []
    }
  } catch (e) {
    console.error(e)
    ElMessage.error('获取购票记录失败')
  }
}

onMounted(() => {
  fetchTickets()
})
</script>

<style scoped>
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
</style>