//
//  DetailView.swift
//  Telegram_MacApp
//
//  Created by ipeerless on 02/08/2023.
//

import SwiftUI

struct DetailView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var user: RecentMessage
    var body: some View {
        HStack {
            VStack {
                HStack(spacing: 15) {
                    Text(user.userName)
                        .font(.title2)
                    Spacer()
                    Button {
                        
                    } label: {
                        Image(systemName: "magnifyingglass")
                            .font(.title2)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    Button {
                        withAnimation {
                            homeDta.isExpanded.toggle()
                        }
                    } label: {
                        Image(systemName: "sidebar.right")
                            .font(.title2)
                            .foregroundColor(homeDta.isExpanded ? .blue : .primary)
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                    
                }
                .padding()
                
                MessageView( user: user)
                
                HStack(spacing: 15) {
                    
                    Button {
                        
                    } label: {
                        Image(systemName: "paperplane")
                            .font(.title2)
                    }.buttonStyle(PlainButtonStyle())
                    
                    TextField("Enter Message", text: $homeData.message, onCommit: {
                        homeData.sendMessage(user: user)
                    })
                        .textFieldStyle(PlainTextFieldStyle())
                        .padding(.horizontal)
                        .padding(.vertical, 8)
                        .clipShape(Circle())
                        .background(Capsule().strokeBorder(Color.white))
                    Button {
                        
                    } label: {
                        Image(systemName: "face.smiling.fill")
                            .font(.title2)
                    }.buttonStyle(PlainButtonStyle())
                    Button {
                        
                    } label: {
                        Image(systemName: "mic")
                            .font(.title2)
                    }.buttonStyle(PlainButtonStyle())
                    
                    
                    
                }
                .padding([.horizontal, .bottom])
            }
            ExpandedView(user: user)
            
                .background(BlurView())
                .frame(width: homeData.isExpanded ? nil : 0)
                .opacity(homeData.isExpanded ? 1 : 0)
        }
        .ignoresSafeArea(.all, edges: .all)
    }
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        Home()
    }
}

struct MessageView: View {
    
    @EnvironmentObject var homeData: HomeViewModel
    var user: RecentMessage
    
    var body: some View {
        
        GeometryReader { reader in
            ScrollView  {
                ScrollViewReader { proxy in
                    VStack {
                        
                        ForEach(user.allMsgs) { message in
                            
                            MessageCardView(message: message, user: user, width: reader.frame(in: .global).width)
                                .tag(message.id)
                        }
                        .onAppear() {
                            let lastID = user.allMsgs.last!.id
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                        .onChange(of: user.allMsgs) {value in
                            
                            let lastID = user.allMsgs.last!.id
                            proxy.scrollTo(lastID, anchor: .bottom)
                        }
                       
                    }
                    .padding(.bottom, 30)
                }
            }
        }
    }
}

struct MessageCardView: View {
    var message: Message
    var user: RecentMessage
    var width: CGFloat
    
    var body: some View {
        HStack(spacing: 10) {
            if message.myMessage {
                Spacer()
                Text(message.message)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.blue)
                    .cornerRadius(10)
                    .frame(minWidth: 0, maxWidth: width / 2, alignment: .trailing)
            }
            else {
                
                Image(user.userImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 35, height: 35)
                    .clipShape(Circle())
                //                    .offset(y: 20)
                
                Text(message.message)
                    .foregroundColor(.white)
                    .padding(10)
                    .background(Color.primary.opacity(0.2))
                    .clipShape(MessageBubble())
                    .frame(minWidth: 0, maxWidth: width / 2, alignment: .leading)
                Spacer()
            }
        }
    }
}
struct MessageBubble: Shape {
    func path(in rect: CGRect) -> Path {
        return Path {path in
            let pt1 = CGPoint(x: 0, y: 0)
            let pt2 = CGPoint(x: rect.width, y: 0)
            let pt3 = CGPoint(x: rect.width, y: rect.height)
            let pt4 = CGPoint(x: 0, y: rect.height)
            path.move(to: pt4)
            
            path.addArc(tangent1End: pt4, tangent2End: pt1, radius: 15)
            
            path.addArc(tangent1End: pt1, tangent2End: pt1, radius: 15)
            path.addArc(tangent1End: pt2, tangent2End: pt3, radius: 15)
            path.addArc(tangent1End: pt3, tangent2End: pt4, radius: 15)
        }
    }
}

struct ExpandedView: View {
    @EnvironmentObject var homeData: HomeViewModel
    var user: RecentMessage
    
    var body: some View {
        HStack(spacing: 0) {
            Divider()
            VStack(spacing: 25) {
                Image(user.userImage)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 90, height: 90)
                    .clipShape(Circle())
                    .padding(.top, 35)
                Text(user.userName)
                    .font(.title)
                    .fontWeight(.bold)
                HStack {
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "bell.slash")
                                .font(.title2)
                            Text("Mute")
                        }
                        .contentShape(Rectangle() )
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "hand.raised.fill")
                                .font(.title2)
                            Text("Block")
                                .contentShape(Rectangle() )
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    Spacer()
                    Button {
                        
                    } label: {
                        VStack {
                            Image(systemName: "exclamationmark.triangle")
                                .font(.title2)
                            Text("Report")
                                .contentShape(Rectangle() )
                        }
                    }
                    .buttonStyle(PlainButtonStyle())
                    
                }
                .foregroundColor(.gray)
                Picker(selection: $homeData.pickedTab) {
                    Text("Picker")
                } label: {
                    Text("Media").tag("Media")
                    Text("Links").tag("Links")
                    Text("Audio").tag("Audio")
                    Text("Files").tag("Files")
                }
                .pickerStyle(SegmentedPickerStyle())
                .labelsHidden()
                .padding(.vertical)
                
                ScrollView {
                    if homeData.pickedTab == "Media" {
                        LazyVGrid(columns: Array(repeating: GridItem(.flexible(), spacing: 10 ), count: 3)) {
                            ForEach(1...8, id: \.self) { index  in
                                Image("media\(index)")
                                    .resizable()
                                    .aspectRatio(contentMode: .fill)
                                    .frame(width: 80, height: 80)
                                    .cornerRadius(3)
                            }
                        }
                    } else {
                        Text("No \(homeData.pickedTab)")
                    }
                }
            }
            .padding(.horizontal)
            .frame(maxWidth: 300)
        }
    }
    
}
