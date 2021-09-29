//
//  CounterView.swift
//  Tally Counter
//
//  Created by  Vladyslav Fil on 29.09.2021.
//

import SwiftUI

struct CounterView: View {
    @State var count: Int = 0
    
    var width: CGFloat = 300
    
    var body: some View {
        ZStack {
            HStack(spacing: spacing) {
                ControlButton(
                    systemName: "minus",
                    size: controlFrameSize
                ) { decrease() }
                
                ControlButton(
                    systemName: "xmark",
                    size: controlFrameSize
                ) {}
                
                ControlButton(
                    systemName: "plus",
                    size: controlFrameSize
                ) { increase() }
            }
            .padding(.horizontal, spacing)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(Color.controlsBackground)
                    .frame(width: width, height: heigth)
            )
            
            Text("\(count)")
                .foregroundColor(.white)
                .frame(width: labelSize, height: labelSize)
                .background(Color.labelBackground)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 5)
                .font(.system(size: labelFontSize, weight: .semibold, design: .rounded))
                .animation(nil)
                .contentShape(Circle())
                .onTapGesture {
                    increase()
                }
        }
    }
}

//MARK: - Control Button
struct ControlButton: View {
    var systemName: String
    var size: CGFloat
    var action: () -> Void
    
    @State private var color: Color = .controls
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(size / 3.5)
                .frame(width: size, height: size)
                .foregroundColor(.controls)
                .background(Color.white.opacity(0.0000001))
                .clipShape(Circle())
        }
        .buttonStyle(ControlButtonStyle(systemName: systemName, size: size))
        .contentShape(Circle())
    }
}

//MARK: - Control Button Style
struct ControlButtonStyle: ButtonStyle {
    var systemName: String
    var size: CGFloat
    
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .overlay(
                ZStack {
                    Circle()
                        .fill(Color.white)
                    
                    Image(systemName: systemName)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .padding(size / 3.5)
                        .foregroundColor(.controlsBackground)
                }
                .frame(width: size, height: size)
                .opacity(configuration.isPressed ? 1 : 0)
            )
            .font(.system(size: 60, weight: .thin, design: .rounded))
            .animation(Animation.linear(duration: 0.1))
        }
}

//MARK: - Computed Properties
private extension CounterView {
    var heigth: CGFloat {
        width / 2.5
    }
    
    var spacing: CGFloat {
        width / 10
    }
    
    var labelSize: CGFloat {
        width / 3
    }
    
    var labelFontSize: CGFloat {
        labelSize / 2.5
    }
    
    var controlFrameSize: CGFloat {
        width / 4.2
    }
    var radius: CGFloat {
        width / 4.9
    }
}

//MARK: - Operations
private extension CounterView {
    func decrease() {
        if self.count != 0 {
            withAnimation {
                self.count -= 1
            }
        }
    }
    
    func increase() {
        if self.count < 999 {
            withAnimation {
                self.count += 1
            }
        }
    }
    
    func reset() {
        withAnimation {
            self.count = 0
        }
    }
}

struct CounterView_Previews: PreviewProvider {
    static var previews: some View {
        VStack {
            CounterView()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color.screenBackground.edgesIgnoringSafeArea(.vertical))
    }
}
