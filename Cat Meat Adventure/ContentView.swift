


import SwiftUI
import Combine


// MARK: - Data Models
struct Level: Identifiable, Hashable {
    let id: Int
    let name: String
    let duration: Int
    let targetWeight: Int
    var unlocked: Bool
}

struct LevelConfig {
    let duration: Int
    let targetWeight: Int
}

struct Meat: Identifiable {
    let id: UUID
    let type: MeatType
    var position: CGPoint
    var lineIndex: Int
}

enum MeatType: String, CaseIterable {
    case bone = "bone"
    case meat = "meat"
    case chicken = "chicken"
    case beef = "beef"
    
    var weightValue: Int {
        switch self {
        case .bone: return 50
        case .meat: return 100
        case .chicken: return 150
        case .beef: return 200
        }
    }
    
    var imageName: String {
        switch self {
        case .bone: return "bone"
        case .meat: return "meat"
        case .chicken: return "chicken"
        case .beef: return "beef"
        }
    }
    
    var color: Color {
        switch self {
        case .bone: return .gray
        case .meat: return .red
        case .chicken: return .yellow
        case .beef: return .brown
        }
    }
}

enum Direction {
    case up, down, left, right
}

// MARK: - Game Data Manager
class GameDataManager: ObservableObject {
    @Published var unlockedLevels: Int = 1
    
    private let unlockedLevelsKey = "unlockedLevels"
    
    init() {
        loadUnlockedLevels()
    }
    
    func loadUnlockedLevels() {
        unlockedLevels = UserDefaults.standard.integer(forKey: unlockedLevelsKey)
        if unlockedLevels == 0 {
            unlockedLevels = 1
            saveUnlockedLevels()
        }
    }
    
    func saveUnlockedLevels() {
        UserDefaults.standard.set(unlockedLevels, forKey: unlockedLevelsKey)
    }
    
    func unlockNextLevel(after currentLevel: Int) {
        if currentLevel >= unlockedLevels && currentLevel < 6 {
            unlockedLevels = currentLevel + 1
            saveUnlockedLevels()
        }
    }
    
    func isLevelUnlocked(_ level: Int) -> Bool {
        return level <= unlockedLevels
    }
    
    func resetProgress() {
        unlockedLevels = 1
        saveUnlockedLevels()
    }
}

// MARK: - Splash Screen
struct SplashScreenView: View {
    @State private var isActive = false
    @State private var size = 0.8
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainMenuView()
        } else {
            ZStack {
                Image("splash_background")
                    .resizable()
                    .scaledToFill()
                    .ignoresSafeArea()
                
                LinearGradient(
                    gradient: Gradient(colors: [Color.black.opacity(0.6), Color.orange.opacity(0.4)]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .ignoresSafeArea()
                
                VStack {
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 160, height: 160)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .blur(radius: 10)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 1)
                            )
                        
                        Image("cat_game")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 120, height: 120)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    }
                    
                    VStack {
                        Text("Cat Meat")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        Text("Adventure")
                            .font(.system(size: 42, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    .padding(.top, 20)
                    
                    Text("Collect meats and get chubby!")
                        .font(.title3)
                        .fontWeight(.medium)
                        .foregroundColor(.white.opacity(0.9))
                        .padding(.top, 5)
                }
                .scaleEffect(size)
                .opacity(opacity)
                .onAppear {
                    withAnimation(.easeIn(duration: 1.2)) {
                        self.size = 1.0
                        self.opacity = 1.0
                    }
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

// MARK: - Main Menu
struct MainMenuView: View {
    @StateObject private var gameDataManager = GameDataManager()
    @State private var navigationPath = NavigationPath()
    @State private var showLevels = false
    
    var body: some View {
        NavigationStack(path: $navigationPath) {
            ZStack {
                GeometryReader { geometry in
                    Image("splash_background")
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.5)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                        .ignoresSafeArea()
                }
                .ignoresSafeArea()
             
                ScrollView {
                VStack(spacing: 40) {
                    Spacer()
                    
                    VStack {
                        Text("Cat Meat")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                        
                        Text("Adventure")
                            .font(.system(size: 48, weight: .black, design: .rounded))
                            .foregroundColor(.white)
                            .shadow(color: .black.opacity(0.5), radius: 10, x: 0, y: 5)
                    }
                    
                    ZStack {
                        Circle()
                            .fill(Color.white.opacity(0.2))
                            .frame(width: 200, height: 200)
                            .background(
                                Circle()
                                    .fill(Color.white.opacity(0.1))
                                    .blur(radius: 20)
                            )
                            .overlay(
                                Circle()
                                    .stroke(Color.white.opacity(0.3), lineWidth: 2)
                            )
                        
                        Image("cat_game")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 180, height: 180)
                            .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
                    }
                    

                    
                    VStack(spacing: 20) {
                        MenuButton(
                            title: "Launch Game",
                            subtitle: "Begin your meat hunt",
                            icon: "play.circle.fill",
                            color: .orange,
                            action: { navigationPath.append(1) }
                        )
                        
                        MenuButton(
                            title: "Level Choice",
                            subtitle: "Select your challenge",
                            icon: "square.grid.3x3.fill",
                            color: .green,
                            action: { navigationPath.append("LevelSelection") }
                        )
                        
                        MenuButton(
                            title: "Reset Game",
                            subtitle: "Start fresh journey",
                            icon: "arrow.clockwise.circle.fill",
                            color: .red,
                            action: { gameDataManager.resetProgress() }
                        )
                    }
                    .padding(.horizontal, 30)
                    
                    Spacer()
                    
                    Text("Unlocked Levels: \(gameDataManager.unlockedLevels)/6")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.8))
                        .padding(.bottom, 20)
                }
                .padding()
                
              }
            }
            .navigationDestination(for: Int.self) { level in
                GameView(level: level, gameDataManager: gameDataManager)
            }
            .navigationDestination(for: String.self) { destination in
                if destination == "LevelSelection" {
                    LevelSelectionView(gameDataManager: gameDataManager)
                }
            }
        }
    }
}


struct MenuButton: View {
    let title: String
    let subtitle: String
    let icon: String
    let color: Color
    let action: () -> Void
    
    @State private var isHovered = false
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 16) {
                // Icon Container
                ZStack {
                    Circle()
                        .fill(color.opacity(0.9))
                        .frame(width: 50, height: 50)
                    
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 46, height: 46)
                    
                    Image(systemName: icon)
                        .font(.system(size: 20, weight: .bold))
                        .foregroundColor(.white)
                }
                .shadow(color: color.opacity(0.5), radius: 8, x: 0, y: 4)
                
                // Text Content
                VStack(alignment: .leading, spacing: 4) {
                    Text(title)
                        .font(.system(size: 18, weight: .bold, design: .rounded))
                        .foregroundColor(.white)
                    
                    Text(subtitle)
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.white.opacity(0.8))
                }
                
                Spacer()
                
                // Arrow Indicator
                Image(systemName: "chevron.right")
                    .font(.system(size: 16, weight: .bold))
                    .foregroundColor(.white.opacity(0.7))
                    .scaleEffect(isHovered ? 1.2 : 1.0)
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)

        }
        .buttonStyle(PlainButtonStyle())
        .onHover { hovering in
            withAnimation(.easeInOut(duration: 0.2)) {
                isHovered = hovering
            }
        }
    }
}

// MARK: - Level Selection
struct LevelSelectionView: View {
    @ObservedObject var gameDataManager: GameDataManager
    @Environment(\.dismiss) private var dismiss
    
    let levels = [
        Level(id: 1, name: "Tiny Cattie", duration: 45, targetWeight: 1500, unlocked: true),
        Level(id: 2, name: "Growing Cat", duration: 60, targetWeight: 2500, unlocked: false),
        Level(id: 3, name: "Chubby Buddy", duration: 75, targetWeight: 4000, unlocked: false),
        Level(id: 4, name: "Fat Friend", duration: 90, targetWeight: 6000, unlocked: false),
        Level(id: 5, name: "Big Fluff", duration: 105, targetWeight: 8500, unlocked: false),
        Level(id: 6, name: "Mega Chonk", duration: 120, targetWeight: 12000, unlocked: false)
    ]
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("game_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.5)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
            
            VStack {
                HStack {
                    BackButton {
                        dismiss()
                    }
                    
                    Spacer()
                    
                    Text("Level Choice")
                        .font(.title)
                        .fontWeight(.black)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 5)
                    
                    Spacer()
                    
                    BackButton {}.opacity(0)
                }
                .padding(.horizontal)
                .padding(.top, 10)
                
                ScrollView {
                    LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 20) {
                        ForEach(levels) { level in
                            LevelCardView(
                                level: level,
                                isUnlocked: gameDataManager.isLevelUnlocked(level.id)
                            ) {
                                if gameDataManager.isLevelUnlocked(level.id) {
                                    // Navigation will be handled by the parent NavigationStack
                                }
                            }
                        }
                    }
                    .padding()
                }
            }
        }
        .navigationBarHidden(true)
    }
}

struct BackButton: View {
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 44, height: 44)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .blur(radius: 5)
                    )
                
                Image(systemName: "chevron.left")
                    .font(.system(size: 18, weight: .bold))
                    .foregroundColor(.white)
            }
        }
    }
}

struct LevelCardView: View {
    let level: Level
    let isUnlocked: Bool
    let action: () -> Void
    
    private var cardBackgroundColor: Color {
        isUnlocked ? Color.white.opacity(0.15) : Color.gray.opacity(0.3)
    }
    
    private var cardBlurColor: Color {
        isUnlocked ? Color.white.opacity(0.1) : Color.gray.opacity(0.2)
    }
    
    private var cardStrokeColor: Color {
        isUnlocked ? Color.white.opacity(0.2) : Color.gray.opacity(0.3)
    }
    
    private var titleColor: Color {
        isUnlocked ? .white : .gray
    }
    
    private var subtitleColor: Color {
        isUnlocked ? .white.opacity(0.9) : .gray.opacity(0.7)
    }
    
    private var labelColor: Color {
        isUnlocked ? .white.opacity(0.8) : .gray.opacity(0.6)
    }
    
    var body: some View {
        NavigationLink(value: level.id) {
            VStack {
                ZStack {
                    RoundedRectangle(cornerRadius: 25)
                        .fill(cardBackgroundColor)
                        .frame(height: 180)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(cardBlurColor)
                                .blur(radius: 10)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 25)
                                .stroke(cardStrokeColor, lineWidth: 1)
                        )
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                    
                    VStack(spacing: 12) {
                        Text("Level \(level.id)")
                            .font(.title2)
                            .fontWeight(.black)
                            .foregroundColor(titleColor)
                        
                        Text(level.name)
                            .font(.headline)
                            .fontWeight(.medium)
                            .foregroundColor(subtitleColor)
                        
                        HStack(spacing: 15) {
                            Label("\(level.duration)s", systemImage: "clock")
                                .font(.caption)
                                .foregroundColor(labelColor)
                            
                            Label(formatWeight(level.targetWeight), systemImage: "scalemass")
                                .font(.caption)
                                .foregroundColor(labelColor)
                        }
                        
                        Group {
                            if !isUnlocked {
                                Image(systemName: "lock.fill")
                                    .foregroundColor(.gray)
                                    .font(.title2)
                            } else {
                                Text("Play")
                                    .font(.caption)
                                    .fontWeight(.bold)
                                    .foregroundColor(.orange)
                                    .padding(.horizontal, 20)
                                    .padding(.vertical, 8)
                                    .background(
                                        Capsule()
                                            .fill(Color.orange.opacity(0.2))
                                            .overlay(
                                                Capsule()
                                                    .stroke(Color.orange, lineWidth: 1)
                                            )
                                    )
                            }
                        }
                    }
                }
            }
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!isUnlocked)
    }
    
    private func formatWeight(_ weight: Int) -> String {
        if weight >= 1000 {
            let kg = Double(weight) / 1000.0
            return String(format: "%.1fkg", kg)
        } else {
            return "\(weight)g"
        }
    }
}

// MARK: - Game View
struct GameView: View {
    @State var level: Int
    @ObservedObject var gameDataManager: GameDataManager
    @Environment(\.dismiss) private var dismiss
    
    @State private var catWeight: Int = 300
    @State private var timeRemaining: Int = 30
    @State private var gameStarted = false
    @State private var gameOver = false
    @State private var levelCompleted = false
    @State private var isPaused = false
    @State private var comboCount: Int = 0
    @State private var lastMeatType: MeatType? = nil
    @State private var showComboText: Bool = false
    @State private var comboText: String = ""
    @State private var comboPosition: CGPoint = .zero
    
    @State private var meats: [Meat] = []
    @State private var catPosition = CGPoint(x: UIScreen.main.bounds.width / 2, y: UIScreen.main.bounds.height / 2)
    
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    let meatMoveTimer = Timer.publish(every: 0.1, on: .main, in: .common).autoconnect()
    
    private func getLevelConfig(for level: Int) -> LevelConfig {
        switch level {
        case 1: return LevelConfig(duration: 45, targetWeight: 1500)
        case 2: return LevelConfig(duration: 60, targetWeight: 2500)
        case 3: return LevelConfig(duration: 75, targetWeight: 4000)
        case 4: return LevelConfig(duration: 90, targetWeight: 6000)
        case 5: return LevelConfig(duration: 105, targetWeight: 8500)
        case 6: return LevelConfig(duration: 120, targetWeight: 12000)
        default: return LevelConfig(duration: 45, targetWeight: 1500)
        }
    }
    
    private var levelConfig: LevelConfig {
        return getLevelConfig(for: level)
    }
    
    private let maxCatSize: CGFloat = 180
    private let baseCatSize: CGFloat = 80
    private let numberOfLines = 6
    private let meatSpeed: CGFloat = 3.0
    private var headerHeight: CGFloat = 120
    private var controlsHeight: CGFloat = 150
    
    public init(level: Int, gameDataManager: GameDataManager) {
        self._level = State(initialValue: level)
        self.gameDataManager = gameDataManager
    }
    
    var body: some View {
        ZStack {
            GeometryReader { geometry in
                Image("game_background")
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .overlay(
                        LinearGradient(
                            gradient: Gradient(colors: [Color.black.opacity(0.7), Color.black.opacity(0.5)]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .ignoresSafeArea()
            }
            .ignoresSafeArea()
            
            if !gameStarted {
                StartGameView(level: level, onStart: startGame)
            } else if gameOver {
                GameOverView(
                    finalWeight: catWeight,
                    targetWeight: levelConfig.targetWeight,
                    levelCompleted: levelCompleted,
                    currentLevel: level,
                    onRestart: restartGame,
                    onNextLevel: levelCompleted && level < 6 ? goToNextLevel : nil,
                    onMenu: { dismiss() }
                )
            } else {
                VStack(spacing: 0) {
                    HStack {
                        VStack(alignment: .leading, spacing: 4) {
                            Text("Level \(level)")
                                .font(.title3)
                                .fontWeight(.black)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 2)
                            
                            Text("Weight: \(formatWeight(catWeight))")
                                .font(.headline)
                                .fontWeight(.semibold)
                                .foregroundColor(.white)
                                .shadow(color: .black.opacity(0.5), radius: 2)
                            
                            Text("Target: \(formatWeight(levelConfig.targetWeight))")
                                .font(.subheadline)
                                .foregroundColor(.white.opacity(0.9))
                                .shadow(color: .black.opacity(0.5), radius: 2)
                            
                            WeightProgressBar(
                                currentWeight: catWeight,
                                targetWeight: levelConfig.targetWeight
                            )
                            
                            if comboCount > 0 {
                                Text("Combo: x\(comboCount)")
                                    .font(.subheadline)
                                    .fontWeight(.bold)
                                    .foregroundColor(.yellow)
                                    .shadow(color: .black.opacity(0.5), radius: 2)
                            }
                        }
                        
                        Spacer()
                        
                        VStack(alignment: .trailing, spacing: 4) {
                            Text("Time: \(timeRemaining)s")
                                .font(.title2)
                                .fontWeight(.black)
                                .foregroundColor(timeRemaining <= 10 ? .red : .white)
                                .shadow(color: .black.opacity(0.5), radius: 2)
                            
                            Button(action: togglePause) {
                                ZStack {
                                    Circle()
                                        .fill(Color.white.opacity(0.2))
                                        .frame(width: 44, height: 44)
                                    
                                    Image(systemName: isPaused ? "play.circle.fill" : "pause.circle.fill")
                                        .font(.title2)
                                        .foregroundColor(.white)
                                        .shadow(color: .black.opacity(0.5), radius: 2)
                                }
                            }
                        }
                    }
                    .padding()
                    .frame(height: headerHeight + 40)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.black.opacity(0.4))
                            .overlay(
                                RoundedRectangle(cornerRadius: 15)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                    .padding(.horizontal)
                    
                    GeometryReader { geometry in
                        ZStack {
                            ForEach(0..<numberOfLines, id: \.self) { index in
                                Rectangle()
                                    .fill(Color.white.opacity(0.1))
                                    .frame(width: 2, height: geometry.size.height)
                                    .position(x: getLineXPosition(for: index, in: geometry.size.width), y: geometry.size.height / 2)
                            }
                            
                            ForEach(meats) { meat in
                                MeatView(meatType: meat.type)
                                    .position(meat.position)
                            }
                            
                            Image("cat_game")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: calculateCatSize(), height: calculateCatSize())
                                .position(catPosition)
                                .shadow(color: .black.opacity(0.3), radius: 5, x: 0, y: 5)
                            
                            if showComboText {
                                Text(comboText)
                                    .font(.system(size: 24, weight: .black, design: .rounded))
                                    .foregroundColor(.yellow)
                                    .shadow(color: .black.opacity(0.8), radius: 5)
                                    .position(comboPosition)
                                    .transition(.scale.combined(with: .opacity))
                            }
                        }
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .onAppear {
                            catPosition = CGPoint(
                                x: geometry.size.width / 2,
                                y: geometry.size.height / 2
                            )
                        }
                    }
                    
                    HStack {
                        Spacer()
                        
                        VStack(spacing: 15) {
                            ControlButton(direction: .up, action: { moveCat(direction: .up) })
                            
                            HStack(spacing: 15) {
                                ControlButton(direction: .left, action: { moveCat(direction: .left) })
                                ControlButton(direction: .down, action: { moveCat(direction: .down) })
                                ControlButton(direction: .right, action: { moveCat(direction: .right) })
                            }
                        }
                        .padding(.trailing, 30)
                        .padding(.bottom, 20)
                    }
                    .frame(height: controlsHeight)
                }
                
                if isPaused {
                    PauseView(onResume: togglePause, onMenu: { dismiss() })
                }
            }
        }
        .navigationBarHidden(true)
        .onReceive(timer) { _ in
            guard gameStarted && !gameOver && !isPaused else { return }
            
            if timeRemaining > 0 {
                timeRemaining -= 1
                spawnMeatLines()
            } else {
                levelCompleted = catWeight >= levelConfig.targetWeight
                endGame()
            }
        }
        .onReceive(meatMoveTimer) { _ in
            guard gameStarted && !gameOver && !isPaused else { return }
            moveMeats()
            checkCollisions()
        }
        .onAppear {
            timeRemaining = levelConfig.duration
        }
    }
    
    private func calculateCatSize() -> CGFloat {
        let weightProgress = CGFloat(catWeight - 300) / CGFloat(levelConfig.targetWeight - 300)
        let sizeIncrease = weightProgress * (maxCatSize - baseCatSize)
        let calculatedSize = baseCatSize + sizeIncrease
        return min(calculatedSize, maxCatSize)
    }
    
    private func formatWeight(_ weight: Int) -> String {
        if weight >= 1000 {
            let kg = Double(weight) / 1000.0
            return String(format: "%.1fkg", kg)
        } else {
            return "\(weight)g"
        }
    }
    
    private func getLineXPosition(for index: Int, in width: CGFloat) -> CGFloat {
        let spacing = width / CGFloat(numberOfLines + 1)
        return spacing * CGFloat(index + 1)
    }
    
    private func startGame() {
        gameStarted = true
        spawnMeatLines()
    }
    
    private func spawnMeatLines() {
        let screenHeight = UIScreen.main.bounds.height
        let gameAreaTop = headerHeight + 20
        _ = screenHeight - controlsHeight
        
        if Int.random(in: 0...2) == 0 {
            for lineIndex in 0..<numberOfLines {
                let randomType = MeatType.allCases.randomElement() ?? .meat
                
                let newMeat = Meat(
                    id: UUID(),
                    type: randomType,
                    position: CGPoint(
                        x: getLineXPosition(for: lineIndex, in: UIScreen.main.bounds.width),
                        y: gameAreaTop - 50
                    ),
                    lineIndex: lineIndex
                )
                
                meats.append(newMeat)
            }
        }
        
        if meats.count > 25 {
            meats.removeFirst(meats.count - 25)
        }
    }
    
    private func moveMeats() {
        let screenHeight = UIScreen.main.bounds.height
        let gameAreaBottom = screenHeight - controlsHeight
        
        for index in meats.indices {
            meats[index].position.y += meatSpeed
            
            if meats[index].position.y > gameAreaBottom + 50 {
                meats.remove(at: index)
                break
            }
        }
    }
    
    private func checkCollisions() {
        let screenHeight = UIScreen.main.bounds.height
        _ = headerHeight + 20
        _ = screenHeight - controlsHeight
        
        let catSize = calculateCatSize()
        let catRect = CGRect(x: catPosition.x - catSize/2, y: catPosition.y - catSize/2, width: catSize, height: catSize)
        
        for meat in meats {
            let meatRect = CGRect(x: meat.position.x - 25, y: meat.position.y - 25, width: 50, height: 50)
            
            if catRect.intersects(meatRect) {
                var weightGain = meat.type.weightValue
                
                if lastMeatType == meat.type {
                    comboCount += 1
                    weightGain += comboCount * 10
                    
                    showComboText(meatType: meat.type, position: meat.position, comboCount: comboCount)
                } else {
                    comboCount = 0
                }
                
                lastMeatType = meat.type
                catWeight += weightGain
                meats.removeAll { $0.id == meat.id }
                
                let impactMed = UIImpactFeedbackGenerator(style: .medium)
                impactMed.impactOccurred()
                
                if catWeight >= levelConfig.targetWeight {
                    levelCompleted = true
                    DispatchQueue.main.asyncAfter(deadline: .now() + 0.5) {
                        endGame()
                    }
                }
                
                break
            }
        }
    }
    
    private func showComboText(meatType: MeatType, position: CGPoint, comboCount: Int) {
        comboText = "COMBO x\(comboCount)!\n+\(10 * comboCount) Bonus"
        comboPosition = position
        showComboText = true
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.5) {
            withAnimation(.easeOut(duration: 0.5)) {
                showComboText = false
            }
        }
    }
    
    private func moveCat(direction: Direction) {
        let screenHeight = UIScreen.main.bounds.height
        let gameAreaTop = headerHeight + 80
        let gameAreaBottom = screenHeight - controlsHeight - 60
        
        let moveDistance: CGFloat = 30
        var newPosition = catPosition
        
        switch direction {
        case .up:
            newPosition.y = max(gameAreaTop, catPosition.y - moveDistance)
        case .down:
            newPosition.y = min(gameAreaBottom, catPosition.y + moveDistance)
        case .left:
            newPosition.x = max(50, catPosition.x - moveDistance)
        case .right:
            newPosition.x = min(UIScreen.main.bounds.width - 50, catPosition.x + moveDistance)
        }
        
        withAnimation(.spring(response: 0.3, dampingFraction: 0.7)) {
            catPosition = newPosition
        }
        checkCollisions()
    }
    
    private func goToNextLevel() {
        let nextLevel = level + 1
        gameDataManager.unlockNextLevel(after: level)
        restartGameForLevel(nextLevel)
    }
    
    private func restartGameForLevel(_ newLevel: Int) {
        level = newLevel
        catWeight = 300
        timeRemaining = getLevelConfig(for: newLevel).duration
        gameOver = false
        levelCompleted = false
        gameStarted = true
        isPaused = false
        comboCount = 0
        lastMeatType = nil
        meats.removeAll()
        
        let screenHeight = UIScreen.main.bounds.height
        let gameAreaTop = headerHeight + 20
        let gameAreaBottom = screenHeight - controlsHeight
        catPosition = CGPoint(
            x: UIScreen.main.bounds.width / 2,
            y: (gameAreaTop + gameAreaBottom) / 2
        )
        
        spawnMeatLines()
    }
    
    private func endGame() {
        gameOver = true
        
        if levelCompleted && level < 6 {
            gameDataManager.unlockNextLevel(after: level)
        }
    }
    
    private func restartGame() {
        catWeight = 300
        timeRemaining = levelConfig.duration
        gameOver = false
        levelCompleted = false
        gameStarted = true
        isPaused = false
        comboCount = 0
        lastMeatType = nil
        meats.removeAll()
        
        let screenHeight = UIScreen.main.bounds.height
        let gameAreaTop = headerHeight + 20
        let gameAreaBottom = screenHeight - controlsHeight
        catPosition = CGPoint(
            x: UIScreen.main.bounds.width / 2,
            y: (gameAreaTop + gameAreaBottom) / 2
        )
        
        spawnMeatLines()
    }
    
    private func togglePause() {
        isPaused.toggle()
    }
}

// MARK: - Supporting Views
struct WeightProgressBar: View {
    let currentWeight: Int
    let targetWeight: Int
    
    private var progress: Double {
        let progress = Double(currentWeight) / Double(targetWeight)
        return min(progress, 1.0)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 4) {
            HStack {
                Text("Progress:")
                    .font(.caption)
                    .foregroundColor(.white.opacity(0.8))
                
                Spacer()
                
                Text("\(Int(progress * 100))%")
                    .font(.caption)
                    .fontWeight(.semibold)
                    .foregroundColor(.white)
            }
            
            GeometryReader { geometry in
                ZStack(alignment: .leading) {
                    RoundedRectangle(cornerRadius: 4)
                        .fill(Color.white.opacity(0.2))
                        .frame(height: 8)
                    
                    RoundedRectangle(cornerRadius: 4)
                        .fill(progressColor)
                        .frame(width: geometry.size.width * progress, height: 8)
                    
                    if progress < 1.0 {
                        Circle()
                            .fill(Color.yellow)
                            .frame(width: 12, height: 12)
                            .position(x: geometry.size.width, y: 4)
                    }
                }
            }
            .frame(height: 8)
        }
    }
    
    private var progressColor: Color {
        if progress >= 1.0 {
            return .green
        } else if progress >= 0.7 {
            return .orange
        } else {
            return .red
        }
    }
}

struct ControlButton: View {
    let direction: Direction
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            ZStack {
                Circle()
                    .fill(Color.white.opacity(0.2))
                    .frame(width: 70, height: 70)
                    .background(
                        Circle()
                            .fill(Color.white.opacity(0.1))
                            .blur(radius: 10)
                    )
                    .overlay(
                        Circle()
                            .stroke(Color.white.opacity(0.3), lineWidth: 2)
                    )
                
                Image(systemName: arrowIcon)
                    .font(.title2)
                    .fontWeight(.bold)
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 2)
            }
        }
    }
    
    private var arrowIcon: String {
        switch direction {
        case .up: return "arrow.up"
        case .down: return "arrow.down"
        case .left: return "arrow.left"
        case .right: return "arrow.right"
        }
    }
}

struct MeatView: View {
    let meatType: MeatType
    
    var body: some View {
        ZStack {
            Image(meatType.imageName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 50, height: 50)
                .shadow(color: .black.opacity(0.3), radius: 3, x: 0, y: 3)
            
            Circle()
                .fill(meatType.color.opacity(0.3))
                .frame(width: 60, height: 60)
                .blur(radius: 8)
        }
    }
}

struct StartGameView: View {
    let level: Int
    let onStart: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.8)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Level \(level)")
                    .font(.system(size: 48, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10)
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 180, height: 180)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .blur(radius: 20)
                        )
                    
                    Image("cat_game")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 160, height: 160)
                        .shadow(color: .black.opacity(0.3), radius: 15, x: 0, y: 10)
                }
                
                VStack(spacing: 15) {
                    Text("New Meat Line System!")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.yellow)
                        .shadow(color: .black.opacity(0.5), radius: 5)
                    
                    Text("6 lines of meats moving down")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.5), radius: 3)
                    
                    Text("Same type combos = Bonus weight!")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.5), radius: 3)
                    
                    Text("Use arrow buttons to move between lines")
                        .font(.headline)
                        .foregroundColor(.white.opacity(0.9))
                        .shadow(color: .black.opacity(0.5), radius: 3)
                }
                
                Button(action: onStart) {
                    HStack {
                        Image(systemName: "play.fill")
                            .font(.title2)
                            .foregroundColor(.white)
                        
                        Text("Start Game")
                            .font(.title2)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                    }
                    .frame(width: 220, height: 60)
                    .background(
                        RoundedRectangle(cornerRadius: 30)
                            .fill(Color.orange)
                            .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 5)
                            .overlay(
                                RoundedRectangle(cornerRadius: 30)
                                    .stroke(Color.white.opacity(0.2), lineWidth: 1)
                            )
                    )
                }
            }
            .padding()
        }
    }
}

struct GameOverView: View {
    let finalWeight: Int
    let targetWeight: Int
    let levelCompleted: Bool
    let currentLevel: Int
    let onRestart: () -> Void
    let onNextLevel: (() -> Void)?
    let onMenu: () -> Void
    
    @State private var currentWeight: Int = 0
    @State private var scaleEffect: CGFloat = 1.0
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                if levelCompleted {
                    Text("Level Completed!")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(.green)
                        .shadow(color: .black.opacity(0.5), radius: 10)
                } else {
                    Text("Game Over")
                        .font(.system(size: 38, weight: .black, design: .rounded))
                        .foregroundColor(.red)
                        .shadow(color: .black.opacity(0.5), radius: 10)
                }
                
                ZStack {
                    Circle()
                        .fill(Color.orange.opacity(0.3))
                        .frame(width: 200, height: 200)
                        .background(
                            Circle()
                                .fill(Color.orange.opacity(0.2))
                                .blur(radius: 20)
                        )
                    
                    Image("cat_game")
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 180, height: 180)
                        .scaleEffect(scaleEffect)
                        .shadow(color: .black.opacity(0.3), radius: 10, x: 0, y: 10)
                }
                
                VStack(spacing: 15) {
                    Text("Final Weight: \(currentWeight)g")
                        .font(.title2)
                        .fontWeight(.semibold)
                        .foregroundColor(.white)
                        .shadow(color: .black.opacity(0.5), radius: 5)
                    
                    Text("Target: \(targetWeight)g")
                        .font(.headline)
                        .foregroundColor(levelCompleted ? .green : .red)
                        .shadow(color: .black.opacity(0.5), radius: 3)
                    
                    if levelCompleted {
                        Text("🎉 Congratulations! Your cat is chubby! 🎉")
                            .font(.headline)
                            .foregroundColor(.yellow)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black.opacity(0.5), radius: 3)
                        
                        if currentLevel == 6 {
                            Text("You've completed all levels! 🏆")
                                .font(.headline)
                                .foregroundColor(.orange)
                                .multilineTextAlignment(.center)
                                .shadow(color: .black.opacity(0.5), radius: 3)
                        }
                    } else {
                        Text("😿 Need more meat! Try again! 😿")
                            .font(.headline)
                            .foregroundColor(.orange)
                            .multilineTextAlignment(.center)
                            .shadow(color: .black.opacity(0.5), radius: 3)
                    }
                }
                
                
                VStack{
                    
                    HStack(spacing: 20) {
                        Button(action: onRestart) {
                            HStack {
                                Image(systemName: "arrow.clockwise")
                                    .font(.headline)
                                
                                Text("Play Again")
                                    .font(.headline)
                                    .fontWeight(.semibold)
                            }
                            .foregroundColor(.white)
                            .frame(width: 150, height: 50)
                            .background(
                                RoundedRectangle(cornerRadius: 25)
                                    .fill(Color.orange)
                                    .shadow(color: .black.opacity(0.3), radius: 5)
                            )
                        }
                        
                        if levelCompleted, let onNextLevel = onNextLevel {
                            Button(action: onNextLevel) {
                                HStack {
                                    Image(systemName: "arrow.right")
                                        .font(.headline)
                                    
                                    Text("Next Level")
                                        .font(.headline)
                                        .fontWeight(.semibold)
                                }
                                .foregroundColor(.white)
                                .frame(width: 150, height: 50)
                                .background(
                                    RoundedRectangle(cornerRadius: 25)
                                        .fill(Color.green)
                                        .shadow(color: .black.opacity(0.3), radius: 5)
                                )
                            }
                        }
                    }
                    
                    
                    Button(action: onMenu) {
                        HStack {
                            Image(systemName: "house.fill")
                                .font(.headline)
                            
                            Text("Main Menu")
                                .font(.headline)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(width: 150, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.blue)
                                .shadow(color: .black.opacity(0.3), radius: 5)
                        )
                    }
                }
    
            }
            .padding()
        }
        .onAppear {
            withAnimation(.easeOut(duration: 2.0)) {
                currentWeight = finalWeight
            }
            
            withAnimation(.spring(response: 0.6, dampingFraction: 0.8).repeatForever(autoreverses: true)) {
                scaleEffect = levelCompleted ? 1.2 : 1.1
            }
        }
    }
}

struct PauseView: View {
    let onResume: () -> Void
    let onMenu: () -> Void
    
    var body: some View {
        ZStack {
            Color.black.opacity(0.9)
                .ignoresSafeArea()
            
            VStack(spacing: 30) {
                Text("Game Paused")
                    .font(.system(size: 36, weight: .black, design: .rounded))
                    .foregroundColor(.white)
                    .shadow(color: .black.opacity(0.5), radius: 10)
                
                ZStack {
                    Circle()
                        .fill(Color.white.opacity(0.2))
                        .frame(width: 120, height: 120)
                        .background(
                            Circle()
                                .fill(Color.white.opacity(0.1))
                                .blur(radius: 10)
                        )
                    
                    Image(systemName: "pause.circle.fill")
                        .font(.system(size: 80))
                        .foregroundColor(.orange)
                        .shadow(color: .black.opacity(0.5), radius: 5)
                }
                
                VStack(spacing: 20) {
                    Button(action: onResume) {
                        HStack {
                            Image(systemName: "play.fill")
                                .font(.title2)
                            
                            Text("Resume Game")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(width: 220, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.orange)
                                .shadow(color: .black.opacity(0.3), radius: 5)
                        )
                    }
                    
                    Button(action: onMenu) {
                        HStack {
                            Image(systemName: "house.fill")
                                .font(.title2)
                            
                            Text("Main Menu")
                                .font(.title2)
                                .fontWeight(.semibold)
                        }
                        .foregroundColor(.white)
                        .frame(width: 220, height: 50)
                        .background(
                            RoundedRectangle(cornerRadius: 25)
                                .fill(Color.green)
                                .shadow(color: .black.opacity(0.3), radius: 5)
                        )
                    }
                }
            }
            .padding()
        }
    }
}
