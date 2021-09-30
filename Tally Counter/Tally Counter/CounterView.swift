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
    var controlsContainerWidth: CGFloat = 300
    
    @State var count: Int = 0
    @State private var labelOffset: CGSize = .zero
    @State private var draggingDirection: Direction = .none
    
    var body: some View {
        let dragGesture = DragGesture()
                    .onChanged { value in
                        findDirection(translation: value.translation)
                        
                        var newWidth = value.translation.width * 0.75
                        var newHeight = value.translation.height * 0.75
                        
                        if self.labelOffset.width >= labelOffsetXLimit {
                            newWidth = labelOffsetXLimit
                        } else if self.labelOffset.width <= -labelOffsetXLimit {
                            newWidth = -labelOffsetXLimit
                        }
                        
                        if self.labelOffset.height >= labelOffsetYLimit {
                            newHeight = labelOffsetYLimit
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
                    isActive: draggingDirection == .left,
                    opacity: leftControlOpacity,
                    action: decrease
                )
                
                ControlButton(
                    systemName: "xmark",
                    size: controlFrameSize,
                    isActive: draggingDirection == .down,
                    opacity: controlsOpacity
                )
                .allowsHitTesting(false)
                
                ControlButton(
                    systemName: "plus",
                    size: controlFrameSize,
                    isActive: draggingDirection == .right,
                    opacity: rightControlOpacity,
                    action: increase
                )
            }
            .padding(.horizontal, spacing)
            .background(
                RoundedRectangle(cornerRadius: controlsContainerRadius)
                    .fill(Color.controlsBackground)
                    .frame(width: controlsContainerWidth, height: controlsContainerHeigth)
            )
            .offset(controlsContainerOffset)
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
    var isActive: Bool
    var opacity: Double
    var action: () -> Void = {}
    
    var body: some View {
        Button(action: action) {
            Image(systemName: systemName)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .padding(size / 3.5)
                .frame(width: size, height: size)
                .foregroundColor(Color.white.opacity(opacity))
                .background(Color.white.opacity(0.0000001))
                .clipShape(Circle())
        }
        .buttonStyle(ControlButtonStyle(systemName: systemName, size: size))
        .contentShape(Circle())
    }
}

//MARK: - Computed Properties
private extension CounterView {
    var spacing: CGFloat { controlsContainerWidth / 10 }
    
    var controlsContainerHeigth: CGFloat { controlsContainerWidth / 2.5 }
    var controlsContainerRadius: CGFloat { controlsContainerWidth / 4.9 }
    var controlsContainerOffset: CGSize {
        .init(
            width: labelOffset.width / 6,
            height: labelOffset.height / 6
        )
    }
    var controlsOpacity: Double {
        Double(labelOffset.height) / Double((controlsContainerHeigth / 1.2))
    }
    
    var controlFrameSize: CGFloat { controlsContainerWidth / 4.2 }
    var leftControlOpacity: Double {
        labelOffset.width < 0 ? -Double(labelOffset.width / (labelOffsetXLimit * 0.65)) + 0.4 : 0.4 - controlsOpacity
    }
    var rightControlOpacity: Double {
        labelOffset.width > 0 ? Double(labelOffset.width / (labelOffsetXLimit * 0.65)) + 0.4 : 0.4 - controlsOpacity
    }
    
    var labelSize: CGFloat { controlsContainerWidth / 3 }
    var labelFontSize: CGFloat { labelSize / 2.5 }
    var labelOffsetXLimit: CGFloat { controlsContainerWidth / 3 + spacing }
    var labelOffsetYLimit: CGFloat { controlsContainerHeigth / 1.2 }
}

//MARK: - Helper methods
private extension CounterView {
    private func findDirection(translation: CGSize) {
        withAnimation {
            if self.draggingDirection == .none {
                if translation.height <= 30 {
                    if translation.width > 0 {
                        self.draggingDirection = .right
                    } else if translation.width < 0 {
                        self.draggingDirection = .left
                    }
                } else {
                    self.draggingDirection = .down
                }
            }
        }
    }
}

//MARK: - Operations
private extension CounterView {
    func decrease() {
        if self.count != 0 { self.count -= 1 }
    }
    func increase() {
        if self.count < 999 { self.count += 1 }
    }
    func reset() { self.count = 0 }
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
