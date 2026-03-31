package com.example.cinema.blImpl.promotion;

import com.example.cinema.bl.promotion.VIPService;
import com.example.cinema.data.promotion.VIPCardMapper;
import com.example.cinema.data.user.AccountMapper;
import com.example.cinema.data.user.HistoryMapper;
import com.example.cinema.po.VIP_Strategy;
import com.example.cinema.po.historyItem;
import com.example.cinema.vo.VIPCardForm;
import com.example.cinema.po.User;
import com.example.cinema.po.VIPCard;
import com.example.cinema.vo.ResponseVO;
import com.example.cinema.vo.VIPInfoVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import java.util.*;

@Service
public class VIPServiceImpl implements VIPService {
    @Autowired
    VIPCardMapper vipCardMapper;
    @Autowired
    AccountMapper accountMapper;
    @Autowired
    HistoryMapper historyMapper; // 🚀 引入账单流水服务

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ResponseVO addVIPCard(int userId) {
        User user = accountMapper.getAccountById(userId);
        VIPCard vipCard = new VIPCard();
        vipCard.setUserId(userId);
        vipCard.setBalance(0);
        vipCard.setTotal(25); // 初始开卡金额
        vipCard.setName(user != null ? user.getUsername() : "VIP用户");

        try {
            // 🚀 核心修复：执行插入后，MyBatis 会把真实的生成 ID 塞回 vipCard 对象里
            vipCardMapper.insertOneCard(vipCard);
            int realNewCardId = vipCard.getId();

            // 📝 记账：开通会员卡扣费
            try {
                historyItem history = new historyItem();
                history.setUserId(userId);
                history.setKind(0); // 0代表购买会员卡
                history.setMoney(-25.0);
                history.setDescription("购买会员卡");
                historyMapper.insertHistory(history);
            } catch (Exception e) { System.out.println("开卡流水插入失败: " + e.getMessage()); }

            return ResponseVO.buildSuccess(vipCardMapper.selectCardById(realNewCardId));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseVO.buildFailure("开卡失败");
        }
    }

    @Override
    public ResponseVO getCardById(int id) {
        try {
            return ResponseVO.buildSuccess(vipCardMapper.selectCardById(id));
        } catch (Exception e) {
            return ResponseVO.buildFailure("失败");
        }
    }

    @Override
    public ResponseVO getVIPInfo() {
        VIPInfoVO vipInfoVO = new VIPInfoVO();
        try {
            List<VIP_Strategy> strategies = vipCardMapper.getVIP_Strategy();
            List<String> description = new ArrayList<>();
            if (strategies != null) {
                for (int i = 0; i < strategies.size(); i++) {
                    description.add(strategies.get(i).getDescription());
                }
            }
            vipInfoVO.setDescription(description);
            vipInfoVO.setPrice(25.0);
            return ResponseVO.buildSuccess(vipInfoVO);
        } catch (Exception e) {
            vipInfoVO.setPrice(25.0);
            return ResponseVO.buildSuccess(vipInfoVO);
        }
    }

    @Override
    @Transactional(rollbackFor = Exception.class)
    public ResponseVO charge(VIPCardForm vipCardForm) {
        VIPCard vipCard = vipCardMapper.selectCardById(vipCardForm.getVipId());
        if (vipCard == null) {
            return ResponseVO.buildFailure("会员卡不存在");
        }

        double addedBalance = 0;
        try {
            // 🚀 核心修复：真正应用“满 X 送 Y”的算术逻辑
            VIP_Strategy vip_strategy = vipCardMapper.selectVIP_StrategyById(vipCardForm.getVipStrategyID());
            if (vip_strategy != null && vip_strategy.getChargeLimit() > 0) {
                // 计算赠送的倍数，比如充 250，满 100 送 20，那就是送 20 * 2 = 40，总计 290
                int times = (int) (vipCardForm.getAmount() / vip_strategy.getChargeLimit());
                addedBalance = vipCardForm.getAmount() + (times * vip_strategy.getGiftAmount());
            } else {
                addedBalance = vipCardForm.getAmount();
            }
        } catch (Exception e) {
            addedBalance = vipCardForm.getAmount();
        }

        vipCard.setBalance(vipCard.getBalance() + addedBalance);
        vipCard.setTotal(vipCard.getTotal() + vipCardForm.getAmount());

        try {
            vipCardMapper.updateCardBalance(vipCardForm.getVipId(), vipCard.getBalance());
            vipCardMapper.updateCardTotal(vipCardForm.getVipId(), vipCard.getTotal());

            // 📝 记账：充值流水
            try {
                historyItem history = new historyItem();
                history.setUserId(vipCard.getUserId());
                history.setKind(1); // 1代表充值
                history.setMoney(vipCardForm.getAmount());
                history.setDescription("会员卡充值 (实际到账 ￥" + addedBalance + ")");
                historyMapper.insertHistory(history);
            } catch (Exception e) { System.out.println("充值流水插入失败: " + e.getMessage()); }

            return ResponseVO.buildSuccess(vipCardMapper.selectCardById(vipCardForm.getVipId()));
        } catch (Exception e) {
            e.printStackTrace();
            return ResponseVO.buildFailure("充值失败");
        }
    }

    @Override
    public ResponseVO getCardByUserId(int userId) {
        try {
            VIPCard vipCard = vipCardMapper.selectCardByUserId(userId);
            if (vipCard == null) {
                return ResponseVO.buildFailure("用户卡不存在");
            }
            return ResponseVO.buildSuccess(vipCard);
        } catch (Exception e) {
            return ResponseVO.buildFailure("失败");
        }
    }

    // ... 下方原样保留的策略管理代码 ...
    @Override
    public ResponseVO issueVIP_Strategy(int chargeLimit, int giftAmount) {
        try {
            VIP_Strategy vip_strategy = new VIP_Strategy();
            vip_strategy.setGiftAmount(giftAmount);
            vip_strategy.setChargeLimit(chargeLimit);
            int VIP_Strategy_ID = vipCardMapper.addVIP_Strategy(vip_strategy);
            return ResponseVO.buildSuccess(vipCardMapper.selectVIP_StrategyById(VIP_Strategy_ID));
        } catch (Exception e) { return ResponseVO.buildFailure("失败"); }
    }

    @Override
    public ResponseVO changeVIP_Strategy(int VIP_Strategy_ID, int chargeLimit, int giftAmount) {
        try {
            vipCardMapper.changeVIP_Strategy(VIP_Strategy_ID, chargeLimit, giftAmount);
            return ResponseVO.buildSuccess(vipCardMapper.selectVIP_StrategyById(VIP_Strategy_ID));
        } catch (Exception e) { return ResponseVO.buildFailure("失败"); }
    }

    @Override
    public ResponseVO getAllVip_Strategy() {
        try {
            List<VIP_Strategy> list = vipCardMapper.getVIP_Strategy();
            return (ResponseVO.buildSuccess(list));
        } catch (Exception e) { return ResponseVO.buildFailure("失败"); }
    }

    @Override
    public ResponseVO deleteVIP_Strategy(int VIP_Strategy_ID) {
        try {
            vipCardMapper.deleteVIP_Strategy(VIP_Strategy_ID);
            return ResponseVO.buildSuccess();
        } catch (Exception e) { return ResponseVO.buildFailure("失败"); }
    }

    @Override
    public ResponseVO getVipByMoney(int money) {
        try {
            List<VIPCard> list1 = vipCardMapper.selectAllVip();
            List<VIPCard> list2 = new ArrayList<>();
            for (VIPCard it : list1) {
                if (it.getTotal() >= money) list2.add(it);
            }
            return ResponseVO.buildSuccess(list2);
        } catch (Exception e) { return ResponseVO.buildFailure("失败"); }
    }
}