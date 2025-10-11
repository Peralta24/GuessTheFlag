import SwiftUI

struct ContentView: View {
    
    // Lista de países
    @State private var countries = ["Estonia", "France", "Germany", "Ireland", "Italy", "Nigeria", "Poland", "Spain", "UK", "Ukraine", "US"].shuffled()
    
    // Respuesta correcta
    @State private var correctAnswer = Int.random(in: 0...2)
    
    // Estados
    @State private var showingScore = false
    @State private var showingEndGame = false
    @State private var scoreTitle = ""
    @State private var puntuacionUsuario: Int = 0
    @State private var totalPreguntas: Int = 8
    
    @State private var selectedFlag : Int? = nil
    
    var body: some View {
        ZStack {
            RadialGradient(stops: [
                .init(color: Color(red:0.1, green:0.2, blue:0.45), location: 0.3),
                .init(color: Color(red:0.76, green:0.15, blue:0.26), location: 0.3)
            ], center: .top, startRadius: 200, endRadius: 700)
                .ignoresSafeArea(edges: .all)
            
            VStack {
                Spacer()
                
                Text("Guess the Flag")
                    .font(.largeTitle)
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
                
                VStack(spacing: 15) {
                    VStack {
                        Text("Tap the flag of")
                            .font(.headline)
                            .foregroundStyle(.secondary)
                        Text(countries[correctAnswer])
                            .font(.largeTitle.weight(.semibold))
                    }
                    
                    ForEach(0..<3) { number in
                        Button {
                            // Añadimos una animación explícita para el cambio de estado
                            withAnimation {
                                flaggTapped(number)
                            }
                        } label: {
                            Image(countries[number])
                                .clipShape(.capsule)
                                .shadow(radius: 5)
                                // --- INICIO DE MODIFICADORES NUEVOS ---
                                .rotation3DEffect(
                                    .degrees(selectedFlag == number ? 360 : 0),
                                    axis: (x: 0.0, y: 1.0, z: 0.0)
                                )
                                .opacity(selectedFlag == nil || selectedFlag == number ? 1.0 : 0.25)
                                .scaleEffect(selectedFlag == nil || selectedFlag == number ? 1.0 : 0.75)
                                // --- FIN DE MODIFICADORES NUEVOS ---
                        }
                    }
                }
                .frame(maxWidth: .infinity)
                .padding(.vertical, 20)
                .background(.regularMaterial)
                .clipShape(.rect(cornerRadius: 20))
                
                Spacer()
                Spacer()
                Text("Total de Preguntas: \(totalPreguntas)")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.title3)
                Text("Score: \(puntuacionUsuario)")
                    .foregroundStyle(.white)
                    .fontWeight(.bold)
                    .font(.title3)
                
                Spacer()
            }
            .padding()
        }
        
        // Primer alert → resultado de la pregunta
        .alert(scoreTitle, isPresented: $showingScore) {
            Button("Continue", action: askQuestion)
        } message: {
            Text("Your score is \(puntuacionUsuario)")
        }
        
        // Segundo alert → fin del juego
        .alert("End of the Game", isPresented: $showingEndGame) {
            Button("Reset", action: reset)
        } message: {
            Text(scoreTitle + "\nFinal score: \(puntuacionUsuario)")
        }
    }
    
    func flaggTapped(_ number: Int) {
        selectedFlag = number
        if number == correctAnswer {
            scoreTitle = "Correct!"
            puntuacionUsuario += 1
            
        } else {
            scoreTitle = "Wrong! That’s the flag of \(countries[number])"
            if puntuacionUsuario <= 0 {
                puntuacionUsuario = 0
            }else{
                puntuacionUsuario -= 1
            }
        }
        
        if totalPreguntas == 1 {
            // fin del juego
            if puntuacionUsuario >= 4 {
                scoreTitle = "🎉 You Win!"
            } else {
                scoreTitle = "😢 You Lose!"
            }
            showingEndGame = true
        } else {
            totalPreguntas -= 1
            showingScore = true
        }
    }
    
    func askQuestion() {
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        selectedFlag = nil
    }
    
    func reset() {
        totalPreguntas = 8
        puntuacionUsuario = 0
        countries.shuffle()
        correctAnswer = Int.random(in: 0...2)
        showingEndGame = false
    }
}

#Preview {
    ContentView()
}
