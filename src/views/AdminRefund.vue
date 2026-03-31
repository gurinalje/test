<template>
  <div class="card">
    <el-alert
        title="退票须知：全局控制前台退票按钮，距离开场时间小于此时限将不可退票"
        type="info"
        show-icon
        :closable="false"
        style="margin-bottom: 20px;"
    />
    <el-form label-width="150px">
      <el-form-item label="允许退票时限 (小时)">
        <el-input-number v-model="refundLimit" :min="0" :step="1" />
      </el-form-item>

      <el-form-item>
        <el-button type="primary" @click="saveRefundStrategy" :loading="loading">
          💾 保存全局设置
        </el-button>
      </el-form-item>
    </el-form>
  </div>
</template>

<script setup>
import {ref, onMounted} from 'vue'
import {ElMessage} from 'element-plus'
import axios from 'axios'

// 绑定的变量，默认为2小时
const refundLimit = ref(2)
const loading = ref(false)

// 🌟 核心：页面加载时，去后端查询当前的全局退票时间
const fetchRefundStrategy = async () => {
  try {
    // 🔍 注意：这里我盲猜你后端的查询接口是 /api/ticket/get/refundInfo，如果不对请修改
    const res = await axios.get('/api/ticket/get/refundInfo')
    if (res.data.success && res.data.content != null) {
      // 假设后端返回的对象里有个字段叫 limitTime 或者 hours 等，这里先用 limitTime 举例
      // 如果后端直接返回了一个数字，就写 refundLimit.value = res.data.content
      refundLimit.value = res.data.content.limitTime || res.data.content
    }
  } catch (error) {
    console.error('获取退票策略失败，使用默认值 2:', error)
  }
}

onMounted(() => {
  fetchRefundStrategy()
})

// 🌟 核心：点击保存按钮，提交到后端数据库
const saveRefundStrategy = async () => {
  loading.value = true
  try {
    // 🔍 注意：这里我盲猜你后端的修改接口是 /api/ticket/update/refundInfo
    // 这里也是通过 params 传参，适配后端最常见的 @RequestParam 接收方式
    const res = await axios.post('/api/ticket/update/refundInfo', null, {
      params: {
        limitTime: refundLimit.value
      }
    })

    if (res.data.success) {
      ElMessage.success('全局退票设置保存成功！')
    } else {
      ElMessage.error(res.data.message || '保存失败')
    }
  } catch (error) {
    console.error(error)
    ElMessage.error('网络请求失败，请检查后端接口路径！')
  } finally {
    loading.value = false
  }
}
</script>

<style scoped>
.card {
  background: white;
  border-radius: 8px;
  padding: 40px;
  box-shadow: 0 4px 12px rgba(0, 0, 0, 0.05);
}
</style>