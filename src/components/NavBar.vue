<template>
  <header class="nav-top-container">
    <div class="nav-logo">🎬 NJU-Se电影购票系统</div>
    <ul class="nav-links">
      <li :class="{ active: currentPath.includes('/home') }">
        <router-link to="/home">首页</router-link>
      </li>
      <li :class="{ active: currentPath.includes('/movie') }">
        <router-link to="/movie">电影</router-link>
      </li>
    </ul>
    <div class="user-menu">
      <el-dropdown @command="handleCommand">
        <span class="el-dropdown-link">
          <el-avatar :size="36" src="https://cube.elemecdn.com/3/7c/3ea6beec64369c2642b92c6726f1epng.png" />
          <span class="username">{{ currentUser.username || '用户' }}</span>
        </span>
        <template #dropdown>
          <el-dropdown-menu>
            <el-dropdown-item command="buy">🎫 我的电影票</el-dropdown-item>
            <el-dropdown-item command="member">💳 我的卡包</el-dropdown-item>
            <el-dropdown-item command="cost">💰 充值/消费记录</el-dropdown-item>
            <el-dropdown-item command="info">👤 个人信息</el-dropdown-item>
            <el-dropdown-item divided command="logout" style="color: #ed5565;">🚪 退出登录</el-dropdown-item>
          </el-dropdown-menu>
        </template>
      </el-dropdown>
    </div>
  </header>
</template>

<script setup>
import { ref, computed } from 'vue'
import { useRouter, useRoute } from 'vue-router'
import { ElMessage } from 'element-plus'

const router = useRouter()
const route = useRoute()

// 获取当前路由路径，用来智能判断哪个菜单该亮起
const currentPath = computed(() => route.path)

const currentUser = ref(JSON.parse(localStorage.getItem('user') || '{}'))

// 终极跳转逻辑
const handleCommand =async (command) => {
  if (command === 'logout') {
    try {
      // 🌟 通知后端清理 Session
      await axios.post('/api/logout')
    } catch (e) {
      console.error('后端注销失败，但前端依然会退出')
    }
    localStorage.removeItem('user')
    router.push('/login')
  } else if (command === 'buy') {
    router.push('/userBuy')
  } else if (command === 'member') {
    router.push('/userMember')
  } else if (command === 'cost') {
    router.push('/userCost')
  } else if (command === 'info') {
    router.push('/userInfo')
  } else {
    ElMessage.info(`该页面正在建设中...`)
  }
}
</script>

<style scoped>
/* 这里只放导航栏专属的样式 */
.nav-top-container { height: 60px; background-color: #1d2939; display: flex; align-items: center; padding: 0 40px; color: white; box-shadow: 0 2px 10px rgba(0,0,0,0.1); }
.nav-logo { font-size: 22px; font-weight: bold; margin-right: 50px; color: #1caf9a; }
.nav-links { display: flex; list-style: none; margin: 0; padding: 0; flex: 1; }
.nav-links li a { color: #a0a5ab; text-decoration: none; font-size: 16px; padding: 10px 20px; margin-right: 10px; border-radius: 4px; transition: all 0.3s; }
.nav-links li.active a, .nav-links li a:hover { background-color: #1caf9a; color: white; }
.user-menu { cursor: pointer; display: flex; align-items: center; }
.el-dropdown-link { display: flex; align-items: center; color: white; outline: none; }
.username { margin: 0 10px; font-size: 15px; }
</style>