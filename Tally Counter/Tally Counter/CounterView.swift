//
//  CounterView.swift
//  Tally Counter
//
//  Created by  Vladyslav Fil on 29.09.2021.
//

import SwiftUI

struct CounterView: View {
    private enum Direction {
        case none, left, right, down
    }
    var width: CGFloat = 300
    
    @State var count: Int = 0
    @State private var labelOffset: CGSize = .zero
    @State private var draggingDirection: Direction = .none
    
    var body: some View {
        let dragGesture = DragGesture()
                    .onChanged { value in
                        if self.draggingDirection == .none {
                            if value.translation.height <= 30 {
                                if value.translation.width > 0 {
                                    self.draggingDirection = .right
                                } else if value.translation.width < 0 {
                                    self.draggingDirection = .left
                                }
                            } else {
                                self.draggingDirection = .down
                            }
                        }
                        
                        let widthLimit = width / 3 + spacing
                        let heightLimit = heigth / 1.2
                        
                        var newWidth = value.translation.width * 0.75
                        var newHeight = value.translation.height * 0.75
                        
                        if self.labelOffset.width >= widthLimit {
                            newWidth = widthLimit
                        } else if self.labelOffset.width <= -widthLimit {
                            newWidth = -widthLimit
                        }
                        
                        if self.labelOffset.height >= heightLimit {
                            newHeight = heightLimit
                        } else if value.translation.height < 0 {
                            newHeight = 0
                        }
                        
                        withAnimation {
                            self.labelOffset = .init(
                                width: self.draggingDirection == .down ? 0 : newWidth,
                                height: self.draggingDirection == .down ? newHeight : 0
                            )
                        }
                    }
                    .onEnded { _ in
                        if draggingDirection == .right {
                            self.increase()
                        } else if draggingDirection == .left {
                            self.decrease()
                        } else if draggingDirection == .down {
                            self.reset()
                        }
                        
                        withAnimation(.interpolatingSpring(stiffness: 350, damping: 20)) {
                            self.labelOffset = .zero
                            self.draggingDirection = .none
                        }
                    }
        
        return ZStack {
            HStack(spacing: spacing) {
                ControlButton(
                    systemName: "minus",
                    size: controlFrameSize,
                    opacity: 1 - controlsOpacity,
                    action: decrease
                )
                
                ControlButton(
                    systemName: "xmark",
                    size: controlFrameSize,
                    opacity: controlsOpacity
                )
                .allowsHitTesting(false)
                
                ControlButton(
                    systemName: "plus",
                    size: controlFrameSize,
                    opacity: 1 - controlsOpacity,
                    action: increase
                )
            }
            .padding(.horizontal, spacing)
            .background(
                RoundedRectangle(cornerRadius: radius)
                    .fill(Color.controlsBackground)
                    .frame(width: width, height: heigth)
            )
            .offset(viewOffset)
            .animation(.interpolatingSpring(stiffness: 350, damping: 25))
            
            Text("\(count)")
                .foregroundColor(.white)
                .frame(width: labelSize, height: labelSize)
                .background(Color.labelBackground)
                .clipShape(Circle())
                .shadow(color: .black.opacity(0.5), radius: 3, x: 0, y: 5)
                .font(.system(size: labelFontSize, weight: .semibold, design: .rounded))
                .contentShape(Circle())
                .offset(self.labelOffset)
                .onTapGesture {
                    increase()
                }
                .gesture(dragGesture)
        }
    }
}

//MARK: - Control Button
struct ControlButton: View {
    var systemName: String
    var size: CGFloat
    var opacity: Double
    var action: () -> Void = {}
    
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
        .opacity(opacity)
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
    
    private var viewOffset: CGSize {
        .init(
            width: labelOffset.width / 6,
            height: labelOffset.height / 6
        )
    }
    
    var controlsOpacity: Double {
        Double(labelOffset.height) / Double((heigth / 1.2))
    }
}

//MARK: - Operations
private extension CounterView {
    func decrease() {
        if self.count != 0 {
            self.count -= 1
        }
    }
    
    func increase() {
        if self.count < 999 {
            self.count += 1
        }
    }
    
    func reset() {
        self.count = 0
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
