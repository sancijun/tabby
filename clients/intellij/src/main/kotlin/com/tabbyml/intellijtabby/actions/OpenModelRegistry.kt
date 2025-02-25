package com.tabbyml.intellijtabby.actions

import com.intellij.ide.BrowserUtil
import com.intellij.openapi.actionSystem.AnAction
import com.intellij.openapi.actionSystem.AnActionEvent

class OpenModelRegistry : AnAction() {
  override fun actionPerformed(e: AnActionEvent) {
    BrowserUtil.browse("https://confluence.shopee.io/pages/viewpage.action?pageId=2652461550")
  }
}