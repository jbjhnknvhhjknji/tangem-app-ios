//
//  IconView.swift
//  Tangem
//
//  Created by Sergey Balashov on 22.11.2022.
//  Copyright © 2022 Tangem AG. All rights reserved.
//

import SwiftUI
import Kingfisher

struct IconView: View {
    private let url: URL?
    private let size: CGSize

    // TODO: HACK - figure out why CachedAsyncImage is making Manage Tokens screen jump
    // TODO: on 16.2 on the first run of the first time this screen is opened
    private let forceKingfisher: Bool

    init(url: URL?, size: CGSize, forceKingfisher: Bool = false) {
        self.url = url
        self.size = size
        self.forceKingfisher = forceKingfisher
    }

    init(url: URL?, sizeSettings: IconViewSizeSettings, forceKingfisher: Bool = false) {
        self.init(url: url, size: sizeSettings.iconSize, forceKingfisher: forceKingfisher)
    }

    var body: some View {
        if forceKingfisher {
            kfImage
        } else if #available(iOS 15.0, *) {
            cachedAsyncImage
        } else {
            kfImage
        }
    }

    @available(iOS 15.0, *)
    var cachedAsyncImage: some View {
        CachedAsyncImage(url: url, scale: UIScreen.main.scale) { phase in
            switch phase {
            case .empty:
                placeholder
            case .success(let image):
                image
                    .resizable()
                    .scaledToFit()
                    .frame(size: size)
                    .cornerRadiusContinuous(5)
            case .failure:
                Circle()
                    .fill(Color.clear)
                    .frame(size: size)
                    .overlay(
                        Circle()
                            .stroke(Colors.Icon.informative, lineWidth: 1)
                    )
                    .cornerRadius(size.height / 2)
            @unknown default:
                EmptyView()
            }
        }
    }

    var kfImage: some View {
        KFImage(url)
            .cancelOnDisappear(true)
            .placeholder { CircleImageTextView(name: "", color: .tangemSkeletonGray) }
            .fade(duration: 0.3)
            .cacheOriginalImage()
            .resizable()
            .scaledToFit()
            .frame(size: size)
            .cornerRadiusContinuous(5)
    }

    private var placeholder: some View {
        SkeletonView()
            .frame(size: size)
            .cornerRadius(size.height / 2)
    }
}

struct IconView_Preview: PreviewProvider {
    static var previews: some View {
        IconView(
            url: TokenIconURLBuilder().iconURL(id: "arbitrum-one", size: .small),
            size: CGSize(width: 40, height: 40)
        )
    }
}
