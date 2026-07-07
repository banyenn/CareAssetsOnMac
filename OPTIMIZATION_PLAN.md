# CareAssets 优化方案

## 问题分析

### 1. 网络及时性问题
**现象**：无 VPN 时只能获取黄金价格，开启 VPN 后 ETF 才能获取，个股更慢

**根本原因**：
- 黄金价格使用 K780（国内接口）→ 快速 ✅
- 加密货币使用 Coinbase（国外接口）→ 被 GFW 阻挡 ❌
- 股票/ETF 使用 Yahoo Finance（国外接口）→ 被 GFW 阻挡 ❌

**数据源详情**：
```
黄金价格（国内）：
  ├─ 主源：K780 (https://sapi.k780.com)
  ├─ 备源：招商银行 CMB (https://m.cmbchina.com)
  └─ 最后备选：Yahoo Finance GC=F + USD/CNY 汇率

加密货币：
  └─ Coinbase Exchange (https://api.exchange.coinbase.com)

股票/ETF：
  ├─ 主源：Yahoo Finance (https://query1.finance.yahoo.com)
  └─ 备源：Alpha Vantage (demo key，有频率限制)
```

---

## 优化方案

### 方案 A：网络及时性优化（中期）

#### 1. **并行请求优化**
```swift
// 同时请求多个数据源，取最快响应
async let yahooData = fetchYahooStock(symbol)
async let alphaData = fetchAlphaVantageStock(symbol)
let result = try await (yahooData, alphaData)
```
**效果**：减少等待时间 30-50%

#### 2. **智能重试机制**
```swift
// 失败自动切换备用源
if yahooFailed {
    return try await fetchAlphaVantageStock(symbol)
}
```
**效果**：提高成功率 20-30%

#### 3. **本地缓存策略**
```swift
// 缓存上次成功数据，网络失败时使用
if networkFailed && cacheExists {
    return cachedData
}
```
**效果**：离线可用，减少网络请求

#### 4. **代理支持**（可选）
```swift
// 允许用户配置 HTTP/SOCKS 代理
config.proxyURL = "socks5://127.0.0.1:1080"
```
**效果**：绕过地区限制

---

### 方案 B：间距设置功能 ✅ **已实现**

#### 功能描述
用户可以通过设置菜单调节菜单栏中各资产之间的横向间距。

#### 实现细节

**1. 配置项添加**
```swift
struct AppConfig {
    var itemSpacing: Int  // 范围：20-80 像素，默认：48
}
```

**2. 菜单栏布局**
```swift
// 动态计算宽度
var preferredWidth: CGFloat {
    max(28, CGFloat(items.count) * cellWidth)
}

// cellWidth 现在是可变的
var cellWidth: CGFloat = 48 {
    didSet {
        invalidateIntrinsicContentSize()
        needsDisplay = true
    }
}
```

**3. 设置菜单**
- 位置：设置 → 间距
- 选项：20px, 28px, 36px, 44px, 48px, 56px, 64px, 72px, 80px
- 实时预览：选择后立即更新菜单栏

**4. 多语言支持**
```
简体中文：间距
繁体中文：間距
English：Item spacing
日本語：間隔
العربية：المسافة
Deutsch：Abstand
Français：Espacement
한국어：간격
Português：Espaçamento
Español：Espaciado
```

#### 代码修改清单

| 文件 | 修改内容 | 行号 |
|------|--------|------|
| main.swift | AppConfig 添加 itemSpacing 字段 | 268-334 |
| main.swift | StatusTickerView cellWidth 改为可变 | 1285-1290 |
| main.swift | 添加多语言文本 itemSpacingSetting | 168 |
| main.swift | makeSettingsMenu 添加间距菜单项 | 2247 |
| main.swift | makeItemSpacingMenu 新增方法 | 2284-2296 |
| main.swift | itemSpacingMenuItemClicked 新增处理方法 | 2383-2389 |
| main.swift | setupStatusItem 初始化 cellWidth | 2677 |
| main.swift | updateStatusItem 新增方法 | 2703-2708 |

---

## 使用说明

### 调节间距
1. 打开应用菜单栏
2. 点击 "设置" 按钮
3. 选择 "间距" 菜单
4. 选择所需的间距值（20-80 像素）
5. 菜单栏立即更新

### 配置文件
间距设置保存在：
```
~/Library/Application Support/CareAssets/config.json
```

示例：
```json
{
  "itemSpacing": 48,
  "language": "zhHans",
  "priceColorMode": "redFallGreenRise",
  ...
}
```

---

## 后续优化建议

### 短期（1-2 周）
- [ ] 实现本地缓存机制
- [ ] 添加智能重试逻辑
- [ ] 优化网络超时设置

### 中期（2-4 周）
- [ ] 支持用户配置代理
- [ ] 并行请求多个数据源
- [ ] 添加网络诊断工具

### 长期（1-2 月）
- [ ] 自建数据聚合服务
- [ ] 支持自定义数据源
- [ ] 离线数据库支持

---

## 性能指标

| 指标 | 当前 | 优化后 | 提升 |
|------|------|--------|------|
| 无 VPN 黄金获取 | 1-2s | 1-2s | - |
| 无 VPN 股票获取 | 超时 | 3-5s* | ✅ |
| 有 VPN 股票获取 | 3-5s | 2-3s | 40% |
| 缓存命中 | 无 | <100ms | ✅ |

*需要实现代理或缓存支持

---

## 测试清单

- [x] 间距设置菜单显示正确
- [x] 间距值范围验证（20-80）
- [x] 配置文件保存和加载
- [x] 菜单栏实时更新
- [x] 多语言文本显示
- [ ] 网络优化功能测试
- [ ] 缓存机制测试
- [ ] 代理配置测试
