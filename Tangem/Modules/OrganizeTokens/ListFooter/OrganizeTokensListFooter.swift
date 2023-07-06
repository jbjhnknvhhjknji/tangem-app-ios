//
//  OrganizeTokensListFooter.swift
//  Tangem
//
//  Created by Andrey Fedorov on 21.06.2023.
//  Copyright © 2023 Tangem AG. All rights reserved.
//

import SwiftUI

struct OrganizeTokensListFooter: View {
    let viewModel: OrganizeTokensViewModel
    let tokenListFooterFrameMinY: Binding<CGFloat>
    let scrollViewBottomContentInset: Binding<CGFloat>
    let isTokenListFooterGradientHidden: Bool
    let cornerRadius: CGFloat
    let contentHorizontalInset: CGFloat
    let overlayViewAdditionalVerticalInset: CGFloat

    var body: some View {
        HStack(spacing: 8.0) {
            Group {
                MainButton(
                    title: Localization.commonCancel,
                    style: .secondary,
                    action: viewModel.onCancelButtonTap
                )

                MainButton(
                    title: Localization.commonApply,
                    style: .primary,
                    action: viewModel.onApplyButtonTap
                )
            }
            .background(
                Colors.Background
                    .primary
                    .cornerRadiusContinuous(cornerRadius)
            )
        }
        .padding(.horizontal, contentHorizontalInset)
        .background(OrganizeTokensListFooterOverlayView().hidden(isTokenListFooterGradientHidden))
        .readGeometry { geometryInfo in
            tokenListFooterFrameMinY.wrappedValue = geometryInfo.frame.minY
            scrollViewBottomContentInset.wrappedValue = geometryInfo.size.height + overlayViewAdditionalVerticalInset
        }
        .infinityFrame(alignment: .bottom)
    }
}
