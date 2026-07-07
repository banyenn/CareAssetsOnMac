import AppKit
import CoreText
import Foundation

enum AssetType: String, Codable, Sendable {
    case gold
    case crypto
    case stock
}

enum PriceDisplayMode: String, Codable, Sendable, CaseIterable {
    case compact = "compact"
    case standard = "standard"
    case detailed = "detailed"

    var title: String {
        switch self {
        case .compact:
            return L10n.text("紧凑", "Compact", zhHant: "緊湊", ja: "コンパクト", ar: "مضغوط", de: "Kompakt", fr: "Compact", ko: "컴팩트", ptPT: "Compacto", es: "Compacto")
        case .standard:
            return L10n.text("标准", "Standard", zhHant: "標準", ja: "標準", ar: "معياري", de: "Standard", fr: "Standard", ko: "표준", ptPT: "Padrão", es: "Estándar")
        case .detailed:
            return L10n.text("详细", "Detailed", zhHant: "詳細", ja: "詳細", ar: "مفصل", de: "Detailliert", fr: "Détaillé", ko: "상세", ptPT: "Detalhado", es: "Detallado")
        }
    }
}

enum TimeSeriesDisplayMode: String, Codable, Sendable, CaseIterable {
    case hidden = "hidden"
    case schemeA = "schemeA"
    case schemeB = "schemeB"

    var title: String {
        switch self {
        case .hidden:
            return L10n.text("隐藏", "Hidden", zhHant: "隱藏", ja: "非表示", ar: "مخفي", de: "Verborgen", fr: "Masqué", ko: "숨김", ptPT: "Oculto", es: "Oculto")
        case .schemeA:
            return L10n.text("方案A", "Scheme A", zhHant: "方案A", ja: "スキームA", ar: "المخطط أ", de: "Schema A", fr: "Schéma A", ko: "스키마 A", ptPT: "Esquema A", es: "Esquema A")
        case .schemeB:
            return L10n.text("方案B", "Scheme B", zhHant: "方案B", ja: "スキームB", ar: "المخطط ب", de: "Schema B", fr: "Schéma B", ko: "스키마 B", ptPT: "Esquema B", es: "Esquema B")
        }
    }
}

enum AppLanguage: String, Codable, Sendable, CaseIterable {
    case system
    case zhHans
    case en
    case zhHant
    case ja
    case ar
    case de
    case fr
    case ko
    case ptPT
    case es

    var title: String {
        switch self {
        case .system:
            return L10n.text(
                "系统",
                "System",
                zhHant: "系統",
                ja: "システム",
                ar: "النظام",
                de: "System",
                fr: "Système",
                ko: "시스템",
                ptPT: "Sistema",
                es: "Sistema"
            )
        case .zhHans:
            return "简体中文"
        case .en:
            return "English"
        case .zhHant:
            return "繁體中文"
        case .ja:
            return "日本語"
        case .ar:
            return "العربية"
        case .de:
            return "Deutsch"
        case .fr:
            return "Français"
        case .ko:
            return "한국어"
        case .ptPT:
            return "Português"
        case .es:
            return "Español"
        }
    }
}

enum L10n {
    static var appLanguage: AppLanguage = .system

    private static var resolvedLanguage: AppLanguage {
        switch appLanguage {
        case .system:
            let preferred = Locale.preferredLanguages.first?.lowercased() ?? ""
            if preferred.hasPrefix("zh-hant") || preferred.contains("hant") || preferred.hasPrefix("zh-tw") || preferred.hasPrefix("zh-hk") {
                return .zhHant
            }
            if preferred.hasPrefix("zh") { return .zhHans }
            if preferred.hasPrefix("ja") { return .ja }
            if preferred.hasPrefix("ar") { return .ar }
            if preferred.hasPrefix("de") { return .de }
            if preferred.hasPrefix("fr") { return .fr }
            if preferred.hasPrefix("ko") { return .ko }
            if preferred.hasPrefix("pt") { return .ptPT }
            if preferred.hasPrefix("es") { return .es }
            return .en
        default:
            return appLanguage
        }
    }

    static var usesChineseMarketUnits: Bool {
        switch appLanguage {
        case .system:
            return Locale.autoupdatingCurrent.regionCode?.uppercased() == "CN"
        case .zhHans:
            return true
        default:
            return false
        }
    }

    static var isRightToLeft: Bool {
        resolvedLanguage == .ar
    }

    static func text(
        _ zh: String,
        _ en: String,
        zhHant: String? = nil,
        ja: String? = nil,
        ar: String? = nil,
        de: String? = nil,
        fr: String? = nil,
        ko: String? = nil,
        ptPT: String? = nil,
        es: String? = nil
    ) -> String {
        switch resolvedLanguage {
        case .system:
            return en
        case .zhHans:
            return zh
        case .en:
            return en
        case .zhHant:
            return zhHant ?? zh
        case .ja:
            return ja ?? en
        case .ar:
            return ar ?? en
        case .de:
            return de ?? en
        case .fr:
            return fr ?? en
        case .ko:
            return ko ?? en
        case .ptPT:
            return ptPT ?? en
        case .es:
            return es ?? en
        }
    }

    static var white: String { text("白", "White", zhHant: "白", ja: "白", ar: "أبيض", de: "Weiß", fr: "Blanc", ko: "흰색", ptPT: "Branco", es: "Blanco") }
    static var redRiseGreenFall: String { text("红升绿降", "Red up, green down", zhHant: "紅升綠降", ja: "赤上げ緑下げ", ar: "الأحمر صعود، الأخضر هبوط", de: "Rot steigt, Grün fällt", fr: "Rouge hausse, vert baisse", ko: "빨강 상승, 초록 하락", ptPT: "Vermelho sobe, verde desce", es: "Rojo sube, verde baja") }
    static var redFallGreenRise: String { text("红降绿升", "Red down, green up", zhHant: "紅降綠升", ja: "赤下げ緑上げ", ar: "الأحمر هبوط، الأخضر صعود", de: "Rot fällt, Grün steigt", fr: "Rouge baisse, vert hausse", ko: "빨강 하락, 초록 상승", ptPT: "Vermelho desce, verde sobe", es: "Rojo baja, verde sube") }
    static var gold: String { text("黄金", "Gold", zhHant: "黃金", ja: "金", ar: "الذهب", de: "Gold", fr: "Or", ko: "금", ptPT: "Ouro", es: "Oro") }
    static var goldShort: String { text("金", "Gold", zhHant: "金", ja: "金", ar: "ذهب", de: "Gold", fr: "Or", ko: "금", ptPT: "Ouro", es: "Oro") }
    static var loading: String { text("正在刷新", "Refreshing", zhHant: "正在重新整理", ja: "更新中", ar: "جارٍ التحديث", de: "Aktualisiert", fr: "Actualisation", ko: "새로고침 중", ptPT: "A atualizar", es: "Actualizando") }
    static var loadingAssets: String { text("正在加载资产价格", "Loading asset prices", zhHant: "正在載入資產價格", ja: "資産価格を読み込み中", ar: "جارٍ تحميل أسعار الأصول", de: "Preise werden geladen", fr: "Chargement des prix", ko: "자산 가격 로드 중", ptPT: "A carregar preços", es: "Cargando precios") }
    static var close: String { text("收盘", "Close", zhHant: "收盤", ja: "終値", ar: "إغلاق", de: "Schluss", fr: "Clôture", ko: "종가", ptPT: "Fecho", es: "Cierre") }
    static var cnyPerGram: String { text("人民币/克", "CNY/g", zhHant: "人民幣/克", ja: "人民元/g", ar: "يوان/غ", de: "CNY/g", fr: "CNY/g", ko: "CNY/g", ptPT: "CNY/g", es: "CNY/g") }
    static var gramSuffix: String { text("/克", "/g", zhHant: "/克", ja: "/g", ar: "/غ", de: "/g", fr: "/g", ko: "/g", ptPT: "/g", es: "/g") }
    static var usdPerOunce: String { text("美元/盎司", "USD/oz", zhHant: "美元/盎司", ja: "USD/oz", ar: "دولار/أونصة", de: "USD/oz", fr: "USD/oz", ko: "USD/oz", ptPT: "USD/oz", es: "USD/oz") }
    static var ounceSuffix: String { text("/盎司", "/oz", zhHant: "/盎司", ja: "/oz", ar: "/أونصة", de: "/oz", fr: "/oz", ko: "/oz", ptPT: "/oz", es: "/oz") }
    static var add: String { text("添加", "Add", zhHant: "新增", ja: "追加", ar: "إضافة", de: "Hinzufügen", fr: "Ajouter", ko: "추가", ptPT: "Adicionar", es: "Añadir") }
    static var search: String { text("搜索", "Search", zhHant: "搜尋", ja: "検索", ar: "بحث", de: "Suchen", fr: "Rechercher", ko: "검색", ptPT: "Pesquisar", es: "Buscar") }
    static var searching: String { text("搜索中", "Searching", zhHant: "搜尋中", ja: "検索中", ar: "جارٍ البحث", de: "Sucht", fr: "Recherche", ko: "검색 중", ptPT: "A pesquisar", es: "Buscando") }
    static var cancel: String { text("取消", "Cancel", zhHant: "取消", ja: "取消", ar: "إلغاء", de: "Abbrechen", fr: "Annuler", ko: "취소", ptPT: "Cancelar", es: "Cancelar") }
    static var quit: String { text("退出", "Quit", zhHant: "結束", ja: "終了", ar: "إنهاء", de: "Beenden", fr: "Quitter", ko: "종료", ptPT: "Sair", es: "Salir") }
    static var searchPlaceholder: String { text("搜索股票代码或者币的名称", "Search stock code or coin name", zhHant: "搜尋股票代碼或幣種名稱", ja: "株式コードまたはコイン名を検索", ar: "ابحث عن رمز سهم أو اسم عملة", de: "Aktiencode oder Coin suchen", fr: "Code action ou crypto", ko: "주식 코드 또는 코인명 검색", ptPT: "Código de ação ou moeda", es: "Código de acción o moneda") }
    static var emptySearchPrompt: String { text("请点击上方搜索框输入", "Click the search field above", zhHant: "請點擊上方搜尋框輸入", ja: "上の検索欄に入力してください", ar: "انقر حقل البحث أعلاه", de: "Oben ins Suchfeld klicken", fr: "Cliquez le champ ci-dessus", ko: "위 검색창을 클릭하세요", ptPT: "Clique no campo acima", es: "Haz clic en el campo superior") }
    static var noSearchResults: String { text("暂无结果，请换个关键词试试", "No results. Try another keyword.", zhHant: "暫無結果，請換個關鍵字試試", ja: "結果なし。別のキーワードを試してください", ar: "لا نتائج. جرّب كلمة أخرى.", de: "Keine Ergebnisse. Anderes Stichwort.", fr: "Aucun résultat. Essayez un autre mot.", ko: "결과 없음. 다른 키워드를 시도하세요.", ptPT: "Sem resultados. Tente outra palavra.", es: "Sin resultados. Prueba otra palabra.") }
    static var searchInProgress: String { text("搜索中...", "Searching...", zhHant: "搜尋中...", ja: "検索中...", ar: "جارٍ البحث...", de: "Suche...", fr: "Recherche...", ko: "검색 중...", ptPT: "A pesquisar...", es: "Buscando...") }
    static var visibleInMenuBar: String { text("显示在顶部", "Show in menu bar", zhHant: "顯示在頂部", ja: "メニューバーに表示", ar: "إظهار في شريط القائمة", de: "In Menüleiste anzeigen", fr: "Afficher dans la barre", ko: "메뉴 막대에 표시", ptPT: "Mostrar na barra", es: "Mostrar en la barra") }
    static var remove: String { text("移出", "Remove", zhHant: "移除", ja: "削除", ar: "إزالة", de: "Entfernen", fr: "Retirer", ko: "제거", ptPT: "Remover", es: "Quitar") }
    static var added: String { text("已添加", "Added", zhHant: "已新增", ja: "追加済み", ar: "مُضاف", de: "Hinzugefügt", fr: "Ajouté", ko: "추가됨", ptPT: "Adicionado", es: "Añadido") }
    static var settings: String { text("设置", "Settings", zhHant: "設定", ja: "設定", ar: "الإعدادات", de: "Einstellungen", fr: "Réglages", ko: "설정", ptPT: "Definições", es: "Ajustes") }
    static var colorSetting: String { text("价格颜色", "Price color", zhHant: "價格顏色", ja: "価格色", ar: "لون السعر", de: "Preisfarbe", fr: "Couleur prix", ko: "가격 색상", ptPT: "Cor preço", es: "Color precio") }
    static var languageSetting: String { text("语言", "Language", zhHant: "語言", ja: "言語", ar: "اللغة", de: "Sprache", fr: "Langue", ko: "언어", ptPT: "Idioma", es: "Idioma") }
    static var statusBarBackgroundSetting: String { text("标题颜色", "Title color", zhHant: "標題顏色", ja: "タイトル色", ar: "لون العنوان", de: "Titelfarbe", fr: "Couleur titre", ko: "제목 색상", ptPT: "Cor título", es: "Color título") }
    static var itemSpacingSetting: String { text("间距", "Item spacing", zhHant: "間距", ja: "間隔", ar: "المسافة", de: "Abstand", fr: "Espacement", ko: "간격", ptPT: "Espaçamento", es: "Espaciado") }
    static var priceDisplayModeSetting: String { text("价格显示", "Price display", zhHant: "價格顯示", ja: "価格表示", ar: "عرض السعر", de: "Preisanzeige", fr: "Affichage prix", ko: "가격 표시", ptPT: "Exibição preço", es: "Mostrar precio") }
    static var darkStatusBarBackground: String { text("资产标题-白", "Asset title - white", zhHant: "資產標題-白", ja: "資産名 - 白", ar: "عنوان الأصل - أبيض", de: "Titel - Weiß", fr: "Titre - blanc", ko: "자산 제목 - 흰색", ptPT: "Título - branco", es: "Título - blanco") }
    static var lightStatusBarBackground: String { text("资产标题-黑", "Asset title - black", zhHant: "資產標題-黑", ja: "資産名 - 黒", ar: "عنوان الأصل - أسود", de: "Titel - Schwarz", fr: "Titre - noir", ko: "자산 제목 - 검정", ptPT: "Título - preto", es: "Título - negro") }
    static var titleBlue: String { text("资产标题-蓝", "Asset title - blue", zhHant: "資產標題-藍", ja: "資産名 - 青", ar: "عنوان الأصل - أزرق", de: "Titel - Blau", fr: "Titre - bleu", ko: "자산 제목 - 파랑", ptPT: "Título - azul", es: "Título - azul") }
    static var titleYellow: String { text("资产标题-黄", "Asset title - yellow", zhHant: "資產標題-黃", ja: "資産名 - 黄", ar: "عنوان الأصل - أصفر", de: "Titel - Gelb", fr: "Titre - jaune", ko: "자산 제목 - 노랑", ptPT: "Título - amarelo", es: "Título - amarillo") }
    static var titlePurple: String { text("资产标题-紫", "Asset title - purple", zhHant: "資產標題-紫", ja: "資産名 - 紫", ar: "عنوان الأصل - أرجواني", de: "Titel - Lila", fr: "Titre - violet", ko: "자산 제목 - 보라", ptPT: "Título - roxo", es: "Título - morado") }
    static var appTooltip: String { "CareAssets" }

    static func assetAddedToast(_ name: String) -> String {
        text("已添加 \(name)", "Added \(name)", zhHant: "已新增 \(name)", ja: "\(name) を追加しました", ar: "تمت إضافة \(name)", de: "\(name) hinzugefügt", fr: "\(name) ajouté", ko: "\(name) 추가됨", ptPT: "\(name) adicionado", es: "\(name) añadido")
    }

    static func assetRemovedToast(_ name: String) -> String {
        text("已移除 \(name)", "Removed \(name)", zhHant: "已移除 \(name)", ja: "\(name) を削除しました", ar: "تمت إزالة \(name)", de: "\(name) entfernt", fr: "\(name) retiré", ko: "\(name) 제거됨", ptPT: "\(name) removido", es: "\(name) eliminado")
    }

    static func refreshState(isRefreshing: Bool, countdown: Int) -> String {
        if isRefreshing {
            return text("刷新中", "Refreshing", zhHant: "重新整理中", ja: "更新中", ar: "جارٍ التحديث", de: "Aktualisiert", fr: "Actualisation", ko: "새로고침 중", ptPT: "A atualizar", es: "Actualizando")
        }
        return text("刷新：\(countdown)s", "Refresh: \(countdown)s", zhHant: "重新整理：\(countdown)s", ja: "更新：\(countdown)s", ar: "تحديث: \(countdown)s", de: "Aktual.: \(countdown)s", fr: "Actu. : \(countdown)s", ko: "새로고침: \(countdown)s", ptPT: "Atual.: \(countdown)s", es: "Act.: \(countdown)s")
    }

    static func searchFailed(_ message: String) -> String {
        text("搜索失败：\(message)", "Search failed: \(message)", zhHant: "搜尋失敗：\(message)", ja: "検索失敗：\(message)", ar: "فشل البحث: \(message)", de: "Suche fehlgeschlagen: \(message)", fr: "Recherche échouée : \(message)", ko: "검색 실패: \(message)", ptPT: "Pesquisa falhou: \(message)", es: "Error de búsqueda: \(message)")
    }
}

enum PriceColorMode: String, Codable, Sendable, CaseIterable {
    case white
    case redRiseGreenFall
    case redFallGreenRise

    var title: String {
        switch self {
        case .white:
            return "⚪"
        case .redRiseGreenFall:
            return "🔴↑ 🟢↓"
        case .redFallGreenRise:
            return "🔴↓ 🟢↑"
        }
    }
}

enum StatusBarBackgroundMode: String, Codable, Sendable, CaseIterable {
    case dark
    case light
    case blue
    case yellow
    case purple

    var title: String {
        switch self {
        case .dark:
            return L10n.darkStatusBarBackground
        case .light:
            return L10n.lightStatusBarBackground
        case .blue:
            return L10n.titleBlue
        case .yellow:
            return L10n.titleYellow
        case .purple:
            return L10n.titlePurple
        }
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = (try? container.decode(String.self)) ?? Self.dark.rawValue
        switch rawValue {
        case Self.dark.rawValue:
            self = .dark
        case Self.light.rawValue:
            self = .light
        case Self.blue.rawValue:
            self = .blue
        case Self.yellow.rawValue:
            self = .yellow
        case Self.purple.rawValue, "red":
            self = .purple
        case "green":
            self = .yellow
        default:
            self = .dark
        }
    }

    func encode(to encoder: Encoder) throws {
        var container = encoder.singleValueContainer()
        try container.encode(rawValue)
    }
}

struct TrackedAsset: Codable, Sendable {
    var type: AssetType
    var name: String
    var symbol: String
    var visibleInMenuBar: Bool
}

struct AppConfig: Codable, Sendable {
    var refreshIntervalSeconds: Int
    var menuBarMaxItems: Int
    var stockDisplayCurrency: String
    var priceColorMode: PriceColorMode
    var statusBarBackgroundMode: StatusBarBackgroundMode
    var language: AppLanguage
    var itemSpacing: Int
    var priceDisplayMode: PriceDisplayMode
    var timeSeriesDisplayMode: TimeSeriesDisplayMode
    var assets: [TrackedAsset]

    static let defaultConfig = AppConfig(
        refreshIntervalSeconds: 60,
        menuBarMaxItems: 3,
        stockDisplayCurrency: "CNY",
        priceColorMode: .redFallGreenRise,
        statusBarBackgroundMode: .dark,
        language: .system,
        itemSpacing: 48,
        priceDisplayMode: .standard,
        timeSeriesDisplayMode: .hidden,
        assets: [
            TrackedAsset(type: .gold, name: L10n.gold, symbol: "JD_GOLD", visibleInMenuBar: true),
            TrackedAsset(type: .crypto, name: "BTC", symbol: "BTCUSDT", visibleInMenuBar: true),
            TrackedAsset(type: .crypto, name: "ETH", symbol: "ETHUSDT", visibleInMenuBar: true),
        ]
    )

    init(
        refreshIntervalSeconds: Int,
        menuBarMaxItems: Int,
        stockDisplayCurrency: String,
        priceColorMode: PriceColorMode = .redFallGreenRise,
        statusBarBackgroundMode: StatusBarBackgroundMode = .dark,
        language: AppLanguage = .system,
        itemSpacing: Int = 48,
        priceDisplayMode: PriceDisplayMode = .standard,
        timeSeriesDisplayMode: TimeSeriesDisplayMode = .hidden,
        assets: [TrackedAsset]
    ) {
        self.refreshIntervalSeconds = refreshIntervalSeconds
        self.menuBarMaxItems = menuBarMaxItems
        self.stockDisplayCurrency = stockDisplayCurrency
        self.priceColorMode = priceColorMode
        self.statusBarBackgroundMode = statusBarBackgroundMode
        self.language = language
        self.itemSpacing = max(36, min(96, itemSpacing))
        self.priceDisplayMode = priceDisplayMode
        self.timeSeriesDisplayMode = timeSeriesDisplayMode
        self.assets = assets
    }

    private enum CodingKeys: String, CodingKey {
        case refreshIntervalSeconds
        case menuBarMaxItems
        case stockDisplayCurrency
        case priceColorMode
        case statusBarBackgroundMode
        case language
        case itemSpacing
        case priceDisplayMode
        case timeSeriesDisplayMode
        case assets
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        refreshIntervalSeconds = try container.decode(Int.self, forKey: .refreshIntervalSeconds)
        menuBarMaxItems = try container.decode(Int.self, forKey: .menuBarMaxItems)
        stockDisplayCurrency = try container.decode(String.self, forKey: .stockDisplayCurrency)
        priceColorMode = try container.decodeIfPresent(PriceColorMode.self, forKey: .priceColorMode) ?? .redFallGreenRise
        statusBarBackgroundMode = try container.decodeIfPresent(StatusBarBackgroundMode.self, forKey: .statusBarBackgroundMode) ?? .dark
        language = try container.decodeIfPresent(AppLanguage.self, forKey: .language) ?? .system
        itemSpacing = max(36, min(96, try container.decodeIfPresent(Int.self, forKey: .itemSpacing) ?? 48))
        priceDisplayMode = try container.decodeIfPresent(PriceDisplayMode.self, forKey: .priceDisplayMode) ?? .standard
        timeSeriesDisplayMode = try container.decodeIfPresent(TimeSeriesDisplayMode.self, forKey: .timeSeriesDisplayMode) ?? .hidden
        assets = try container.decode([TrackedAsset].self, forKey: .assets)
    }
}

struct TimeSeriesData: Sendable {
    var timestamp: Date
    var price: Double
    var volume: Int?
}

struct DisplayAsset: Sendable {
    var id: String
    var type: AssetType
    var name: String
    var symbol: String
    var source: String
    var menuPriceText: String
    var priceText: String
    var detailText: String
    var changeText: String
    var changePercent: Double?
    var updatedAt: Date?
    var visibleInMenuBar: Bool
    var errorMessage: String?
    var timeSeries: [TimeSeriesData]?
    var timeSeriesChange: Double?
    var timeSeriesHigh: Double?
    var timeSeriesLow: Double?

    static func loading(from asset: TrackedAsset) -> DisplayAsset {
        DisplayAsset(
            id: "\(asset.type.rawValue)-\(asset.symbol)",
            type: asset.type,
            name: asset.name,
            symbol: asset.symbol,
            source: "Loading",
            menuPriceText: "--",
            priceText: "--",
            detailText: L10n.loading,
            changeText: "--",
            changePercent: nil,
            updatedAt: nil,
            visibleInMenuBar: asset.visibleInMenuBar,
            errorMessage: nil,
            timeSeries: nil,
            timeSeriesChange: nil,
            timeSeriesHigh: nil,
            timeSeriesLow: nil
        )
    }
}

struct AssetSearchResult: Sendable, Equatable {
    var type: AssetType
    var name: String
    var symbol: String
    var source: String

    var id: String {
        "\(type.rawValue)-\(symbol.uppercased())"
    }

    var trackedAsset: TrackedAsset {
        TrackedAsset(type: type, name: name, symbol: symbol.uppercased(), visibleInMenuBar: false)
    }
}

final class ConfigStore {
    static let appSupportURL: URL = {
        let base = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask)[0]
        return base.appendingPathComponent("CareAssets", isDirectory: true)
    }()

    static let configURL = appSupportURL.appendingPathComponent("config.json")

    static func loadOrCreate() -> AppConfig {
        let fileManager = FileManager.default
        try? fileManager.createDirectory(at: appSupportURL, withIntermediateDirectories: true)

        guard fileManager.fileExists(atPath: configURL.path) else {
            write(AppConfig.defaultConfig)
            return AppConfig.defaultConfig
        }

        do {
            let data = try Data(contentsOf: configURL)
            var config = try JSONDecoder().decode(AppConfig.self, from: data)
            if migrate(&config) {
                write(config)
            }
            return config
        } catch {
            return AppConfig.defaultConfig
        }
    }

    private static func migrate(_ config: inout AppConfig) -> Bool {
        var changed = false
        for index in config.assets.indices {
            if config.assets[index].symbol == "2015.HK", config.assets[index].name == "理想" {
                config.assets[index].name = "理想汽车"
                changed = true
            }
        }
        let legacyDefaultSymbols = ["JD_GOLD", "BTCUSDT", "ETHUSDT", "1810.HK", "2015.HK"]
        let currentSymbols = config.assets.map(\.symbol)
        if currentSymbols == legacyDefaultSymbols {
            config.assets.removeAll { ["1810.HK", "2015.HK"].contains($0.symbol) }
            changed = true
        }
        return changed
    }

    static func write(_ config: AppConfig) {
        do {
            let encoder = JSONEncoder()
            encoder.outputFormatting = [.prettyPrinted, .sortedKeys]
            let data = try encoder.encode(config)
            try data.write(to: configURL, options: .atomic)
        } catch {
            NSLog("CareAssets config write failed: \(error.localizedDescription)")
        }
    }
}

enum FontRegistrar {
    static func registerBundledFonts() {
        guard let url = Bundle.main.url(forResource: "Sen-Medium", withExtension: "ttf", subdirectory: "Fonts") else {
            return
        }
        CTFontManagerRegisterFontsForURL(url as CFURL, .process, nil)
    }
}

final class AssetService {
    private let session: URLSession

    init() {
        let configuration = URLSessionConfiguration.default
        configuration.timeoutIntervalForRequest = 12
        configuration.timeoutIntervalForResource = 18
        configuration.httpAdditionalHeaders = [
            "User-Agent": "CareAssets/1.0 macOS"
        ]
        session = URLSession(configuration: configuration)
    }

    func fetchAssets(config: AppConfig) async -> [DisplayAsset] {
        var results: [String: DisplayAsset] = [:]

        for asset in config.assets where asset.type == .gold {
            results[key(for: asset)] = await fetchGold(asset)
        }

        let cryptoAssets = config.assets.filter { $0.type == .crypto }
        if !cryptoAssets.isEmpty {
            let fetched = await fetchCryptoAssets(cryptoAssets)
            for (key, value) in fetched {
                results[key] = value
            }
        }

        let stockAssets = config.assets.filter { $0.type == .stock }
        if !stockAssets.isEmpty {
            let fetched = await fetchStockAssets(stockAssets)
            for (key, value) in fetched {
                results[key] = value
            }
        }

        return config.assets.map { asset in
            results[key(for: asset)] ?? DisplayAsset.loading(from: asset)
        }
    }

    private func key(for asset: TrackedAsset) -> String {
        "\(asset.type.rawValue)-\(asset.symbol)"
    }

    private func requestData(from url: URL) async throws -> Data {
        var request = URLRequest(url: url)
        request.setValue("CareAssets/1.0 macOS", forHTTPHeaderField: "User-Agent")
        request.cachePolicy = .reloadIgnoringLocalCacheData

        let (data, response) = try await session.data(for: request)
        if let http = response as? HTTPURLResponse, !(200...299).contains(http.statusCode) {
            throw NSError(domain: "CareAssets.HTTP", code: http.statusCode)
        }
        return data
    }
}

// MARK: - Gold

private struct JDGoldResponse: Decodable {
    var resultData: JDGoldResultData?
    var success: Bool?
}

private struct JDGoldResultData: Decodable {
    var datas: JDGoldData?
}

private struct JDGoldData: Decodable {
    var price: String?
    var yesterdayPrice: String?
    var upAndDownAmt: String?
    var upAndDownRate: String?
    var time: String?
}

private struct K780GoldResponse: Decodable {
    var success: String?
    var result: K780GoldResult?
    var msgid: String?
    var msg: String?
}

private struct K780GoldResult: Decodable {
    var dtList: [String: K780GoldQuote]?
}

private struct K780GoldQuote: Decodable {
    var varietynm: String?
    var lastPrice: String?
    var buyPrice: String?
    var sellPrice: String?
    var yesyPrice: String?
    var changePrice: String?
    var changeMargin: String?
    var uptime: String?

    enum CodingKeys: String, CodingKey {
        case varietynm
        case lastPrice = "last_price"
        case buyPrice = "buy_price"
        case sellPrice = "sell_price"
        case yesyPrice = "yesy_price"
        case changePrice = "change_price"
        case changeMargin = "change_margin"
        case uptime
    }
}

private struct CMBGoldRateResponse: Decodable {
    var body: CMBGoldRateBody?
}

private struct CMBGoldRateBody: Decodable {
    var data: [CMBGoldRateItem]?
    var time: String?
}

private struct CMBGoldRateItem: Decodable {
    var variety: String?
    var curPrice: String?
    var preClose: String?
    var time: String?
    var goldNo: String?
}

private struct ChineseGoldCloseReference {
    var close: Double
    var updatedAt: Date?
}

extension AssetService {
    private func fetchGold(_ asset: TrackedAsset) async -> DisplayAsset {
        if L10n.usesChineseMarketUnits {
            if let quote = await fetchK780ChineseGold(asset) {
                return quote
            }
            return await fetchDerivedChineseGold(asset)
        }

        return await fetchInternationalGold(asset)
    }

    private func fetchK780ChineseGold(_ asset: TrackedAsset) async -> DisplayAsset? {
        let url = URL(string: "https://sapi.k780.com/?app=finance.gold_price&goldid=1011&appkey=10003&sign=b59bc3ef6191eb9f747dd4e83c99f2a4&format=json")!

        do {
            let data = try await requestData(from: url)
            let response = try JSONDecoder().decode(K780GoldResponse.self, from: data)
            guard response.success == "1",
                  let quote = response.result?.dtList?["1011"] ?? response.result?.dtList?.values.first,
                  let priceText = quote.lastPrice ?? quote.sellPrice ?? quote.buyPrice,
                  let price = Double(priceText),
                  price > 0 else {
                return nil
            }

            let directPrevious = positiveDouble(quote.yesyPrice)
            var changeAmount = meaningfulChange(quote.changePrice)
            var previous = directPrevious ?? changeAmount.map { price - $0 }.flatMap { $0 > 0 ? $0 : nil }
            var percent = meaningfulPercent(quote.changeMargin) ?? previous.flatMap { previousPrice -> Double? in
                guard previousPrice != 0 else { return nil }
                return (price - previousPrice) / previousPrice * 100.0
            }
            if previous == nil || percent == nil {
                if let closeReference = try? await fetchChineseGoldCloseReference() {
                    previous = previous ?? closeReference.close
                }
            }
            if changeAmount == nil, let previous {
                changeAmount = price - previous
            }
            if percent == nil, let previous, previous != 0 {
                percent = (price - previous) / previous * 100.0
            }
            let detail: String
            if let previous {
                detail = "\(L10n.close) \(formatCNY(previous, compact: false))\(L10n.gramSuffix)"
            } else {
                detail = quote.varietynm ?? L10n.cnyPerGram
            }

            return DisplayAsset(
                id: key(for: asset),
                type: .gold,
                name: asset.name,
                symbol: asset.symbol,
                source: "K780",
                menuPriceText: formatStatusNumber(price, minFraction: 0, maxFraction: 0),
                priceText: "\(formatCNY(price, compact: false))\(L10n.gramSuffix)",
                detailText: detail,
                changeText: formatChange(amount: changeAmount, percent: percent, currencyPrefix: "¥"),
                changePercent: percent,
                updatedAt: parseLocalDateTime(quote.uptime),
                visibleInMenuBar: asset.visibleInMenuBar,
                errorMessage: nil,
                timeSeries: nil,
                timeSeriesChange: nil,
                timeSeriesHigh: nil,
                timeSeriesLow: nil
            )
        } catch {
            return nil
        }
    }

    private func fetchChineseGoldCloseReference() async throws -> ChineseGoldCloseReference? {
        let url = URL(string: "https://m.cmbchina.com/api/rate/gold?no=AUTD")!
        let data = try await requestData(from: url)
        let response = try JSONDecoder().decode(CMBGoldRateResponse.self, from: data)
        guard let body = response.body, let items = body.data else { return nil }
        let item = items.first { $0.goldNo?.uppercased() == "AUTD" } ?? items.first
        guard let item, let close = positiveDouble(item.curPrice) else { return nil }

        let datePrefix = body.time?.split(separator: " ").first.map(String.init)
        let updatedAt = datePrefix.flatMap { date in
            item.time.flatMap { parseLocalDateTime("\(date) \($0)") }
        } ?? parseLocalDateTime(body.time)
        return ChineseGoldCloseReference(close: close, updatedAt: updatedAt)
    }

    private func fetchDerivedChineseGold(_ asset: TrackedAsset) async -> DisplayAsset {
        let encodedSymbol = "GC=F".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "GC=F"
        let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(encodedSymbol)?range=1d&interval=5m")!

        do {
            async let goldData = requestData(from: url)
            async let usdCnyQuote = fetchFXQuote(from: "USD", to: "CNY")

            let data = try await goldData
            let usdCny = try await usdCnyQuote
            let response = try JSONDecoder().decode(YahooChartResponse.self, from: data)
            guard let meta = response.chart.result?.first?.meta,
                  let ouncePrice = meta.regularMarketPrice else {
                throw NSError(domain: "CareAssets.Gold", code: 2)
            }

            let gramsPerTroyOunce = 31.1034768
            let price = ouncePrice * usdCny.rate / gramsPerTroyOunce
            let previous = meta.chartPreviousClose.map { ouncePreviousClose in
                ouncePreviousClose * (usdCny.previousClose ?? usdCny.rate) / gramsPerTroyOunce
            }
            let change = previous.map { price - $0 }
            let percent = previous.flatMap { previousPrice -> Double? in
                guard previousPrice != 0 else { return nil }
                return (price - previousPrice) / previousPrice * 100.0
            }
            let goldUpdatedAt = meta.regularMarketTime.map { Date(timeIntervalSince1970: TimeInterval($0)) }
            let updatedAt = latestDate(goldUpdatedAt, usdCny.updatedAt)

            return DisplayAsset(
                id: key(for: asset),
                type: .gold,
                name: asset.name,
                symbol: asset.symbol,
                source: "Yahoo Finance",
                menuPriceText: formatStatusNumber(price, minFraction: 0, maxFraction: 0),
                priceText: "\(formatCNY(price, compact: false))\(L10n.gramSuffix)",
                detailText: previous.map { "\(L10n.close) \(formatCNY($0, compact: false))\(L10n.gramSuffix)" } ?? L10n.cnyPerGram,
                changeText: formatChange(amount: change, percent: percent, currencyPrefix: "¥"),
                changePercent: percent,
                updatedAt: updatedAt,
                visibleInMenuBar: asset.visibleInMenuBar,
                errorMessage: nil,
                timeSeries: nil,
                timeSeriesChange: nil,
                timeSeriesHigh: nil,
                timeSeriesLow: nil
            )
        } catch {
            return errorAsset(asset, source: "Yahoo Finance", message: error.localizedDescription)
        }
    }

    private func fetchInternationalGold(_ asset: TrackedAsset) async -> DisplayAsset {
        let encodedSymbol = "GC=F".addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? "GC=F"
        let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(encodedSymbol)?range=1d&interval=5m")!

        do {
            let data = try await requestData(from: url)
            let response = try JSONDecoder().decode(YahooChartResponse.self, from: data)
            guard let meta = response.chart.result?.first?.meta,
                  let price = meta.regularMarketPrice else {
                throw NSError(domain: "CareAssets.Gold", code: 2)
            }

            let previous = meta.chartPreviousClose
            let change = previous.map { price - $0 }
            let percent = previous.flatMap { previousPrice -> Double? in
                guard previousPrice != 0 else { return nil }
                return (price - previousPrice) / previousPrice * 100.0
            }
            let currency = meta.currency ?? "USD"
            let updatedAt = meta.regularMarketTime.map { Date(timeIntervalSince1970: TimeInterval($0)) }

            return DisplayAsset(
                id: key(for: asset),
                type: .gold,
                name: asset.name,
                symbol: asset.symbol,
                source: "Yahoo Finance",
                menuPriceText: formatStatusNumber(price, minFraction: 0, maxFraction: 0),
                priceText: "\(formatCurrency(price, currencyCode: currency, compact: false))\(L10n.ounceSuffix)",
                detailText: previous.map { "\(L10n.close) \(formatCurrency($0, currencyCode: currency, compact: false))\(L10n.ounceSuffix)" } ?? L10n.usdPerOunce,
                changeText: formatChange(amount: change, percent: percent, currencyPrefix: currencySymbol(for: currency)),
                changePercent: percent,
                updatedAt: updatedAt,
                visibleInMenuBar: asset.visibleInMenuBar,
                errorMessage: nil,
                timeSeries: nil,
                timeSeriesChange: nil,
                timeSeriesHigh: nil,
                timeSeriesLow: nil
            )
        } catch {
            return errorAsset(asset, source: "Yahoo Finance", message: error.localizedDescription)
        }
    }
}

// MARK: - Crypto

private struct CoinbaseTicker: Decodable {
    var price: String?
    var time: String?
}

private struct CoinbaseStats: Decodable {
    var open: String?
}

private struct CoinbaseProduct: Decodable {
    var id: String
    var baseCurrency: String
    var quoteCurrency: String
    var displayName: String?

    enum CodingKeys: String, CodingKey {
        case id
        case baseCurrency = "base_currency"
        case quoteCurrency = "quote_currency"
        case displayName = "display_name"
    }
}

extension AssetService {
    private func fetchCryptoAssets(_ assets: [TrackedAsset]) async -> [String: DisplayAsset] {
        var output: [String: DisplayAsset] = [:]
        for asset in assets {
            output[key(for: asset)] = await fetchCoinbaseCryptoAsset(asset)
        }
        return output
    }

    private func fetchCoinbaseCryptoAsset(_ asset: TrackedAsset) async -> DisplayAsset {
        let productID = coinbaseProductID(for: asset.symbol)
        let encodedProductID = productID.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? productID
        let tickerURL = URL(string: "https://api.exchange.coinbase.com/products/\(encodedProductID)/ticker")!
        let statsURL = URL(string: "https://api.exchange.coinbase.com/products/\(encodedProductID)/stats")!
        let candlesURL = URL(string: "https://api.exchange.coinbase.com/products/\(encodedProductID)/candles?granularity=300")!

        do {
            async let tickerData = requestData(from: tickerURL)
            async let statsData = requestData(from: statsURL)
            async let candlesData = requestData(from: candlesURL)

            let ticker = try await JSONDecoder().decode(CoinbaseTicker.self, from: tickerData)
            let stats = try await JSONDecoder().decode(CoinbaseStats.self, from: statsData)
            let candles = try await JSONDecoder().decode([[Double]].self, from: candlesData)

            guard let priceText = ticker.price, let price = Double(priceText) else {
                throw NSError(domain: "CareAssets.Coinbase", code: 1)
            }

            let open = stats.open.flatMap(Double.init)
            let change = open.map { price - $0 }
            let percent = open.flatMap { openPrice -> Double? in
                guard openPrice != 0 else { return nil }
                return (price - openPrice) / openPrice * 100.0
            }
            let quoteCurrency = productID.split(separator: "-").last.map(String.init) ?? "USDT"
            
            // 处理分时线数据 [time, low, high, open, close, volume]
            var timeSeries: [TimeSeriesData] = []
            var timeSeriesHigh: Double? = nil
            var timeSeriesLow: Double? = nil
            var timeSeriesChange: Double? = nil
            
            if !candles.isEmpty {
                let sortedCandles = candles.sorted { $0[0] < $1[0] }
                for candle in sortedCandles {
                    if candle.count >= 5 {
                        let timestamp = Date(timeIntervalSince1970: candle[0])
                        let closePrice = candle[4]
                        let volume = candle.count > 5 ? Int(candle[5]) : nil
                        timeSeries.append(TimeSeriesData(timestamp: timestamp, price: closePrice, volume: volume))
                    }
                }
                
                if !timeSeries.isEmpty {
                    let prices = timeSeries.map { $0.price }
                    timeSeriesHigh = prices.max()
                    timeSeriesLow = prices.min()
                    let firstPrice = timeSeries.first!.price
                    let lastPrice = timeSeries.last!.price
                    timeSeriesChange = (lastPrice - firstPrice) / firstPrice * 100
                }
            }

            return DisplayAsset(
                id: key(for: asset),
                type: .crypto,
                name: asset.name,
                symbol: asset.symbol,
                source: "Coinbase",
                menuPriceText: formatStatusNumber(price, minFraction: 0, maxFraction: 0),
                priceText: "\(formatNumber(price, minFraction: 2, maxFraction: 2)) \(quoteCurrency)",
                detailText: productID,
                changeText: formatChange(amount: change, percent: percent, currencyPrefix: ""),
                changePercent: percent,
                updatedAt: parseISO8601Date(ticker.time),
                visibleInMenuBar: asset.visibleInMenuBar,
                errorMessage: nil,
                timeSeries: timeSeries.isEmpty ? nil : timeSeries,
                timeSeriesChange: timeSeriesChange,
                timeSeriesHigh: timeSeriesHigh,
                timeSeriesLow: timeSeriesLow
            )
        } catch {
            return errorAsset(asset, source: "Coinbase", message: error.localizedDescription)
        }
    }

    private func coinbaseProductID(for symbol: String) -> String {
        let uppercased = symbol.uppercased()
        if uppercased.contains("-") {
            return uppercased
        }

        for quote in ["USDT", "USDC", "USD"] {
            if uppercased.hasSuffix(quote) {
                let base = uppercased.dropLast(quote.count)
                return "\(base)-\(quote)"
            }
        }

        return "\(uppercased)-USDT"
    }
}

// MARK: - Stocks and FX

private struct YahooChartResponse: Decodable {
    var chart: YahooChart
}

private struct YahooChart: Decodable {
    var result: [YahooResult]?
}

private struct YahooResult: Decodable {
    var meta: YahooMeta
}

private struct YahooMeta: Decodable {
    var currency: String?
    var symbol: String?
    var regularMarketTime: Int?
    var regularMarketPrice: Double?
    var chartPreviousClose: Double?
    var shortName: String?
    var longName: String?
}

private struct YahooSearchResponse: Decodable {
    var quotes: [YahooSearchQuote]?
}

private struct YahooSearchQuote: Decodable {
    var symbol: String?
    var shortname: String?
    var longname: String?
    var quoteType: String?
    var exchDisp: String?
    var exchange: String?
}

private struct AlphaVantageSearchResponse: Decodable {
    var bestMatches: [AlphaVantageMatch]?
}

private struct AlphaVantageMatch: Decodable {
    var symbol: String?
    var name: String?
    var type: String?
    var region: String?

    enum CodingKeys: String, CodingKey {
        case symbol = "1. symbol"
        case name = "2. name"
        case type = "3. type"
        case region = "4. region"
    }
}

private struct RawStockQuote {
    var asset: TrackedAsset
    var price: Double
    var previousClose: Double?
    var currency: String
    var displayName: String
    var updatedAt: Date?
}

private struct FXQuote {
    var rate: Double
    var previousClose: Double?
    var updatedAt: Date?
}

extension AssetService {
    func searchAssets(query: String) async throws -> [AssetSearchResult] {
        let trimmed = query.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !trimmed.isEmpty else { return [] }

        var stockResults: [AssetSearchResult] = []
        var cryptoResults: [AssetSearchResult] = []
        var firstError: Error?

        do {
            stockResults.append(contentsOf: try await searchYahooStocks(query: trimmed))
        } catch {
            firstError = error
        }

        if stockResults.isEmpty {
            if let fallback = try? await searchAlphaVantageStocks(query: trimmed) {
                stockResults.append(contentsOf: fallback)
            }
        }

        do {
            cryptoResults.append(contentsOf: try await searchCoinbaseCryptoAssets(query: trimmed))
        } catch {
            if firstError == nil {
                firstError = error
            }
        }

        let uniqueResults = rankAssetSearchResults(uniqueAssetSearchResults(cryptoResults + stockResults), query: trimmed)
        if uniqueResults.isEmpty, let firstError {
            throw firstError
        }
        return Array(uniqueResults.prefix(12))
    }

    private func fetchStockAssets(_ assets: [TrackedAsset]) async -> [String: DisplayAsset] {
        var rawQuotes: [RawStockQuote] = []
        var output: [String: DisplayAsset] = [:]

        for asset in assets {
            do {
                rawQuotes.append(try await fetchStockQuote(asset))
            } catch {
                output[key(for: asset)] = errorAsset(asset, source: "Yahoo Finance", message: error.localizedDescription)
            }
        }

        for quote in rawQuotes {
            let change = quote.previousClose.map { quote.price - $0 }
            let percent = quote.previousClose.flatMap { previous -> Double? in
                guard previous != 0 else { return nil }
                return (quote.price - previous) / previous * 100.0
            }

            output[key(for: quote.asset)] = DisplayAsset(
                id: key(for: quote.asset),
                type: .stock,
                name: quote.asset.name,
                symbol: quote.asset.symbol,
                source: "Yahoo Finance",
                menuPriceText: formatStatusNumber(quote.price, minFraction: 2, maxFraction: 2),
                priceText: "\(formatCurrency(quote.price, currencyCode: quote.currency, compact: false)) \(quote.currency)",
                detailText: quote.asset.symbol,
                changeText: formatChange(amount: change, percent: percent, currencyPrefix: currencySymbol(for: quote.currency)),
                changePercent: percent,
                updatedAt: quote.updatedAt,
                visibleInMenuBar: quote.asset.visibleInMenuBar,
                errorMessage: nil,
                timeSeries: nil,
                timeSeriesChange: nil,
                timeSeriesHigh: nil,
                timeSeriesLow: nil
            )
        }

        return output
    }

    private func searchYahooStocks(query: String) async throws -> [AssetSearchResult] {
        var components = URLComponents(string: "https://query1.finance.yahoo.com/v1/finance/search")!
        components.queryItems = [
            URLQueryItem(name: "q", value: query),
            URLQueryItem(name: "quotesCount", value: "12"),
            URLQueryItem(name: "newsCount", value: "0")
        ]

        guard let url = components.url else { return [] }
        let data = try await requestData(from: url)
        let response = try JSONDecoder().decode(YahooSearchResponse.self, from: data)

        return (response.quotes ?? []).compactMap { quote in
            guard let symbol = quote.symbol?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !symbol.isEmpty else { return nil }

            let type = quote.quoteType?.uppercased() ?? ""
            if !type.isEmpty, !["EQUITY", "ETF"].contains(type) {
                return nil
            }

            let name = quote.shortname ?? quote.longname ?? symbol
            let exchange = quote.exchDisp ?? quote.exchange ?? "Yahoo"
            return AssetSearchResult(type: .stock, name: name, symbol: symbol.uppercased(), source: exchange)
        }
    }

    private func searchAlphaVantageStocks(query: String) async throws -> [AssetSearchResult] {
        var components = URLComponents(string: "https://www.alphavantage.co/query")!
        components.queryItems = [
            URLQueryItem(name: "function", value: "SYMBOL_SEARCH"),
            URLQueryItem(name: "keywords", value: query),
            URLQueryItem(name: "apikey", value: "demo")
        ]

        guard let url = components.url else { return [] }
        let data = try await requestData(from: url)
        let response = try JSONDecoder().decode(AlphaVantageSearchResponse.self, from: data)

        return (response.bestMatches ?? []).compactMap { match in
            guard let symbol = match.symbol?.trimmingCharacters(in: .whitespacesAndNewlines),
                  let name = match.name?.trimmingCharacters(in: .whitespacesAndNewlines),
                  !symbol.isEmpty,
                  !name.isEmpty else { return nil }

            let type = match.type?.uppercased() ?? ""
            if !type.isEmpty, !["EQUITY", "ETF"].contains(type) {
                return nil
            }

            return AssetSearchResult(type: .stock, name: name, symbol: symbol.uppercased(), source: match.region ?? "Alpha Vantage")
        }
    }

    private func searchCoinbaseCryptoAssets(query: String) async throws -> [AssetSearchResult] {
        let normalizedQuery = normalizedSearchText(query)
        guard !normalizedQuery.isEmpty else { return [] }

        let url = URL(string: "https://api.exchange.coinbase.com/products")!
        let data = try await requestData(from: url)
        let products = try JSONDecoder().decode([CoinbaseProduct].self, from: data)
        let quotePriority = ["USDT": 0, "USD": 1, "USDC": 2]

        let matches = products.compactMap { product -> (AssetSearchResult, Int)? in
            let base = product.baseCurrency.uppercased()
            let quote = product.quoteCurrency.uppercased()
            guard let priority = quotePriority[quote], !base.isEmpty else { return nil }

            let aliases = cryptoAliases(for: base)
            let searchFields = [product.id, base, product.displayName ?? ""] + aliases
            let isMatch = searchFields
                .map(normalizedSearchText)
                .contains { searchFieldMatches($0, query: normalizedQuery) }
            guard isMatch else { return nil }

            let symbol = "\(base)\(quote)"
            let result = AssetSearchResult(
                type: .crypto,
                name: cryptoDisplayName(for: base),
                symbol: symbol,
                source: "Coinbase"
            )
            return (result, priority)
        }
        .sorted { lhs, rhs in
            if lhs.1 != rhs.1 {
                return lhs.1 < rhs.1
            }
            return lhs.0.symbol < rhs.0.symbol
        }

        var seenBases: Set<String> = []
        var output: [AssetSearchResult] = []
        for match in matches {
            let base = cryptoBaseSymbol(from: match.0.symbol)
            guard !seenBases.contains(base) else { continue }
            seenBases.insert(base)
            output.append(match.0)
        }
        return output
    }

    private func uniqueAssetSearchResults(_ results: [AssetSearchResult]) -> [AssetSearchResult] {
        var seen: Set<String> = []
        var output: [AssetSearchResult] = []
        for result in results {
            let id = result.id.uppercased()
            guard !seen.contains(id) else { continue }
            seen.insert(id)
            output.append(result)
        }
        return output
    }

    private func rankAssetSearchResults(_ results: [AssetSearchResult], query: String) -> [AssetSearchResult] {
        let normalizedQuery = normalizedSearchText(query)
        return results.sorted { lhs, rhs in
            let leftScore = searchScore(for: lhs, query: normalizedQuery)
            let rightScore = searchScore(for: rhs, query: normalizedQuery)
            if leftScore != rightScore {
                return leftScore < rightScore
            }
            if lhs.type != rhs.type {
                return lhs.type == .crypto
            }
            return lhs.symbol < rhs.symbol
        }
    }

    private func normalizedSearchText(_ text: String) -> String {
        text
            .folding(options: [.diacriticInsensitive, .caseInsensitive, .widthInsensitive], locale: .current)
            .lowercased()
            .replacingOccurrences(of: " ", with: "")
            .replacingOccurrences(of: "-", with: "")
            .replacingOccurrences(of: "_", with: "")
            .replacingOccurrences(of: "/", with: "")
            .replacingOccurrences(of: ".", with: "")
    }

    private func searchFieldMatches(_ field: String, query: String) -> Bool {
        guard !field.isEmpty, !query.isEmpty else { return false }
        if field == query || field.hasPrefix(query) {
            return true
        }
        if query.count >= 2, field.contains(query) {
            return true
        }
        if query.count >= 3, query.contains(field) {
            return true
        }
        return false
    }

    private func searchScore(for result: AssetSearchResult, query: String) -> Int {
        let fields = searchFields(for: result).map(normalizedSearchText)
        if fields.contains(query) {
            return 0
        }
        if fields.contains(where: { $0.hasPrefix(query) }) {
            return 10
        }
        if fields.contains(where: { $0.contains(query) }) {
            return 20
        }
        return 100
    }

    private func searchFields(for result: AssetSearchResult) -> [String] {
        var fields = [result.symbol, result.name, result.source]
        if result.type == .crypto {
            fields += cryptoAliases(for: cryptoBaseSymbol(from: result.symbol))
        }
        return fields
    }

    private func cryptoAliases(for base: String) -> [String] {
        [
            "BTC": ["Bitcoin", "比特币", "bitebi"],
            "ETH": ["Ethereum", "以太坊", "yitaifang"],
            "SOL": ["Solana"],
            "DOGE": ["Dogecoin", "狗狗币", "gougoubi"],
            "XRP": ["Ripple", "ruibo"],
            "ADA": ["Cardano"],
            "AVAX": ["Avalanche"],
            "DOT": ["Polkadot", "bodian"],
            "LINK": ["Chainlink"],
            "LTC": ["Litecoin", "莱特币", "laitebi"],
            "BCH": ["Bitcoin Cash", "bitekexianjin"],
            "UNI": ["Uniswap"],
            "AAVE": ["Aave"],
            "MATIC": ["Polygon"],
            "SHIB": ["Shiba Inu", "shib"],
        ][base.uppercased()] ?? []
    }

    private func cryptoDisplayName(for base: String) -> String {
        base.uppercased()
    }

    private func cryptoBaseSymbol(from symbol: String) -> String {
        let uppercased = symbol.uppercased()
        for quote in ["USDT", "USDC", "USD"] {
            if uppercased.hasSuffix(quote) {
                return String(uppercased.dropLast(quote.count))
            }
        }
        return uppercased
    }

    private func fetchStockQuote(_ asset: TrackedAsset) async throws -> RawStockQuote {
        let encodedSymbol = asset.symbol.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? asset.symbol
        let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(encodedSymbol)?range=1d&interval=5m")!
        let data = try await requestData(from: url)
        let response = try JSONDecoder().decode(YahooChartResponse.self, from: data)

        guard let meta = response.chart.result?.first?.meta,
              let price = meta.regularMarketPrice,
              let currency = meta.currency else {
            throw NSError(domain: "CareAssets.Stock", code: 1)
        }

        return RawStockQuote(
            asset: asset,
            price: price,
            previousClose: meta.chartPreviousClose,
            currency: currency.uppercased(),
            displayName: meta.shortName ?? meta.longName ?? asset.name,
            updatedAt: meta.regularMarketTime.map { Date(timeIntervalSince1970: TimeInterval($0)) }
        )
    }

    private func fetchFXRate(from sourceCurrency: String, to targetCurrency: String) async throws -> Double {
        try await fetchFXQuote(from: sourceCurrency, to: targetCurrency).rate
    }

    private func fetchFXQuote(from sourceCurrency: String, to targetCurrency: String) async throws -> FXQuote {
        let symbol = "\(sourceCurrency.uppercased())\(targetCurrency.uppercased())=X"
        let encodedSymbol = symbol.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed) ?? symbol
        let url = URL(string: "https://query1.finance.yahoo.com/v8/finance/chart/\(encodedSymbol)?range=1d&interval=5m")!
        let data = try await requestData(from: url)
        let response = try JSONDecoder().decode(YahooChartResponse.self, from: data)

        guard let meta = response.chart.result?.first?.meta,
              let price = meta.regularMarketPrice else {
            throw NSError(domain: "CareAssets.FX", code: 1)
        }
        return FXQuote(
            rate: price,
            previousClose: meta.chartPreviousClose,
            updatedAt: meta.regularMarketTime.map { Date(timeIntervalSince1970: TimeInterval($0)) }
        )
    }
}

// MARK: - UI

final class StatusTickerView: NSView {
    var items: [DisplayAsset] = [] {
        didSet {
            needsDisplay = true
        }
    }

    var colorMode: PriceColorMode = .white {
        didSet {
            needsDisplay = true
        }
    }

    var backgroundMode: StatusBarBackgroundMode = .dark {
        didSet {
            needsDisplay = true
        }
    }

    var onClick: (() -> Void)?
    var loadingFrame = 0 {
        didSet {
            needsDisplay = true
        }
    }
    var cellWidth: CGFloat = 48 {
        didSet {
            invalidateIntrinsicContentSize()
            needsDisplay = true
        }
    }

    var priceDisplayMode: PriceDisplayMode = .standard {
        didSet {
            needsDisplay = true
        }
    }

    var timeSeriesDisplayMode: TimeSeriesDisplayMode = .hidden {
        didSet {
            needsDisplay = true
        }
    }

    var preferredWidth: CGFloat {
        max(28, CGFloat(items.count) * cellWidth)
    }

    override var intrinsicContentSize: NSSize {
        NSSize(width: preferredWidth, height: NSStatusBar.system.thickness)
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        drawTicker(in: bounds)
    }

    override func viewDidChangeEffectiveAppearance() {
        super.viewDidChangeEffectiveAppearance()
        needsDisplay = true
    }

    func renderedImage() -> NSImage {
        let size = NSSize(width: preferredWidth, height: NSStatusBar.system.thickness)
        let image = NSImage(size: size)
        image.lockFocus()
        NSGraphicsContext.current?.imageInterpolation = .high
        drawTicker(in: NSRect(origin: .zero, size: size))
        image.unlockFocus()
        image.isTemplate = false
        return image
    }

    private func drawTicker(in bounds: NSRect) {
        guard !items.isEmpty else { return }

        let center = NSMutableParagraphStyle()
        center.alignment = .center

        let titleHeight: CGFloat = 10
        let valueHeight: CGFloat = 13
        let titleY = max(0, bounds.height - titleHeight - 0.5)
        let valueY = max(0, titleY - valueHeight + 2)
        let chartHeight: CGFloat = timeSeriesDisplayMode != .hidden ? 12 : 0
        let chartY: CGFloat = max(0, valueY - chartHeight - 2)

        for (index, item) in items.enumerated() {
            let cellX = CGFloat(index) * cellWidth
            let rect = NSRect(x: cellX - 2, y: 0, width: cellWidth + 4, height: bounds.height)

            // 绘制分时线
            if timeSeriesDisplayMode != .hidden, let timeSeries = item.timeSeries, !timeSeries.isEmpty {
                drawTimeSeriesChart(
                    timeSeries: timeSeries,
                    in: NSRect(x: rect.minX + 2, y: chartY, width: rect.width - 4, height: chartHeight),
                    displayMode: timeSeriesDisplayMode,
                    item: item
                )
            }

            drawStatusText(
                titleText(for: item),
                baseFont: appFont(ofSize: 7, weight: .regular),
                asciiFont: senFont(ofSize: 7),
                color: statusTitleColor(alpha: 0.86),
                paragraphStyle: center,
                in: NSRect(x: rect.minX, y: titleY, width: rect.width, height: titleHeight)
            )
            drawStatusText(
                valueText(for: item),
                baseFont: appFont(ofSize: 11.5, weight: .regular),
                asciiFont: senFont(ofSize: 11.5),
                color: valueColor(for: item),
                paragraphStyle: center,
                in: NSRect(x: rect.minX, y: valueY, width: rect.width, height: valueHeight)
            )
        }
    }

    private func drawTimeSeriesChart(timeSeries: [TimeSeriesData], in rect: NSRect, displayMode: TimeSeriesDisplayMode, item: DisplayAsset) {
        guard !timeSeries.isEmpty, rect.width > 0, rect.height > 0 else { return }

        let prices = timeSeries.map { $0.price }
        guard let minPrice = prices.min(), let maxPrice = prices.max() else { return }

        let priceRange = maxPrice - minPrice
        let scale: CGFloat = priceRange > 0 ? rect.height / CGFloat(priceRange) : 1

        // 确定线条颜色
        let lineColor: NSColor
        if let change = item.timeSeriesChange {
            lineColor = change >= 0 ? NSColor(calibratedRed: 0.2, green: 0.8, blue: 0.2, alpha: 0.8) : NSColor(calibratedRed: 0.9, green: 0.3, blue: 0.3, alpha: 0.8)
        } else {
            lineColor = NSColor.white.withAlphaComponent(0.6)
        }

        lineColor.setStroke()

        let path = NSBezierPath()
        path.lineWidth = 0.8

        // 绘制分时线
        for (index, timeData) in timeSeries.enumerated() {
            let x = rect.minX + (CGFloat(index) / CGFloat(max(1, timeSeries.count - 1))) * rect.width
            let y = rect.minY + (CGFloat(timeData.price - minPrice) * scale)

            if index == 0 {
                path.move(to: NSPoint(x: x, y: y))
            } else {
                path.line(to: NSPoint(x: x, y: y))
            }
        }

        path.stroke()

        // 方案B：添加填充和额外信息
        if displayMode == .schemeB {
            // 绘制填充区域
            let fillPath = NSBezierPath()
            fillPath.lineWidth = 0
            
            // 复制路径点
            for (index, timeData) in timeSeries.enumerated() {
                let x = rect.minX + (CGFloat(index) / CGFloat(max(1, timeSeries.count - 1))) * rect.width
                let y = rect.minY + (CGFloat(timeData.price - minPrice) * scale)
                
                if index == 0 {
                    fillPath.move(to: NSPoint(x: x, y: y))
                } else {
                    fillPath.line(to: NSPoint(x: x, y: y))
                }
            }
            
            fillPath.line(to: NSPoint(x: rect.maxX, y: rect.minY))
            fillPath.line(to: NSPoint(x: rect.minX, y: rect.minY))
            fillPath.close()

            lineColor.withAlphaComponent(0.15).setFill()
            fillPath.fill()

            // 绘制最高和最低点
            if let high = item.timeSeriesHigh, let low = item.timeSeriesLow {
                let highY = rect.minY + (CGFloat(high - minPrice) * scale)
                let lowY = rect.minY + (CGFloat(low - minPrice) * scale)

                // 最高点标记
                NSColor.green.withAlphaComponent(0.6).setFill()
                let highCircle = NSBezierPath(ovalIn: NSRect(x: rect.maxX - 2, y: highY - 1, width: 2, height: 2))
                highCircle.fill()

                // 最低点标记
                NSColor.red.withAlphaComponent(0.6).setFill()
                let lowCircle = NSBezierPath(ovalIn: NSRect(x: rect.maxX - 2, y: lowY - 1, width: 2, height: 2))
                lowCircle.fill()
            }
        }
    }

    override func mouseDown(with event: NSEvent) {
        onClick?()
    }

    private func valueText(for item: DisplayAsset) -> String {
        if item.menuPriceText == "--" {
            return loadingTickerText()
        }
        guard let arrow = directionArrow(for: item) else {
            return item.menuPriceText
        }
        
        switch priceDisplayMode {
        case .compact:
            return "\(arrow)\(item.menuPriceText)"
        case .standard:
            if let changePercent = item.changePercent {
                let percentStr = String(format: "%.1f%%", abs(changePercent))
                return "\(arrow)\(item.menuPriceText) (\(percentStr))"
            }
            return "\(arrow)\(item.menuPriceText)"
        case .detailed:
            if let changePercent = item.changePercent {
                let percentStr = String(format: "%.1f%%", abs(changePercent))
                return "\(arrow)\(item.menuPriceText) (\(percentStr))"
            }
            return "\(arrow)\(item.menuPriceText)"
        }
    }

    private func loadingTickerText() -> String {
        "load" + String(repeating: ".", count: loadingFrame % 3 + 1)
    }

    private func titleText(for item: DisplayAsset) -> String {
        if item.type == .gold, item.symbol == "JD_GOLD" {
            return L10n.gold
        }
        return item.name
    }

    private func valueColor(for item: DisplayAsset) -> NSColor {
        if item.errorMessage != nil {
            return statusTextColor(alpha: 0.58)
        }

        guard let percent = item.changePercent, percent != 0 else {
            return statusTextColor(alpha: 0.94)
        }

        switch colorMode {
        case .white:
            return statusTextColor(alpha: 0.94)
        case .redRiseGreenFall:
            return percent > 0 ? statusRed : statusGreen
        case .redFallGreenRise:
            return percent > 0 ? statusGreen : statusRed
        }
    }

    private func directionArrow(for item: DisplayAsset) -> String? {
        guard item.errorMessage == nil, let percent = item.changePercent else {
            return nil
        }
        if percent > 0 {
            return "↑"
        }
        if percent < 0 {
            return "↓"
        }
        return nil
    }

    private var statusGreen: NSColor {
        if backgroundMode == .light {
            return NSColor(calibratedRed: 0.00, green: 0.58, blue: 0.22, alpha: 1)
        }
        return NSColor(calibratedRed: 0.28, green: 0.88, blue: 0.45, alpha: 1)
    }

    private var statusRed: NSColor {
        if backgroundMode == .light {
            return NSColor(calibratedRed: 0.84, green: 0.06, blue: 0.10, alpha: 1)
        }
        return NSColor(calibratedRed: 1.0, green: 0.27, blue: 0.32, alpha: 1)
    }

    private func statusTitleColor(alpha: CGFloat) -> NSColor {
        switch backgroundMode {
        case .dark:
            return NSColor.white.withAlphaComponent(alpha)
        case .light:
            return NSColor.black.withAlphaComponent(alpha)
        case .blue:
            return NSColor(calibratedRed: 0.22, green: 0.55, blue: 1.0, alpha: alpha)
        case .yellow:
            return NSColor(calibratedRed: 1.0, green: 0.78, blue: 0.18, alpha: alpha)
        case .purple:
            return NSColor(calibratedRed: 0.72, green: 0.44, blue: 1.0, alpha: alpha)
        }
    }

    private func statusTextColor(alpha: CGFloat) -> NSColor {
        if backgroundMode == .light {
            return NSColor.black.withAlphaComponent(alpha)
        }
        return NSColor.white.withAlphaComponent(alpha)
    }

    private func statusTextShadow(for color: NSColor) -> NSShadow {
        let shadow = NSShadow()
        let darkFill = perceivedLuminance(of: color) < 0.45
        shadow.shadowBlurRadius = darkFill ? 1.5 : 2
        shadow.shadowOffset = NSSize(width: 0, height: -0.5)
        shadow.shadowColor = darkFill
            ? NSColor.white.withAlphaComponent(0.55)
            : NSColor.black.withAlphaComponent(0.45)
        return shadow
    }

    private func perceivedLuminance(of color: NSColor) -> CGFloat {
        let converted = color.usingColorSpace(.sRGB) ?? color
        return converted.redComponent * 0.299 + converted.greenComponent * 0.587 + converted.blueComponent * 0.114
    }

    private func drawStatusText(
        _ text: String,
        baseFont: NSFont,
        asciiFont: NSFont,
        color: NSColor,
        paragraphStyle: NSParagraphStyle,
        in rect: NSRect
    ) {
        let attributed = NSMutableAttributedString(attributedString: mixedAttributedString(
            text,
            baseFont: baseFont,
            asciiFont: asciiFont,
            color: color,
            paragraphStyle: paragraphStyle
        ))
        attributed.addAttribute(.shadow, value: statusTextShadow(for: color), range: NSRange(location: 0, length: attributed.length))
        attributed.draw(in: rect)
    }
}

final class FlippedDocumentView: NSView {
    override var isFlipped: Bool {
        true
    }
}

extension NSPasteboard.PasteboardType {
    static let careAssetsAssetID = NSPasteboard.PasteboardType("com.careassets.asset-id")
}

final class AssetReorderRowView: NSStackView, NSDraggingSource {
    let assetID: String
    var onMoveAsset: ((String, String, Bool) -> Void)?

    private enum DropIndicatorPosition {
        case top
        case bottom
    }

    private var mouseDownEvent: NSEvent?
    private var didBeginDrag = false
    private var dropIndicatorPosition: DropIndicatorPosition? {
        didSet {
            needsDisplay = true
        }
    }

    init(assetID: String) {
        self.assetID = assetID
        super.init(frame: .zero)
        registerForDraggedTypes([.careAssetsAssetID])
    }

    required init?(coder: NSCoder) {
        nil
    }

    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        guard let dropIndicatorPosition else { return }

        let lineHeight: CGFloat = 2
        let y = dropIndicatorPosition == .top ? bounds.maxY - lineHeight : bounds.minY
        let rect = NSRect(x: 0, y: y, width: bounds.width, height: lineHeight)
        NSColor(calibratedRed: 0.45, green: 0.63, blue: 1.0, alpha: 0.95).setFill()
        NSBezierPath(roundedRect: rect, xRadius: 1, yRadius: 1).fill()
    }

    override func hitTest(_ point: NSPoint) -> NSView? {
        guard let hit = super.hitTest(point) else { return nil }
        return isButtonHit(hit) ? hit : self
    }

    override func mouseDown(with event: NSEvent) {
        mouseDownEvent = event
        didBeginDrag = false
    }

    override func mouseDragged(with event: NSEvent) {
        guard !didBeginDrag else { return }
        guard let mouseDownEvent else { return }

        let dx = event.locationInWindow.x - mouseDownEvent.locationInWindow.x
        let dy = event.locationInWindow.y - mouseDownEvent.locationInWindow.y
        guard hypot(dx, dy) > 4 else { return }

        didBeginDrag = true
        let pasteboardItem = NSPasteboardItem()
        pasteboardItem.setString(assetID, forType: .careAssetsAssetID)

        let draggingItem = NSDraggingItem(pasteboardWriter: pasteboardItem)
        draggingItem.setDraggingFrame(bounds, contents: draggingImage())
        beginDraggingSession(with: [draggingItem], event: mouseDownEvent, source: self)
    }

    override func mouseUp(with event: NSEvent) {
        mouseDownEvent = nil
        didBeginDrag = false
    }

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard draggingSourceID(from: sender) != nil else { return [] }
        updateDropIndicator(sender)
        return .move
    }

    override func draggingUpdated(_ sender: NSDraggingInfo) -> NSDragOperation {
        guard draggingSourceID(from: sender) != nil else {
            clearDropIndicator()
            return []
        }
        updateDropIndicator(sender)
        return .move
    }

    override func draggingExited(_ sender: NSDraggingInfo?) {
        clearDropIndicator()
    }

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        defer { clearDropIndicator() }
        guard let sourceID = draggingSourceID(from: sender), sourceID != assetID else {
            return false
        }

        let location = convert(sender.draggingLocation, from: nil)
        let placeAfterTarget = location.y < bounds.midY
        onMoveAsset?(sourceID, assetID, placeAfterTarget)
        return true
    }

    func draggingSession(_ session: NSDraggingSession, sourceOperationMaskFor context: NSDraggingContext) -> NSDragOperation {
        .move
    }

    func ignoreModifierKeys(for session: NSDraggingSession) -> Bool {
        true
    }

    private func isButtonHit(_ hit: NSView) -> Bool {
        var node: NSView? = hit
        while let current = node, current !== self {
            if current is NSButton {
                return true
            }
            node = current.superview
        }
        return false
    }

    private func draggingSourceID(from sender: NSDraggingInfo) -> String? {
        sender.draggingPasteboard.string(forType: .careAssetsAssetID)
    }

    private func draggingImage() -> NSImage {
        let image = NSImage(size: bounds.size)
        guard let representation = bitmapImageRepForCachingDisplay(in: bounds) else {
            return image
        }
        cacheDisplay(in: bounds, to: representation)
        image.addRepresentation(representation)
        return image
    }

    private func updateDropIndicator(_ sender: NSDraggingInfo) {
        let location = convert(sender.draggingLocation, from: nil)
        dropIndicatorPosition = location.y < bounds.midY ? .bottom : .top
    }

    private func clearDropIndicator() {
        dropIndicatorPosition = nil
    }
}

final class ClickableSearchResultRowView: NSStackView {
    var onClick: (() -> Void)?
    private var mouseDownEvent: NSEvent?
    private var didDrag = false

    override func hitTest(_ point: NSPoint) -> NSView? {
        super.hitTest(point) == nil ? nil : self
    }

    override func mouseDown(with event: NSEvent) {
        mouseDownEvent = event
        didDrag = false
    }

    override func mouseDragged(with event: NSEvent) {
        guard let mouseDownEvent else { return }
        let dx = event.locationInWindow.x - mouseDownEvent.locationInWindow.x
        let dy = event.locationInWindow.y - mouseDownEvent.locationInWindow.y
        if hypot(dx, dy) > 4 {
            didDrag = true
        }
    }

    override func mouseUp(with event: NSEvent) {
        if !didDrag {
            onClick?()
        }
        mouseDownEvent = nil
        didDrag = false
    }

    override func resetCursorRects() {
        addCursorRect(bounds, cursor: .pointingHand)
    }
}

final class SearchResultActionButton: NSButton {
    var isTracked = false {
        didSet {
            needsDisplay = true
        }
    }

    override var intrinsicContentSize: NSSize {
        NSSize(width: 18, height: 18)
    }

    override func draw(_ dirtyRect: NSRect) {
        let rect = bounds.insetBy(dx: 1, dy: 1)
        let path = NSBezierPath(roundedRect: rect, xRadius: 3, yRadius: 3)

        if isTracked {
            NSColor(calibratedRed: 0.09, green: 0.86, blue: 0.36, alpha: 1).setFill()
            path.fill()
        } else {
            NSColor.white.withAlphaComponent(0.14).setFill()
            path.fill()
            NSColor.white.withAlphaComponent(0.28).setStroke()
            path.lineWidth = 1
            path.stroke()
        }

        let title = isTracked ? "✓" : "+"
        let color = isTracked ? NSColor.white : NSColor.white.withAlphaComponent(0.88)
        let font = senFont(ofSize: isTracked ? 12 : 11)
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        let attributes: [NSAttributedString.Key: Any] = [
            .font: font,
            .foregroundColor: color,
            .paragraphStyle: paragraph
        ]
        let size = title.size(withAttributes: attributes)
        let textRect = NSRect(
            x: bounds.midX - size.width / 2,
            y: bounds.midY - size.height / 2 - 0.5,
            width: size.width,
            height: size.height
        )
        title.draw(in: textRect, withAttributes: attributes)
    }
}

final class AssetPanelViewController: NSViewController, NSTextFieldDelegate {
    private struct ScrollPosition {
        var y: CGFloat = 0
        var pinnedToBottom = false
    }

    var onSearchStocks: ((String) -> Void)?
    var onAddStock: ((AssetSearchResult) -> Void)?
    var onToggleVisible: ((String, Bool) -> Void)?
    var onRemoveAsset: ((String) -> Void)?
    var onMoveAsset: ((String, String, Bool) -> Void)?
    var onColorModeChange: ((PriceColorMode) -> Void)?
    var onStatusBarBackgroundModeChange: ((StatusBarBackgroundMode) -> Void)?
    var onLanguageChange: ((AppLanguage) -> Void)?
    var onItemSpacingChange: ((Int) -> Void)?
    var onPriceDisplayModeChange: ((PriceDisplayMode) -> Void)?
    var onTimeSeriesDisplayModeChange: ((TimeSeriesDisplayMode) -> Void)?
    var onPreferredContentSizeChange: ((NSSize) -> Void)?
    var onQuit: (() -> Void)?

    private var assets: [DisplayAsset] = []
    private var countdown: Int = 0
    private var isRefreshing = false
    private var colorMode: PriceColorMode = .white
    private var statusBarBackgroundMode: StatusBarBackgroundMode = .dark
    private var language: AppLanguage = .system
    private var priceDisplayMode: PriceDisplayMode = .standard
    private var itemSpacing: Int = 48
    private var timeSeriesDisplayMode: TimeSeriesDisplayMode = .hidden
    private var isSearchOpen = false
    private var isSearching = false
    private var searchQuery = ""
    private var searchResults: [AssetSearchResult] = []
    private var searchMessage: String?
    private weak var searchField: NSTextField?
    private weak var refreshStateLabel: NSTextField?
    private weak var toastView: NSView?
    private weak var assetScrollView: NSScrollView?
    private weak var searchScrollView: NSScrollView?
    private var assetScrollPosition = ScrollPosition()
    private var searchScrollPosition = ScrollPosition()
    private var toastWorkItem: DispatchWorkItem?
    private var shouldFocusSearchField = false
    private var searchModeListHeight: CGFloat?
    private let panelWidth: CGFloat = 430
    private var contentWidth: CGFloat { panelWidth - 36 }
    private var scrollWidth: CGFloat { isRTL ? contentWidth : contentWidth + horizontalInset }
    private let assetRowHeight: CGFloat = 52
    private let listRowGap: CGFloat = 8
    private let headerHeight: CGFloat = 30
    private let footerHeight: CGFloat = 30
    private let horizontalInset: CGFloat = 18
    private let topInset: CGFloat = 16
    private let bottomInset: CGFloat = 14
    private let stackSpacing: CGFloat = 10
    private let footerExtraTopSpacing: CGFloat = 6
    private let rtlScrollerGutterWidth: CGFloat = 10
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale.autoupdatingCurrent
        formatter.dateFormat = "yyyy-MM-dd HH:mm"
        return formatter
    }()

    override func loadView() {
        view = NSView(frame: NSRect(x: 0, y: 0, width: panelWidth, height: 360))
        view.appearance = NSAppearance(named: .darkAqua)
        view.userInterfaceLayoutDirection = L10n.isRightToLeft ? .rightToLeft : .leftToRight
        view.wantsLayer = true
        view.layer?.backgroundColor = NSColor(calibratedRed: 0.10, green: 0.11, blue: 0.13, alpha: 0.98).cgColor
        render()
    }

    func update(assets: [DisplayAsset], countdown: Int, isRefreshing: Bool, colorMode: PriceColorMode, statusBarBackgroundMode: StatusBarBackgroundMode, language: AppLanguage, priceDisplayMode: PriceDisplayMode = .standard, itemSpacing: Int = 48, timeSeriesDisplayMode: TimeSeriesDisplayMode = .hidden) {
        self.assets = assets
        self.countdown = countdown
        self.isRefreshing = isRefreshing
        self.colorMode = colorMode
        self.statusBarBackgroundMode = statusBarBackgroundMode
        self.language = language
        self.priceDisplayMode = priceDisplayMode
        self.itemSpacing = itemSpacing
        self.timeSeriesDisplayMode = timeSeriesDisplayMode
        if isSearchOpen {
            return
        }
        render()
    }

    func updateSearch(results: [AssetSearchResult], isSearching: Bool, message: String?) {
        self.searchResults = results
        self.isSearching = isSearching
        self.searchMessage = message
        render()
    }

    func updateRefreshState(countdown: Int, isRefreshing: Bool) {
        self.countdown = countdown
        self.isRefreshing = isRefreshing
        updateRefreshStateLabel()
    }

    private func render() {
        guard isViewLoaded else { return }
        captureScrollPositions()
        view.subviews.forEach { $0.removeFromSuperview() }
        view.userInterfaceLayoutDirection = isRTL ? .rightToLeft : .leftToRight

        let preferredSize = NSSize(width: panelWidth, height: preferredPanelHeight)
        preferredContentSize = preferredSize
        view.setFrameSize(preferredSize)
        onPreferredContentSizeChange?(preferredSize)

        let root = NSStackView()
        root.orientation = .vertical
        root.alignment = contentAlignment
        root.spacing = stackSpacing
        root.edgeInsets = NSEdgeInsets(top: topInset, left: horizontalInset, bottom: bottomInset, right: horizontalInset)
        root.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(root)

        NSLayoutConstraint.activate([
            root.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            root.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            root.topAnchor.constraint(equalTo: view.topAnchor),
            root.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        ])

        root.addArrangedSubview(makeHeader())

        let listView = isSearchOpen ? makeSearchList() : makeAssetList()
        root.addArrangedSubview(listView)

        if !isSearchOpen {
            root.setCustomSpacing(stackSpacing + footerExtraTopSpacing, after: listView)
            root.addArrangedSubview(makeButtonRow())
        }

        if shouldFocusSearchField {
            shouldFocusSearchField = false
            focusSearchFieldIfNeeded()
        }
    }

    private var assetListVisibleRowCount: Int {
        max(1, min(assets.count, 8))
    }

    private var assetListHeight: CGFloat {
        let rows = assetListVisibleRowCount
        return CGFloat(rows) * assetRowHeight + CGFloat(max(rows - 1, 0)) * listRowGap
    }

    private var currentListHeight: CGFloat {
        if isSearchOpen {
            return searchModeListHeight ?? (assetListHeight + footerHeight + stackSpacing)
        }
        return assetListHeight
    }

    private var preferredPanelHeight: CGFloat {
        let footerBlockHeight = isSearchOpen ? 0 : (stackSpacing + footerExtraTopSpacing + footerHeight)
        return topInset + headerHeight + stackSpacing + currentListHeight + footerBlockHeight + bottomInset
    }

    private var searchResultRowCount: Int {
        if isSearching || searchMessage != nil || searchResults.isEmpty {
            return 1
        }
        return searchResults.count
    }

    private var isRTL: Bool {
        L10n.isRightToLeft
    }

    private var contentAlignment: NSLayoutConstraint.Attribute {
        isRTL ? .centerX : .leading
    }

    private var leadingColumnAlignment: NSLayoutConstraint.Attribute {
        isRTL ? .trailing : .leading
    }

    private var leadingTextAlignment: NSTextAlignment {
        isRTL ? .right : .left
    }

    private var trailingTextAlignment: NSTextAlignment {
        isRTL ? .left : .right
    }

    private func addArrangedSubviews(_ views: [NSView], to stack: NSStackView) {
        for view in isRTL ? views.reversed() : views {
            stack.addArrangedSubview(view)
        }
    }

    private func captureScrollPositions() {
        if let assetScrollView {
            assetScrollPosition = captureScrollPosition(from: assetScrollView)
        }
        if let searchScrollView {
            searchScrollPosition = captureScrollPosition(from: searchScrollView)
        }
    }

    private func captureScrollPosition(from scrollView: NSScrollView) -> ScrollPosition {
        guard let documentView = scrollView.documentView else {
            return ScrollPosition()
        }

        let viewportHeight = scrollView.contentView.bounds.height
        let maxY = max(0, documentView.bounds.height - viewportHeight)
        let currentY = scrollView.contentView.bounds.origin.y
        return ScrollPosition(y: currentY, pinnedToBottom: maxY - currentY <= 2)
    }

    private func restoreScrollPosition(_ position: ScrollPosition, in scrollView: NSScrollView, viewportHeight: CGFloat) {
        applyScrollPosition(position, in: scrollView, viewportHeight: viewportHeight)
        DispatchQueue.main.async { [weak self, weak scrollView] in
            guard let self, let scrollView else { return }
            self.applyScrollPosition(position, in: scrollView, viewportHeight: viewportHeight)
        }
    }

    private func applyScrollPosition(_ position: ScrollPosition, in scrollView: NSScrollView, viewportHeight: CGFloat) {
        guard let documentView = scrollView.documentView else { return }
        scrollView.layoutSubtreeIfNeeded()
        let actualViewportHeight = max(scrollView.contentView.bounds.height, viewportHeight)
        let maxY = max(0, documentView.bounds.height - actualViewportHeight)
        let restoredY = position.pinnedToBottom ? maxY : min(max(position.y, 0), maxY)
        scrollView.contentView.scroll(to: NSPoint(x: 0, y: restoredY))
        scrollView.reflectScrolledClipView(scrollView.contentView)
    }

    private func makeHeader() -> NSView {
        if isSearchOpen {
            return makeSearchHeader()
        }

        let row = NSStackView()
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 8
        row.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        row.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true

        let title = makeLabel("CareAssets", font: appFont(ofSize: 18, weight: .bold), color: .white)
        let brand = NSStackView()
        brand.orientation = .horizontal
        brand.alignment = .centerY
        brand.spacing = 7
        brand.setContentHuggingPriority(.defaultHigh, for: .horizontal)
        if let logo = appLogoImage() {
            let logoView = NSImageView(image: logo)
            logoView.imageScaling = .scaleProportionallyUpOrDown
            logoView.wantsLayer = true
            logoView.layer?.cornerRadius = 5
            logoView.layer?.masksToBounds = true
            logoView.widthAnchor.constraint(equalToConstant: 22).isActive = true
            logoView.heightAnchor.constraint(equalToConstant: 22).isActive = true
            addArrangedSubviews([logoView, title], to: brand)
        } else {
            brand.addArrangedSubview(title)
        }
        let spacer = NSView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let add = NSButton(title: L10n.add, target: self, action: #selector(toggleSearchClicked(_:)))
        add.bezelStyle = .rounded
        add.controlSize = .small
        add.font = appFont(ofSize: 12, weight: .semibold)
        addArrangedSubviews([brand, spacer, add], to: row)
        return row
    }

    private func makeAssetList() -> NSView {
        let rowCount = max(assets.count, 1)
        let documentHeight = CGFloat(rowCount) * assetRowHeight + CGFloat(max(rowCount - 1, 0)) * listRowGap
        let visibleRows = max(1, min(assets.count, 8))
        let listHeight = CGFloat(visibleRows) * assetRowHeight + CGFloat(max(visibleRows - 1, 0)) * listRowGap

        let scroll = NSScrollView()
        scroll.borderType = .noBorder
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = assets.count > 8
        scroll.autohidesScrollers = true
        scroll.verticalScrollElasticity = .allowed
        scroll.widthAnchor.constraint(equalToConstant: scrollWidth).isActive = true
        scroll.heightAnchor.constraint(equalToConstant: listHeight).isActive = true

        let document = FlippedDocumentView(frame: NSRect(x: 0, y: 0, width: scrollWidth, height: documentHeight))
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = contentAlignment
        stack.spacing = listRowGap
        stack.translatesAutoresizingMaskIntoConstraints = false
        document.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: document.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: document.trailingAnchor),
            stack.topAnchor.constraint(equalTo: document.topAnchor),
            stack.bottomAnchor.constraint(equalTo: document.bottomAnchor)
        ])

        if assets.isEmpty {
            let label = makeMutedLabel(L10n.loadingAssets)
            label.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
            label.heightAnchor.constraint(equalToConstant: assetRowHeight).isActive = true
            stack.addArrangedSubview(label)
        } else {
            for asset in assets {
                stack.addArrangedSubview(makeAssetRow(asset))
            }
        }

        scroll.documentView = document
        assetScrollView = scroll
        restoreScrollPosition(assetScrollPosition, in: scroll, viewportHeight: listHeight)
        return scroll
    }

    private func makeAssetRow(_ asset: DisplayAsset) -> NSView {
        let row = AssetReorderRowView(assetID: asset.id)
        row.onMoveAsset = { [weak self] sourceID, targetID, placeAfterTarget in
            self?.onMoveAsset?(sourceID, targetID, placeAfterTarget)
        }
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 8
        row.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        row.heightAnchor.constraint(equalToConstant: assetRowHeight).isActive = true

        let visible = NSButton(title: "", target: self, action: #selector(toggleVisibleClicked(_:)))
        visible.setButtonType(.switch)
        visible.state = asset.visibleInMenuBar ? .on : .off
        visible.identifier = NSUserInterfaceItemIdentifier(asset.id)
        visible.toolTip = L10n.visibleInMenuBar
        visible.widthAnchor.constraint(equalToConstant: 18).isActive = true

        let left = NSStackView()
        left.orientation = .vertical
        left.alignment = leadingColumnAlignment
        left.spacing = 3
        left.addArrangedSubview(makeLabel(displayName(for: asset), font: appFont(ofSize: 14, weight: .bold), color: .white, alignment: leadingTextAlignment))
        left.addArrangedSubview(makeMutedLabel(asset.detailText, alignment: leadingTextAlignment))
        left.widthAnchor.constraint(greaterThanOrEqualToConstant: 88).isActive = true

        let spacer = NSView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let right = NSStackView()
        right.orientation = .vertical
        right.alignment = isRTL ? .leading : .trailing
        right.spacing = 3
        right.addArrangedSubview(makeLabel(asset.priceText, font: appFont(ofSize: 15, weight: .bold), color: valueColor(for: asset), alignment: trailingTextAlignment))

        if let message = asset.errorMessage {
            right.addArrangedSubview(makeAssetDetailLabel(asset, percentText: message, dateText: nil, isError: true))
        } else if let updatedAt = asset.updatedAt {
            right.addArrangedSubview(makeAssetDetailLabel(
                asset,
                percentText: formatPercent(asset.changePercent),
                dateText: dateFormatter.string(from: updatedAt)
            ))
        } else {
            right.addArrangedSubview(makeAssetDetailLabel(asset, percentText: formatPercent(asset.changePercent), dateText: nil))
        }

        let remove = NSButton(title: "-", target: self, action: #selector(removeAssetClicked(_:)))
        remove.bezelStyle = .smallSquare
        remove.controlSize = .small
        remove.font = senFont(ofSize: 11)
        remove.identifier = NSUserInterfaceItemIdentifier(asset.id)
        remove.toolTip = L10n.remove
        remove.widthAnchor.constraint(equalToConstant: 18).isActive = true
        if isRTL {
            addArrangedSubviews([makeRTLScrollerGutter(), visible, left, spacer, right, remove], to: row)
        } else {
            addArrangedSubviews([visible, left, spacer, right, remove], to: row)
        }

        return row
    }

    private func makeSearchHeader() -> NSView {
        let inputRow = NSStackView()
        inputRow.orientation = .horizontal
        inputRow.alignment = .centerY
        inputRow.spacing = 8
        inputRow.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        inputRow.heightAnchor.constraint(equalToConstant: headerHeight).isActive = true

        let field = NSTextField(string: searchQuery)
        field.placeholderString = L10n.searchPlaceholder
        field.delegate = self
        field.font = senFont(ofSize: 13)
        field.setContentHuggingPriority(.defaultLow, for: .horizontal)
        searchField = field

        let button = NSButton(title: isSearching ? L10n.searching : L10n.search, target: self, action: #selector(searchClicked(_:)))
        button.bezelStyle = .rounded
        button.controlSize = .small
        button.font = appFont(ofSize: 12, weight: .semibold)
        button.isEnabled = !isSearching
        button.widthAnchor.constraint(equalToConstant: 58).isActive = true

        let cancel = NSButton(title: L10n.cancel, target: self, action: #selector(cancelSearchClicked(_:)))
        cancel.bezelStyle = .rounded
        cancel.controlSize = .small
        cancel.font = appFont(ofSize: 12, weight: .semibold)
        cancel.widthAnchor.constraint(equalToConstant: 58).isActive = true
        addArrangedSubviews([field, button, cancel], to: inputRow)

        return inputRow
    }

    private func makeSearchList() -> NSView {
        let rowCount = searchResultRowCount
        let rowDocumentHeight = CGFloat(rowCount) * assetRowHeight + CGFloat(max(rowCount - 1, 0)) * listRowGap
        let listHeight = currentListHeight
        let documentHeight = max(rowDocumentHeight, listHeight)

        let scroll = NSScrollView()
        scroll.borderType = .noBorder
        scroll.drawsBackground = false
        scroll.hasVerticalScroller = rowCount > 8
        scroll.autohidesScrollers = true
        scroll.verticalScrollElasticity = .allowed
        scroll.widthAnchor.constraint(equalToConstant: scrollWidth).isActive = true
        scroll.heightAnchor.constraint(equalToConstant: listHeight).isActive = true

        let document = FlippedDocumentView(frame: NSRect(x: 0, y: 0, width: scrollWidth, height: documentHeight))
        let stack = NSStackView()
        stack.orientation = .vertical
        stack.alignment = contentAlignment
        stack.spacing = listRowGap
        stack.translatesAutoresizingMaskIntoConstraints = false
        document.addSubview(stack)

        NSLayoutConstraint.activate([
            stack.leadingAnchor.constraint(equalTo: document.leadingAnchor),
            stack.trailingAnchor.constraint(equalTo: document.trailingAnchor),
            stack.topAnchor.constraint(equalTo: document.topAnchor),
            stack.bottomAnchor.constraint(equalTo: document.bottomAnchor)
        ])

        if isSearching {
            stack.addArrangedSubview(makeSearchMessageRow(L10n.searchInProgress))
        } else if let searchMessage {
            stack.addArrangedSubview(makeSearchMessageRow(searchMessage))
        } else if searchResults.isEmpty {
            stack.addArrangedSubview(makeSearchMessageRow(L10n.emptySearchPrompt))
        } else {
            for result in searchResults {
                stack.addArrangedSubview(makeSearchResultRow(result))
            }
        }

        scroll.documentView = document
        searchScrollView = scroll
        restoreScrollPosition(searchScrollPosition, in: scroll, viewportHeight: listHeight)
        return scroll
    }

    private func makeSearchMessageRow(_ text: String) -> NSView {
        let container = NSView()
        container.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        container.heightAnchor.constraint(equalToConstant: currentListHeight).isActive = true

        let label = makeLabel(text, font: appFont(ofSize: 11, weight: .medium), color: NSColor.white.withAlphaComponent(0.50), alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)

        NSLayoutConstraint.activate([
            label.centerXAnchor.constraint(equalTo: container.centerXAnchor),
            label.centerYAnchor.constraint(equalTo: container.centerYAnchor),
            label.leadingAnchor.constraint(greaterThanOrEqualTo: container.leadingAnchor, constant: 16),
            label.trailingAnchor.constraint(lessThanOrEqualTo: container.trailingAnchor, constant: -16)
        ])

        return container
    }

    private func makeSearchResultRow(_ result: AssetSearchResult) -> NSView {
        let row = ClickableSearchResultRowView()
        row.onClick = { [weak self] in
            self?.toggleSearchResult(result)
        }
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 8
        row.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true
        row.heightAnchor.constraint(equalToConstant: assetRowHeight).isActive = true

        let checkSpace = NSView()
        checkSpace.widthAnchor.constraint(equalToConstant: 18).isActive = true

        let left = NSStackView()
        left.orientation = .vertical
        left.alignment = leadingColumnAlignment
        left.spacing = 3
        left.addArrangedSubview(makeLabel(result.name, font: appFont(ofSize: 14, weight: .bold), color: .white, alignment: leadingTextAlignment))
        left.addArrangedSubview(makeMutedLabel(result.symbol, alignment: leadingTextAlignment))
        left.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let spacer = NSView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let detail = makeLabel(result.source, font: appFont(ofSize: 11, weight: .medium), color: NSColor.white.withAlphaComponent(0.50), alignment: trailingTextAlignment)
        detail.widthAnchor.constraint(equalToConstant: 82).isActive = true

        let exists = assets.contains { asset in
            asset.type == result.type && normalizedAssetSymbol(asset.symbol) == normalizedAssetSymbol(result.symbol)
        }
        let add = SearchResultActionButton(title: "", target: self, action: #selector(addSearchResultClicked(_:)))
        add.isTracked = exists
        add.isBordered = false
        add.identifier = NSUserInterfaceItemIdentifier(result.id)
        add.toolTip = exists ? L10n.remove : L10n.add
        add.widthAnchor.constraint(equalToConstant: 18).isActive = true
        add.heightAnchor.constraint(equalToConstant: 18).isActive = true
        addArrangedSubviews([checkSpace, left, spacer, detail, add], to: row)

        return row
    }

    private func makeSettingsMenu() -> NSMenu {
        let menu = NSMenu()
        menu.appearance = NSAppearance(named: .darkAqua)
        menu.addItem(makeParentMenuItem(title: L10n.colorSetting, submenu: makeColorModeMenu()))
        menu.addItem(makeParentMenuItem(title: L10n.statusBarBackgroundSetting, submenu: makeStatusBarBackgroundMenu()))
        menu.addItem(makeParentMenuItem(title: L10n.itemSpacingSetting, submenu: makeItemSpacingMenu()))
        menu.addItem(makeParentMenuItem(title: L10n.priceDisplayModeSetting, submenu: makePriceDisplayModeMenu()))
        menu.addItem(makeParentMenuItem(title: L10n.text("分时图", "Time Series Chart", zhHant: "分時圖", ja: "時系列チャート", ar: "مخطط السلاسل الزمنية", de: "Zeitreihenchart", fr: "Graphique de séries chronologiques", ko: "시계열 차트", ptPT: "Gráfico de séries temporais", es: "Gráfico de series temporales"), submenu: makeTimeSeriesDisplayModeMenu()))
        menu.addItem(makeParentMenuItem(title: L10n.languageSetting, submenu: makeLanguageMenu()))
        return menu
    }

    private func makeParentMenuItem(title: String, submenu: NSMenu) -> NSMenuItem {
        let item = NSMenuItem(title: title, action: nil, keyEquivalent: "")
        item.submenu = submenu
        return item
    }

    private func makeColorModeMenu() -> NSMenu {
        let menu = NSMenu()
        menu.appearance = NSAppearance(named: .darkAqua)
        for mode in PriceColorMode.allCases {
            let item = NSMenuItem(title: mode.title, action: #selector(colorModeMenuItemClicked(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = mode.rawValue
            item.state = mode == colorMode ? .on : .off
            menu.addItem(item)
        }
        return menu
    }

    private func makeStatusBarBackgroundMenu() -> NSMenu {
        let menu = NSMenu()
        menu.appearance = NSAppearance(named: .darkAqua)
        for mode in StatusBarBackgroundMode.allCases {
            let item = NSMenuItem(title: mode.title, action: #selector(statusBarBackgroundMenuItemClicked(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = mode.rawValue
            item.state = mode == statusBarBackgroundMode ? .on : .off
            menu.addItem(item)
        }
        return menu
    }

    private func makeItemSpacingMenu() -> NSMenu {
        let menu = NSMenu()
        menu.appearance = NSAppearance(named: .darkAqua)
        let spacingOptions = [36, 44, 48, 56, 64, 72, 80, 88, 96]
        for spacing in spacingOptions {
            let item = NSMenuItem(title: "\(spacing)px", action: #selector(itemSpacingMenuItemClicked(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = spacing
            item.state = spacing == itemSpacing ? .on : .off
            menu.addItem(item)
        }
        return menu
    }

    private func makePriceDisplayModeMenu() -> NSMenu {
        let menu = NSMenu()
        menu.appearance = NSAppearance(named: .darkAqua)
        for mode in PriceDisplayMode.allCases {
            let item = NSMenuItem(title: mode.title, action: nil, keyEquivalent: "")
            item.state = mode == priceDisplayMode ? .on : .off
            item.target = self
            item.action = #selector(handlePriceDisplayModeSelection(_:))
            item.representedObject = mode
            menu.addItem(item)
        }
        return menu
    }

    @objc private func handlePriceDisplayModeSelection(_ sender: NSMenuItem) {
        guard let mode = sender.representedObject as? PriceDisplayMode else { return }
        priceDisplayMode = mode
        onPriceDisplayModeChange?(mode)
        render()
    }

    private func makeTimeSeriesDisplayModeMenu() -> NSMenu {
        let menu = NSMenu()
        menu.appearance = NSAppearance(named: .darkAqua)
        for mode in TimeSeriesDisplayMode.allCases {
            let item = NSMenuItem(title: mode.title, action: nil, keyEquivalent: "")
            item.state = mode == timeSeriesDisplayMode ? .on : .off
            item.target = self
            item.action = #selector(handleTimeSeriesDisplayModeSelection(_:))
            item.representedObject = mode
            menu.addItem(item)
        }
        return menu
    }

    @objc private func handleTimeSeriesDisplayModeSelection(_ sender: NSMenuItem) {
        guard let mode = sender.representedObject as? TimeSeriesDisplayMode else { return }
        timeSeriesDisplayMode = mode
        onTimeSeriesDisplayModeChange?(mode)
        render()
    }

    private func makeLanguageMenu() -> NSMenu {
        let menu = NSMenu()
        menu.appearance = NSAppearance(named: .darkAqua)
        for language in AppLanguage.allCases {
            let item = NSMenuItem(title: language.title, action: #selector(languageMenuItemClicked(_:)), keyEquivalent: "")
            item.target = self
            item.representedObject = language.rawValue
            item.state = language == self.language ? .on : .off
            menu.addItem(item)
        }
        return menu
    }

    private func makeButtonRow() -> NSView {
        let row = NSStackView()
        row.orientation = .horizontal
        row.alignment = .centerY
        row.spacing = 8
        row.widthAnchor.constraint(equalToConstant: contentWidth).isActive = true

        let settings = NSButton(title: L10n.settings, target: self, action: #selector(settingsClicked(_:)))
        settings.bezelStyle = .rounded
        settings.controlSize = .small
        settings.font = appFont(ofSize: 12, weight: .semibold)

        let state = L10n.refreshState(isRefreshing: isRefreshing, countdown: countdown)
        let refresh = makeLabel(state, font: appFont(ofSize: 11, weight: .semibold), color: NSColor.white.withAlphaComponent(0.56), alignment: leadingTextAlignment)
        refreshStateLabel = refresh

        let spacer = NSView()
        spacer.setContentHuggingPriority(.defaultLow, for: .horizontal)

        let quit = NSButton(title: L10n.quit, target: self, action: #selector(quitClicked))
        quit.bezelStyle = .rounded
        quit.controlSize = .small
        quit.font = appFont(ofSize: 12, weight: .semibold)
        addArrangedSubviews([settings, refresh, spacer, quit], to: row)

        return row
    }

    @objc private func toggleSearchClicked(_ sender: NSButton) {
        openSearchMode()
        render()
    }

    @objc private func cancelSearchClicked(_ sender: NSButton) {
        closeSearchMode()
        render()
    }

    @objc private func settingsClicked(_ sender: NSButton) {
        let menu = makeSettingsMenu()
        if let event = NSApp.currentEvent {
            NSMenu.popUpContextMenu(menu, with: event, for: sender)
        } else {
            menu.popUp(positioning: nil, at: NSPoint(x: 0, y: sender.bounds.height + 4), in: sender)
        }
    }

    @objc private func colorModeMenuItemClicked(_ sender: NSMenuItem) {
        guard let rawValue = sender.representedObject as? String,
              let mode = PriceColorMode(rawValue: rawValue) else { return }
        colorMode = mode
        onColorModeChange?(mode)
        render()
    }

    @objc private func statusBarBackgroundMenuItemClicked(_ sender: NSMenuItem) {
        guard let rawValue = sender.representedObject as? String,
              let mode = StatusBarBackgroundMode(rawValue: rawValue) else { return }
        statusBarBackgroundMode = mode
        onStatusBarBackgroundModeChange?(mode)
        render()
    }

    @objc private func languageMenuItemClicked(_ sender: NSMenuItem) {
        guard let rawValue = sender.representedObject as? String,
              let language = AppLanguage(rawValue: rawValue) else { return }
        self.language = language
        L10n.appLanguage = language
        onLanguageChange?(language)
        render()
    }

    @objc private func itemSpacingMenuItemClicked(_ sender: NSMenuItem) {
        guard let spacing = sender.representedObject as? Int else { return }
        itemSpacing = spacing
        onItemSpacingChange?(spacing)
        render()
    }

    @objc private func searchClicked(_ sender: Any) {
        submitSearch()
    }

    private func submitSearch() {
        if let searchField {
            searchQuery = searchField.stringValue
        }
        let query = searchQuery.trimmingCharacters(in: .whitespacesAndNewlines)
        guard !query.isEmpty else {
            searchResults = []
            searchMessage = L10n.emptySearchPrompt
            render()
            return
        }
        guard !isSearching else { return }

        isSearching = true
        searchResults = []
        searchMessage = nil
        render()
        onSearchStocks?(query)
    }

    @objc private func addSearchResultClicked(_ sender: NSButton) {
        guard let id = sender.identifier?.rawValue,
              let result = searchResults.first(where: { $0.id == id }) else { return }
        toggleSearchResult(result)
    }

    private func toggleSearchResult(_ result: AssetSearchResult) {
        let wasTracked = isSearchResultTracked(result)
        if wasTracked {
            onRemoveAsset?(result.id)
        } else {
            onAddStock?(result)
        }

        render()
        showToast(wasTracked ? L10n.assetRemovedToast(result.name) : L10n.assetAddedToast(result.name))
    }

    @objc private func toggleVisibleClicked(_ sender: NSButton) {
        guard let id = sender.identifier?.rawValue else { return }
        onToggleVisible?(id, sender.state == .on)
    }

    @objc private func removeAssetClicked(_ sender: NSButton) {
        guard let id = sender.identifier?.rawValue else { return }
        onRemoveAsset?(id)
    }

    @objc private func quitClicked() {
        onQuit?()
    }

    func controlTextDidChange(_ notification: Notification) {
        guard let field = notification.object as? NSTextField else { return }
        searchQuery = field.stringValue
    }

    func control(_ control: NSControl, textView: NSTextView, doCommandBy commandSelector: Selector) -> Bool {
        guard control === searchField else { return false }
        if commandSelector == #selector(NSResponder.insertNewline(_:)) {
            submitSearch()
            return true
        }
        return false
    }

    func focusSearchFieldIfNeeded() {
        guard isSearchOpen, let searchField else { return }
        DispatchQueue.main.async { [weak self, weak searchField] in
            guard let self, self.isSearchOpen, let searchField else { return }
            NSApp.activate(ignoringOtherApps: true)
            self.view.window?.makeKey()
            self.view.window?.makeFirstResponder(searchField)
        }
    }

    private func openSearchMode() {
        isSearchOpen = true
        isSearching = false
        searchModeListHeight = assetListHeight + footerHeight + stackSpacing
        searchQuery = ""
        searchResults = []
        searchMessage = L10n.emptySearchPrompt
        shouldFocusSearchField = true
    }

    private func closeSearchMode(clearSearch: Bool = false) {
        isSearchOpen = false
        isSearching = false
        shouldFocusSearchField = false
        searchModeListHeight = nil
        if clearSearch {
            searchQuery = ""
            searchResults = []
            searchMessage = nil
        }
    }

    private func makeMutedLabel(_ text: String, alignment: NSTextAlignment = .left) -> NSTextField {
        makeLabel(text, font: appFont(ofSize: 11, weight: .medium), color: NSColor.white.withAlphaComponent(0.50), alignment: alignment)
    }

    private func showToast(_ message: String) {
        toastWorkItem?.cancel()
        toastView?.removeFromSuperview()

        let container = NSView()
        container.wantsLayer = true
        container.layer?.backgroundColor = NSColor.black.withAlphaComponent(0.72).cgColor
        container.layer?.cornerRadius = 7
        container.translatesAutoresizingMaskIntoConstraints = false

        let label = makeLabel(message, font: appFont(ofSize: 11, weight: .semibold), color: .white, alignment: .center)
        label.translatesAutoresizingMaskIntoConstraints = false
        container.addSubview(label)
        view.addSubview(container)

        NSLayoutConstraint.activate([
            label.leadingAnchor.constraint(equalTo: container.leadingAnchor, constant: 12),
            label.trailingAnchor.constraint(equalTo: container.trailingAnchor, constant: -12),
            label.topAnchor.constraint(equalTo: container.topAnchor, constant: 6),
            label.bottomAnchor.constraint(equalTo: container.bottomAnchor, constant: -6),
            container.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            container.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -bottomInset),
            container.widthAnchor.constraint(lessThanOrEqualToConstant: contentWidth - 48)
        ])

        toastView = container
        let workItem = DispatchWorkItem { [weak self, weak container] in
            container?.removeFromSuperview()
            if self?.toastView === container {
                self?.toastView = nil
            }
        }
        toastWorkItem = workItem
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6, execute: workItem)
    }

    private func makeRTLScrollerGutter() -> NSView {
        let view = NSView()
        view.widthAnchor.constraint(equalToConstant: rtlScrollerGutterWidth).isActive = true
        return view
    }

    private func updateRefreshStateLabel() {
        guard let label = refreshStateLabel else { return }
        let font = appFont(ofSize: 11, weight: .semibold)
        let color = NSColor.white.withAlphaComponent(0.56)
        let style = NSMutableParagraphStyle()
        style.alignment = leadingTextAlignment
        label.alignment = leadingTextAlignment
        label.attributedStringValue = mixedAttributedString(
            L10n.refreshState(isRefreshing: isRefreshing, countdown: countdown),
            baseFont: font,
            asciiFont: senFont(ofSize: font.pointSize),
            color: color,
            paragraphStyle: style
        )
    }

    private func displayName(for asset: DisplayAsset) -> String {
        if asset.type == .gold, asset.symbol == "JD_GOLD" {
            return L10n.gold
        }
        return asset.name
    }

    private func isSearchResultTracked(_ result: AssetSearchResult) -> Bool {
        assets.contains { asset in
            asset.type == result.type && normalizedAssetSymbol(asset.symbol) == normalizedAssetSymbol(result.symbol)
        }
    }

    private func normalizedAssetSymbol(_ symbol: String) -> String {
        symbol.uppercased().replacingOccurrences(of: "-", with: "")
    }

    private func makeAssetDetailLabel(_ asset: DisplayAsset, percentText: String, dateText: String?, isError: Bool = false) -> NSTextField {
        let font = appFont(ofSize: 11, weight: .medium)
        let mutedColor = NSColor.white.withAlphaComponent(0.58)
        let label = NSTextField(labelWithString: "")
        label.font = font
        label.alignment = trailingTextAlignment
        label.lineBreakMode = .byTruncatingTail
        label.maximumNumberOfLines = 1

        let style = NSMutableParagraphStyle()
        style.alignment = trailingTextAlignment

        if isError {
            label.attributedStringValue = mixedAttributedString(
                percentText,
                baseFont: font,
                asciiFont: senFont(ofSize: font.pointSize),
                color: mutedColor,
                paragraphStyle: style
            )
            return label
        }

        let text = NSMutableAttributedString()
        text.append(mixedAttributedString(
            percentText,
            baseFont: font,
            asciiFont: senFont(ofSize: font.pointSize),
            color: valueColor(for: asset),
            paragraphStyle: nil
        ))

        if let dateText {
            text.append(mixedAttributedString(
                " · \(dateText)",
                baseFont: font,
                asciiFont: senFont(ofSize: font.pointSize),
                color: mutedColor,
                paragraphStyle: nil
            ))
        }

        text.addAttribute(.paragraphStyle, value: style, range: NSRange(location: 0, length: text.length))
        label.attributedStringValue = text
        return label
    }

    private func makeLabel(_ text: String, font: NSFont, color: NSColor, alignment: NSTextAlignment = .left) -> NSTextField {
        let label = NSTextField(labelWithString: text)
        label.font = font
        label.textColor = color
        label.alignment = alignment
        label.lineBreakMode = .byTruncatingTail
        label.maximumNumberOfLines = 1
        let style = NSMutableParagraphStyle()
        style.alignment = alignment
        label.attributedStringValue = mixedAttributedString(
            text,
            baseFont: font,
            asciiFont: senFont(ofSize: font.pointSize),
            color: color,
            paragraphStyle: style
        )
        return label
    }

    private func valueColor(for asset: DisplayAsset) -> NSColor {
        priceColor(for: asset, mode: colorMode, whiteAlpha: 1, errorAlpha: 0.58)
    }
}

final class AppDelegate: NSObject, NSApplicationDelegate, NSPopoverDelegate {
    private var statusItem: NSStatusItem?
    private let tickerView = StatusTickerView()
    private let popover = NSPopover()
    private let panelViewController = AssetPanelViewController()
    private let service = AssetService()

    private var config = ConfigStore.loadOrCreate()
    private var assets: [DisplayAsset] = []
    private var timer: Timer?
    private var secondsUntilRefresh = 0
    private var isRefreshing = false
    private var searchRequestID = 0
    private var loadingFrame = 0
    private var localMouseMonitor: Any?
    private var globalMouseMonitor: Any?
    private var resignActiveObserver: NSObjectProtocol?

    func applicationDidFinishLaunching(_ notification: Notification) {
        FontRegistrar.registerBundledFonts()
        L10n.appLanguage = config.language
        statusItem = NSStatusBar.system.statusItem(withLength: NSStatusItem.variableLength)
        assets = config.assets.map(DisplayAsset.loading)
        secondsUntilRefresh = max(10, config.refreshIntervalSeconds)

        setupStatusItem()
        setupPopover()
        updateViews()
        refresh()

        timer = Timer.scheduledTimer(timeInterval: 1.0, target: self, selector: #selector(tick), userInfo: nil, repeats: true)
    }

    private func setupStatusItem() {
        tickerView.cellWidth = CGFloat(config.itemSpacing)
        tickerView.priceDisplayMode = config.priceDisplayMode
        tickerView.timeSeriesDisplayMode = config.timeSeriesDisplayMode
        tickerView.items = visibleMenuAssets()
        tickerView.onClick = { [weak self] in
            self?.togglePopover()
        }

        if let button = statusItem?.button {
            button.title = ""
            button.image = nil
            button.toolTip = L10n.appTooltip
            button.target = self
            button.action = #selector(statusButtonClicked)

            if tickerView.superview == nil {
                button.addSubview(tickerView)
                tickerView.translatesAutoresizingMaskIntoConstraints = false
                NSLayoutConstraint.activate([
                    tickerView.leadingAnchor.constraint(equalTo: button.leadingAnchor),
                    tickerView.trailingAnchor.constraint(equalTo: button.trailingAnchor),
                    tickerView.topAnchor.constraint(equalTo: button.topAnchor),
                    tickerView.bottomAnchor.constraint(equalTo: button.bottomAnchor)
                ])
            }
        }
    }

    private func updateStatusItem() {
        statusItem?.length = tickerView.preferredWidth
        if let button = statusItem?.button {
            button.needsDisplay = true
        }
    }

    private func setupPopover() {
        popover.behavior = .transient
        popover.animates = true
        popover.appearance = NSAppearance(named: .darkAqua)
        popover.contentViewController = panelViewController
        popover.delegate = self

        panelViewController.onSearchStocks = { [weak self] query in
            self?.searchAssets(query)
        }
        panelViewController.onAddStock = { [weak self] result in
            self?.addAsset(result)
        }
        panelViewController.onToggleVisible = { [weak self] id, visible in
            self?.setAsset(id: id, visibleInMenuBar: visible)
        }
        panelViewController.onRemoveAsset = { [weak self] id in
            self?.removeAsset(id: id)
        }
        panelViewController.onMoveAsset = { [weak self] sourceID, targetID, placeAfterTarget in
            self?.moveAsset(id: sourceID, to: targetID, placeAfterTarget: placeAfterTarget)
        }
        panelViewController.onColorModeChange = { [weak self] mode in
            self?.setPriceColorMode(mode)
        }
        panelViewController.onStatusBarBackgroundModeChange = { [weak self] mode in
            self?.setStatusBarBackgroundMode(mode)
        }
        panelViewController.onLanguageChange = { [weak self] language in
            self?.setLanguage(language)
        }
        panelViewController.onItemSpacingChange = { [weak self] spacing in
            self?.setItemSpacing(spacing)
        }
        panelViewController.onPriceDisplayModeChange = { [weak self] mode in
            self?.setPriceDisplayMode(mode)
        }
        panelViewController.onTimeSeriesDisplayModeChange = { [weak self] mode in
            self?.setTimeSeriesDisplayMode(mode)
        }
        panelViewController.onPreferredContentSizeChange = { [weak self] size in
            self?.popover.contentSize = size
        }
        panelViewController.onQuit = {
            NSApp.terminate(nil)
        }
    }

    func popoverDidClose(_ notification: Notification) {
        stopPopoverDismissMonitoring()
    }

    @objc private func statusButtonClicked() {
        togglePopover()
    }

    private func togglePopover() {
        guard let button = statusItem?.button else { return }

        if popover.isShown {
            closePopover()
        } else {
            panelViewController.update(
                assets: assets,
                countdown: secondsUntilRefresh,
                isRefreshing: isRefreshing,
                colorMode: config.priceColorMode,
                statusBarBackgroundMode: config.statusBarBackgroundMode,
                language: config.language,
                priceDisplayMode: config.priceDisplayMode,
                itemSpacing: config.itemSpacing,
                timeSeriesDisplayMode: config.timeSeriesDisplayMode
            )
            popover.show(relativeTo: button.bounds, of: button, preferredEdge: .minY)
            startPopoverDismissMonitoring()
            panelViewController.focusSearchFieldIfNeeded()
        }
    }

    private func closePopover() {
        guard popover.isShown else {
            stopPopoverDismissMonitoring()
            return
        }
        popover.performClose(nil)
    }

    private func startPopoverDismissMonitoring() {
        stopPopoverDismissMonitoring()

        let mouseEvents: NSEvent.EventTypeMask = [.leftMouseDown, .rightMouseDown, .otherMouseDown]
        localMouseMonitor = NSEvent.addLocalMonitorForEvents(matching: mouseEvents) { [weak self] event in
            self?.closePopoverIfEventIsOutside(event)
            return event
        }
        globalMouseMonitor = NSEvent.addGlobalMonitorForEvents(matching: mouseEvents) { [weak self] _ in
            DispatchQueue.main.async {
                self?.closePopover()
            }
        }
        resignActiveObserver = NotificationCenter.default.addObserver(
            forName: NSApplication.didResignActiveNotification,
            object: NSApp,
            queue: .main
        ) { [weak self] _ in
            self?.closePopover()
        }
    }

    private func stopPopoverDismissMonitoring() {
        if let localMouseMonitor {
            NSEvent.removeMonitor(localMouseMonitor)
            self.localMouseMonitor = nil
        }
        if let globalMouseMonitor {
            NSEvent.removeMonitor(globalMouseMonitor)
            self.globalMouseMonitor = nil
        }
        if let resignActiveObserver {
            NotificationCenter.default.removeObserver(resignActiveObserver)
            self.resignActiveObserver = nil
        }
    }

    private func closePopoverIfEventIsOutside(_ event: NSEvent) {
        guard popover.isShown else { return }
        if event.window?.level == .popUpMenu {
            return
        }
        if let eventWindow = event.window, eventWindow == panelViewController.view.window {
            return
        }
        if isEventInStatusButton(event) {
            return
        }
        closePopover()
    }

    private func isEventInStatusButton(_ event: NSEvent) -> Bool {
        guard let button = statusItem?.button,
              let eventWindow = event.window,
              eventWindow == button.window else {
            return false
        }
        let location = button.convert(event.locationInWindow, from: nil)
        return button.bounds.contains(location)
    }

    @objc private func tick() {
        loadingFrame = (loadingFrame + 1) % 3
        tickerView.loadingFrame = loadingFrame

        guard !isRefreshing else {
            panelViewController.updateRefreshState(countdown: secondsUntilRefresh, isRefreshing: true)
            return
        }

        secondsUntilRefresh -= 1
        if secondsUntilRefresh <= 0 {
            refresh()
        } else {
            panelViewController.updateRefreshState(countdown: secondsUntilRefresh, isRefreshing: false)
        }
    }

    private func refresh() {
        guard !isRefreshing else { return }

        config = ConfigStore.loadOrCreate()
        L10n.appLanguage = config.language
        secondsUntilRefresh = max(10, config.refreshIntervalSeconds)
        isRefreshing = true
        updateViews()

        let currentConfig = config
        Task {
            let fetchedAssets = await service.fetchAssets(config: currentConfig)
            await MainActor.run {
                let fetchedByID = Dictionary(uniqueKeysWithValues: fetchedAssets.map { ($0.id, $0) })
                self.assets = self.config.assets.map { asset in
                    let id = self.key(for: asset)
                    return fetchedByID[id] ?? self.assets.first(where: { $0.id == id }) ?? DisplayAsset.loading(from: asset)
                }
                self.isRefreshing = false
                self.secondsUntilRefresh = max(10, self.config.refreshIntervalSeconds)
                self.updateViews()
            }
        }
    }

    private func updateViews() {
        let menuAssets = visibleMenuAssets()
        tickerView.colorMode = config.priceColorMode
        tickerView.backgroundMode = config.statusBarBackgroundMode
        tickerView.priceDisplayMode = config.priceDisplayMode
        tickerView.timeSeriesDisplayMode = config.timeSeriesDisplayMode
        tickerView.loadingFrame = loadingFrame
        tickerView.items = menuAssets
        statusItem?.length = tickerView.preferredWidth
        if let button = statusItem?.button {
            button.title = ""
            button.image = nil
            button.toolTip = L10n.appTooltip
        }
        panelViewController.update(
            assets: assets,
            countdown: secondsUntilRefresh,
            isRefreshing: isRefreshing,
            colorMode: config.priceColorMode,
            statusBarBackgroundMode: config.statusBarBackgroundMode,
            language: config.language,
            priceDisplayMode: config.priceDisplayMode,
            itemSpacing: config.itemSpacing,
            timeSeriesDisplayMode: config.timeSeriesDisplayMode
        )
    }

    private func visibleMenuAssets() -> [DisplayAsset] {
        assets.filter(\.visibleInMenuBar)
    }

    private func searchAssets(_ query: String) {
        searchRequestID += 1
        let requestID = searchRequestID

        Task {
            do {
                let results = try await service.searchAssets(query: query)
                await MainActor.run {
                    guard requestID == self.searchRequestID else { return }
                    let message = results.isEmpty ? L10n.noSearchResults : nil
                    self.panelViewController.updateSearch(results: results, isSearching: false, message: message)
                }
            } catch {
                await MainActor.run {
                    guard requestID == self.searchRequestID else { return }
                    self.panelViewController.updateSearch(
                        results: [],
                        isSearching: false,
                        message: L10n.searchFailed(error.localizedDescription)
                    )
                }
            }
        }
    }

    private func addAsset(_ result: AssetSearchResult) {
        let asset = result.trackedAsset
        let id = key(for: asset)
        guard !config.assets.contains(where: { key(for: $0) == id }) else {
            updateViews()
            return
        }

        config.assets.append(asset)
        ConfigStore.write(config)
        assets.append(DisplayAsset.loading(from: asset))
        updateViews()
        refresh()
    }

    private func setAsset(id: String, visibleInMenuBar: Bool) {
        guard let configIndex = config.assets.firstIndex(where: { key(for: $0) == id }) else { return }
        config.assets[configIndex].visibleInMenuBar = visibleInMenuBar
        ConfigStore.write(config)

        if let assetIndex = assets.firstIndex(where: { $0.id == id }) {
            assets[assetIndex].visibleInMenuBar = visibleInMenuBar
        }

        updateViews()
    }

    private func removeAsset(id: String) {
        config.assets.removeAll { key(for: $0) == id }
        assets.removeAll { $0.id == id }
        ConfigStore.write(config)
        updateViews()
    }

    private func moveAsset(id sourceID: String, to targetID: String, placeAfterTarget: Bool) {
        guard sourceID != targetID,
              let sourceIndex = config.assets.firstIndex(where: { key(for: $0) == sourceID }) else {
            return
        }

        let movedAsset = config.assets.remove(at: sourceIndex)
        guard let targetIndexAfterRemoval = config.assets.firstIndex(where: { key(for: $0) == targetID }) else {
            config.assets.insert(movedAsset, at: sourceIndex)
            return
        }

        let insertionIndex = placeAfterTarget ? targetIndexAfterRemoval + 1 : targetIndexAfterRemoval
        config.assets.insert(movedAsset, at: min(insertionIndex, config.assets.count))
        ConfigStore.write(config)

        let displayAssetsByID = Dictionary(uniqueKeysWithValues: assets.map { ($0.id, $0) })
        assets = config.assets.map { asset in
            displayAssetsByID[key(for: asset)] ?? DisplayAsset.loading(from: asset)
        }
        updateViews()
    }

    private func setPriceColorMode(_ mode: PriceColorMode) {
        config.priceColorMode = mode
        ConfigStore.write(config)
        updateViews()
    }

    private func setStatusBarBackgroundMode(_ mode: StatusBarBackgroundMode) {
        config.statusBarBackgroundMode = mode
        ConfigStore.write(config)
        updateViews()
    }

    private func setLanguage(_ language: AppLanguage) {
        config.language = language
        L10n.appLanguage = language
        ConfigStore.write(config)
        updateViews()
        refresh()
    }

    private func setItemSpacing(_ spacing: Int) {
        config.itemSpacing = spacing
        ConfigStore.write(config)
        tickerView.cellWidth = CGFloat(spacing)
        updateStatusItem()
    }

    private func setPriceDisplayMode(_ mode: PriceDisplayMode) {
        config.priceDisplayMode = mode
        ConfigStore.write(config)
        tickerView.priceDisplayMode = mode
        updateViews()
    }

    private func setTimeSeriesDisplayMode(_ mode: TimeSeriesDisplayMode) {
        config.timeSeriesDisplayMode = mode
        ConfigStore.write(config)
        updateViews()
    }

    private func key(for asset: TrackedAsset) -> String {
        "\(asset.type.rawValue)-\(asset.symbol)"
    }

    private func makeStatusTitle(from assets: [DisplayAsset]) -> String {
        if assets.isEmpty {
            return "CA --"
        }

        let segments = assets.map { asset in
            "\(shortName(for: asset)) \(asset.menuPriceText.replacingOccurrences(of: "¥", with: ""))"
        }
        return "CA " + segments.joined(separator: "  ")
    }

    private func shortName(for asset: DisplayAsset) -> String {
        switch asset.type {
        case .gold:
            return L10n.gold
        case .crypto:
            return asset.name
        case .stock:
            return asset.name
        }
    }
}

// MARK: - Formatting

private func parsePercent(_ string: String?) -> Double? {
    guard let string else { return nil }
    return Double(
        string
            .trimmingCharacters(in: .whitespacesAndNewlines)
            .replacingOccurrences(of: "%", with: "")
    )
}

private func meaningfulPercent(_ string: String?) -> Double? {
    parsePercent(string).flatMap { abs($0) > 0.0001 ? $0 : nil }
}

private func positiveDouble(_ string: String?) -> Double? {
    guard let value = string.flatMap(Double.init), value > 0 else { return nil }
    return value
}

private func meaningfulChange(_ string: String?) -> Double? {
    guard let value = string.flatMap(Double.init), abs(value) > 0.0001 else { return nil }
    return value
}

private func parseMillisecondsDate(_ string: String?) -> Date? {
    guard let string, let milliseconds = Double(string) else { return nil }
    return Date(timeIntervalSince1970: milliseconds / 1000.0)
}

private func parseLocalDateTime(_ string: String?) -> Date? {
    guard let string, !string.isEmpty else { return nil }
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.timeZone = TimeZone(identifier: "Asia/Shanghai")
    formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
    return formatter.date(from: string)
}

private func parseISO8601Date(_ string: String?) -> Date? {
    guard let string else { return nil }

    let fractionalFormatter = ISO8601DateFormatter()
    fractionalFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
    if let date = fractionalFormatter.date(from: string) {
        return date
    }

    return ISO8601DateFormatter().date(from: string)
}

private func latestDate(_ lhs: Date?, _ rhs: Date?) -> Date? {
    switch (lhs, rhs) {
    case let (left?, right?):
        return max(left, right)
    case let (left?, nil):
        return left
    case let (nil, right?):
        return right
    case (nil, nil):
        return nil
    }
}

private func formatNumber(_ value: Double, minFraction: Int, maxFraction: Int, usesGroupingSeparator: Bool = true) -> String {
    let formatter = NumberFormatter()
    formatter.numberStyle = .decimal
    formatter.usesGroupingSeparator = usesGroupingSeparator
    formatter.minimumFractionDigits = minFraction
    formatter.maximumFractionDigits = maxFraction
    return formatter.string(from: NSNumber(value: value)) ?? String(format: "%.\(maxFraction)f", value)
}

private func formatStatusNumber(_ value: Double, minFraction: Int, maxFraction: Int) -> String {
    formatNumber(value, minFraction: minFraction, maxFraction: maxFraction, usesGroupingSeparator: false)
}

private func formatCompact(_ value: Double) -> String {
    let absolute = abs(value)
    if absolute >= 1_000_000 {
        return "\(formatNumber(value / 1_000_000, minFraction: 1, maxFraction: 1))M"
    }
    if absolute >= 10_000 {
        return "\(formatNumber(value / 1_000, minFraction: 1, maxFraction: 1))K"
    }
    if absolute >= 1_000 {
        return formatNumber(value, minFraction: 0, maxFraction: 0)
    }
    if absolute >= 100 {
        return formatNumber(value, minFraction: 0, maxFraction: 1)
    }
    return formatNumber(value, minFraction: 2, maxFraction: 2)
}

private func formatCNY(_ value: Double, compact: Bool) -> String {
    formatCurrency(value, currencyCode: "CNY", compact: compact)
}

private func formatCurrency(_ value: Double, currencyCode: String, compact: Bool) -> String {
    let symbol = currencySymbol(for: currencyCode)
    if compact {
        return "\(symbol)\(formatCompact(value))"
    }
    let number = formatNumber(value, minFraction: 2, maxFraction: 2)
    if symbol.isEmpty {
        return "\(number) \(currencyCode.uppercased())"
    }
    return "\(symbol)\(number)"
}

private func currencySymbol(for currencyCode: String) -> String {
    switch currencyCode.uppercased() {
    case "CNY", "CNH", "JPY":
        return "¥"
    case "HKD":
        return "HK$"
    case "USD":
        return "$"
    case "EUR":
        return "€"
    case "GBP":
        return "£"
    default:
        return ""
    }
}

private func formatChange(amount: Double?, percent: Double?, currencyPrefix: String) -> String {
    let amountText: String
    if let amount {
        let sign = amount > 0 ? "+" : ""
        amountText = "\(sign)\(currencyPrefix)\(formatNumber(amount, minFraction: 2, maxFraction: 2))"
    } else {
        amountText = "--"
    }

    let percentText: String
    if let percent {
        let sign = percent > 0 ? "+" : ""
        percentText = "\(sign)\(formatNumber(percent, minFraction: 2, maxFraction: 2))%"
    } else {
        percentText = "--"
    }

    return "\(amountText) · \(percentText)"
}

private func formatPercent(_ percent: Double?) -> String {
    guard let percent else {
        return "--"
    }
    let sign = percent > 0 ? "+" : ""
    return "\(sign)\(formatNumber(percent, minFraction: 2, maxFraction: 2))%"
}

private func priceColor(for asset: DisplayAsset, mode: PriceColorMode, whiteAlpha: CGFloat, errorAlpha: CGFloat) -> NSColor {
    if asset.errorMessage != nil {
        return NSColor.white.withAlphaComponent(errorAlpha)
    }

    let white = NSColor.white.withAlphaComponent(whiteAlpha)
    guard let percent = asset.changePercent, percent != 0 else {
        return white
    }

    let red = NSColor(calibratedRed: 1.0, green: 0.30, blue: 0.34, alpha: 1)
    let green = NSColor(calibratedRed: 0.35, green: 0.86, blue: 0.48, alpha: 1)

    switch mode {
    case .white:
        return white
    case .redRiseGreenFall:
        return percent > 0 ? red : green
    case .redFallGreenRise:
        return percent > 0 ? green : red
    }
}

private func appLogoImage() -> NSImage? {
    let bundle = Bundle.main
    for resource in [("AppLogo", "png"), ("AppLogo", "svg"), ("AppIcon", "svg"), ("CareAssets", "icns")] {
        guard let url = bundle.url(forResource: resource.0, withExtension: resource.1),
              let image = NSImage(contentsOf: url) else {
            continue
        }
        image.isTemplate = false
        return image
    }
    return nil
}

private func appFont(ofSize size: CGFloat, weight: NSFont.Weight = .regular) -> NSFont {
    for name in ["TeX Gyre Adventor", "TeXGyreAdventor", "Didact Gothic"] {
        guard let font = NSFont(name: name, size: size) else { continue }
        if [.semibold, .bold, .heavy, .black].contains(weight) {
            return NSFontManager.shared.convert(font, toHaveTrait: .boldFontMask)
        }
        return font
    }

    return NSFont.systemFont(ofSize: size, weight: weight)
}

private func senFont(ofSize size: CGFloat) -> NSFont {
    for name in ["Sen-Medium", "Sen Medium", "Sen"] {
        if let font = NSFont(name: name, size: size) {
            return font
        }
    }
    return NSFont.systemFont(ofSize: size, weight: .medium)
}

private func mixedAttributedString(
    _ text: String,
    baseFont: NSFont,
    asciiFont: NSFont,
    color: NSColor,
    paragraphStyle: NSParagraphStyle? = nil
) -> NSAttributedString {
    var attributes: [NSAttributedString.Key: Any] = [
        .font: baseFont,
        .foregroundColor: color
    ]
    if let paragraphStyle {
        attributes[.paragraphStyle] = paragraphStyle
    }

    let attributed = NSMutableAttributedString(string: text, attributes: attributes)
    var location = 0
    for character in text {
        let characterString = String(character)
        let length = (characterString as NSString).length
        if usesSenFont(character) {
            attributed.addAttribute(.font, value: asciiFont, range: NSRange(location: location, length: length))
        }
        location += length
    }
    return attributed
}

private func usesSenFont(_ character: Character) -> Bool {
    character.unicodeScalars.allSatisfy { scalar in
        scalar.value >= 0x20 && scalar.value <= 0x7E
    }
}

private func errorAsset(_ asset: TrackedAsset, source: String, message: String) -> DisplayAsset {
    DisplayAsset(
        id: "\(asset.type.rawValue)-\(asset.symbol)",
        type: asset.type,
        name: asset.name,
        symbol: asset.symbol,
        source: source,
        menuPriceText: "--",
        priceText: "--",
        detailText: source,
        changeText: "--",
        changePercent: nil,
        updatedAt: nil,
        visibleInMenuBar: asset.visibleInMenuBar,
        errorMessage: message,
        timeSeries: nil,
        timeSeriesChange: nil,
        timeSeriesHigh: nil,
        timeSeriesLow: nil
    )
}

let app = NSApplication.shared
let delegate = AppDelegate()
app.setActivationPolicy(.accessory)
app.delegate = delegate
app.run()
