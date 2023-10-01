class Window: TreeNode, Hashable {
    let windowId: UInt32
    override var parent: TreeNode { super.parent ?? errorT("Windows always have parent") }
    var parentOrNilForTests: TreeNode? { super.parent }

    init(id: UInt32, parent: TreeNode, adaptiveWeight: CGFloat) {
        self.windowId = id
        super.init(parent: parent, adaptiveWeight: adaptiveWeight)
    }

    func hash(into hasher: inout Hasher) {
        hasher.combine(windowId)
    }

    var title: String? { error("Not implemented") }

    func setSize(_ size: CGSize) { error("Not implemented") }

    func setTopLeftCorner(_ point: CGPoint) { error("Not implemented") }
}

extension Window {
    var isFloating: Bool { parent is Workspace }

    @discardableResult
    func bindAsFloatingWindowTo(workspace: Workspace) -> PreviousBindingData? {
        parent != workspace ? bindTo(parent: workspace, adaptiveWeight: WEIGHT_AUTO) : nil
    }

    var ownIndex: Int { parent.children.firstIndex(of: self)! }
}