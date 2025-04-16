import SwiftUI

struct ContentView: View {
    // Массив стран, флаги которых будут выбраны случайным образом для игры
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    // Индекс правильного флага (0, 1, или 2)
    @State private var correctAnswer = Int.random(in: 0...2)

    // Заголовок для алерта
    @State private var scoreTitle = ""
    
    // Флаг, который управляет показом алерта
    @State private var showingScore = false
    
    // Текущий счёт
    @State private var score = 0
    
    // Количество заданных вопросов (максимум 8)
    @State private var questionCount = 0

    var body: some View {
        ZStack {
            // Создаём градиентный фон для всего экрана
            RadialGradient(stops: [
                .init(color: Color(red: 0.1, green: 0.2, blue: 0.45), location: 0.3), // Синий цвет
                .init(color: Color(red: 0.76, green: 0.15, blue: 0.26), location: 0.3)  // Красный цвет
            ], center: .top, startRadius: 200, endRadius: 700)  // Расстояние градиента
                .ignoresSafeArea()  // Игнорируем безопасную область устройства

            VStack {
                Spacer() // Вставляем отступ сверху

                // Заголовок игры
                Text("Guess the Flag")
                    .font(.largeTitle.bold())  // Большой жирный шрифт
                    .foregroundStyle(.white)   // Белый цвет текста

                VStack(spacing: 15) {
                    // Подсказка с названием страны, флаг которой нужно угадать
                    VStack {
                        Text("Tap the flag of")
                            .foregroundStyle(.secondary)  // Используем вторичный цвет для текста
                            .font(.subheadline.weight(.heavy))  // Маленький жирный шрифт

                        Text(countries[correctAnswer])  // Отображаем страну, чей флаг нужно угадать
                            .font(.largeTitle.weight(.semibold))  // Большой полужирный шрифт
                    }

                    // Перебираем флаги (картинки) и отображаем их как кнопки
                    ForEach(0..<3) { number in
                        Button {
                            flagTapped(number)  // Когда флаг выбран, вызываем функцию flagTapped
                        } label: {
                            // Изображение флага, с закруглёнными углами и тенями
                            Image(countries[number])
                                .clipShape(.capsule)  // Закругляем изображение
                                .shadow(radius: 5)   // Добавляем тень
                        }
                    }
                }
                .frame(maxWidth: .infinity)  // Растягиваем весь блок по ширине
                .padding(.vertical, 20)     // Добавляем вертикальные отступы
                .background(.regularMaterial)  // Используем полупрозрачный фон
                .clipShape(.rect(cornerRadius: 20))  // Закругляем углы блока

                Spacer()  // Отступ снизу
                Spacer()  // Дополнительный отступ

                // Текущий счёт
                Text("Score: \(score)")
                    .foregroundStyle(.white)  // Белый цвет для счёта
                    .font(.title.bold())  // Большой жирный шрифт

                Spacer()  // Отступ снизу
            }
            .padding()  // Добавляем общий отступ
        }
        // Алерт с результатом (показывается при нажатии на кнопку)
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)  // При нажатии на кнопку "Continue" вызываем askQuestion
        } message: {
            // В сообщении выводим итоговую информацию
            Text(questionCount == 8 ? "Game Over! Your final score is \(score)." : "Your score is \(score).")
        }
    }

    // Функция, которая вызывается, когда пользователь выбирает флаг
    func flagTapped(_ number: Int) {
        questionCount += 1  // Увеличиваем количество вопросов на 1

        // Если выбран правильный флаг
        if number == correctAnswer {
            scoreTitle = "Correct"  // Заголовок алерта: "Правильно"
            score += 1  // Увеличиваем счёт на 1
        } else {
            // Если выбран неправильный флаг
            scoreTitle = "Wrong! That's the flag of \(countries[correctAnswer])"  // Показываем правильный флаг в сообщении
        }

        // Если мы уже задали 8 вопросов, показываем финальный результат
        if questionCount == 8 {
            scoreTitle = "Game Over!"  // Итоговый заголовок
        }

        showingScore = true  // Показываем алерт
    }

    // Функция для смены вопроса
    func askQuestion() {
        // Если вопросов меньше 8
        if questionCount < 8 {
            countries.shuffle()  // Перемешиваем массив стран
            correctAnswer = Int.random(in: 0...2)  // Случайным образом выбираем новый правильный флаг
        } else {
            // После 8 вопросов — начинаем новую игру
            questionCount = 0  // Сбрасываем количество вопросов
            score = 0  // Обнуляем счёт
            countries.shuffle()  // Перемешиваем страны
            correctAnswer = Int.random(in: 0...2)  // Выбираем новый правильный флаг
            scoreTitle = "Start a new game!"  // Заголовок для нового старта игры
        }
    }
}

#Preview {
    ContentView()
}
