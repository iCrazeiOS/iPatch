//
//  RootView.swift
//  iPatch
//
//  Created by Eamon Tracey.
//

import SwiftUI

struct RootView: View {
    @StateObject private var vm = RootViewModel()
    
    var body: some View {
        VStack(alignment: .leading) {
            Header()
            Spacer()
            HStack {
                FilePickerButton("DEB/Dylib", selection: $vm.debOrDylibURL, extensions: ["deb", "dylib"])
                URLText(url: vm.debOrDylibURL)
            }
            HStack {
                FilePickerButton("IPA", selection: $vm.ipaURL, extensions: ["ipa"])
                URLText(url: vm.ipaURL)
                    .offset(x: 40)
            }
            // SwiftUI only lets you have 10 'things' in a stack, so I combined these into one
            // Tried using Group, but that caused some weird error
            // Idk why this happens, I hate Swift(UI) :)
            // Seems to work/look fine so who cares
            VStack {
                HStack {
                    Text("Custom Display Name")
                    TextField("", text: $vm.displayName)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
                
                HStack {
                    Text("Custom Bundle ID")
                    TextField("", text: $vm.bundleID)
                        .textFieldStyle(RoundedBorderTextFieldStyle())
                }
            }
            HStack {
                Toggle("Inject Substrate", isOn: $vm.injectSubstrate)
                Image(systemName: "info.circle")
                    .onTapGesture { vm.substratePopoverPresented = true }
                    .popover(isPresented: $vm.substratePopoverPresented) { SubstrateInfo() }
            }
            Spacer()
            HStack {
                Spacer()
                Button("Patch", action: vm.patch)
                    .disabled(!vm.readyToPatch)
                    .buttonStyle(PatchButtonStyle())
                Spacer()
            }
            Spacer()
            Text("Eamon Tracey © 2022")
        }
        .padding()
        .onDrop(of: [.fileURL], isTargeted: .none) { providers in vm.handleDrop(of: providers) }
        .onChange(of: vm.ipaURL) { _ in vm.ipaURLDidChange() }
        .sheet(isPresented: $vm.isPatching) { PatchingProgressView() }
    }
}
