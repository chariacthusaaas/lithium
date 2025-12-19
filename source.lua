local ModernDarkUI = {}
ModernDarkUI.__index = ModernDarkUI

ModernDarkUI.Theme = {
	Primary = Color3.fromRGB(25, 25, 35),
	Secondary = Color3.fromRGB(35, 35, 50),
	Accent = Color3.fromRGB(0, 170, 255),
	Text = Color3.fromRGB(240, 240, 240),
	SubText = Color3.fromRGB(180, 180, 190),
	Success = Color3.fromRGB(85, 200, 100),
	Warning = Color3.fromRGB(255, 180, 40),
	Error = Color3.fromRGB(255, 85, 85),
	Border = Color3.fromRGB(50, 50, 65),
	Hover = Color3.fromRGB(45, 45, 60),
	Pressed = Color3.fromRGB(40, 40, 55),
}

ModernDarkUI.Font = {
	Title = Enum.Font.GothamBold,
	Heading = Enum.Font.GothamBold,
	Body = Enum.Font.Gotham,
	Code = Enum.Font.RobotoMono,
}

local function createCorner(radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, radius)
	return corner
end

local function createStroke(color, thickness)
	local stroke = Instance.new("UIStroke")
	stroke.Color = color
	stroke.Thickness = thickness
	stroke.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	return stroke
end

function ModernDarkUI:CreateScreenGui(name, parent)
	if not parent then
		parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")
	end
	
	local screenGui = Instance.new("ScreenGui")
	screenGui.Name = name or "ModernDarkUI"
	screenGui.Parent = parent
	screenGui.ResetOnSpawn = false
	screenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	
	return screenGui
end

function ModernDarkUI:CreateWindow(options)
	local options = options or {}
	local windowFrame = Instance.new("Frame")
	windowFrame.Name = options.Name or "ModernWindow"
	windowFrame.Size = options.Size or UDim2.new(0, 400, 0, 500)
	windowFrame.Position = options.Position or UDim2.new(0.5, -200, 0.5, -250)
	windowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
	windowFrame.BackgroundColor3 = self.Theme.Primary
	windowFrame.BackgroundTransparency = 0
	windowFrame.BorderSizePixel = 0
	
	windowFrame.ClipsDescendants = true
	createCorner(12).Parent = windowFrame
	createStroke(self.Theme.Border, 2).Parent = windowFrame
	
	local titleBar = Instance.new("Frame")
	titleBar.Name = "TitleBar"
	titleBar.Size = UDim2.new(1, 0, 0, 40)
	titleBar.Position = UDim2.new(0, 0, 0, 0)
	titleBar.BackgroundColor3 = self.Theme.Secondary
	titleBar.BorderSizePixel = 0
	titleBar.Parent = windowFrame
	
	createCorner(12).Parent = titleBar
	
	local dragInput, dragStart, startPos
	local function update(input)
		local delta = input.Position - dragStart
		windowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
	
	titleBar.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			dragStart = input.Position
			startPos = windowFrame.Position
			input.Changed:Connect(function()
				if input.UserInputState == Enum.UserInputState.End then
					dragStart = nil
				end
			end)
		end
	end)
	
	titleBar.InputChanged:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseMovement then
			dragInput = input
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if input == dragInput and dragStart then
			update(input)
		end
	end)
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -80, 1, 0)
	title.Position = UDim2.new(0, 15, 0, 0)
	title.BackgroundTransparency = 1
	title.Text = options.Title or "Modern Dark UI"
	title.TextColor3 = self.Theme.Text
	title.TextSize = 18
	title.Font = self.Font.Heading
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = titleBar
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 30, 0, 30)
	closeBtn.Position = UDim2.new(1, -40, 0.5, -15)
	closeBtn.AnchorPoint = Vector2.new(0, 0.5)
	closeBtn.BackgroundColor3 = self.Theme.Error
	closeBtn.Text = "×"
	closeBtn.TextColor3 = self.Theme.Text
	closeBtn.TextSize = 24
	closeBtn.Font = self.Font.Body
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = titleBar
	
	createCorner(8).Parent = closeBtn
	
	closeBtn.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(
			closeBtn,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = Color3.fromRGB(255, 120, 120)}
		):Play()
	end)
	
	closeBtn.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(
			closeBtn,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = self.Theme.Error}
		):Play()
	end)
	
	local content = Instance.new("Frame")
	content.Name = "Content"
	content.Size = UDim2.new(1, -20, 1, -60)
	content.Position = UDim2.new(0, 10, 0, 50)
	content.BackgroundTransparency = 1
	content.Parent = windowFrame
	
	local scrollFrame = Instance.new("ScrollingFrame")
	scrollFrame.Name = "ScrollFrame"
	scrollFrame.Size = UDim2.new(1, 0, 1, 0)
	scrollFrame.Position = UDim2.new(0, 0, 0, 0)
	scrollFrame.BackgroundTransparency = 1
	scrollFrame.BorderSizePixel = 0
	scrollFrame.ScrollBarImageColor3 = self.Theme.Accent
	scrollFrame.ScrollBarThickness = 5
	scrollFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
	scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
	scrollFrame.Parent = content
	
	local uiListLayout = Instance.new("UIListLayout")
	uiListLayout.Parent = scrollFrame
	uiListLayout.Padding = UDim.new(0, 10)
	uiListLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local window = {}
	window.Frame = windowFrame
	window.Elements = {
		Content = scrollFrame,
		Title = title,
		CloseButton = closeBtn
	}
	
	function window:SetTitle(newTitle)
		title.Text = newTitle
	end
	
	function window:GetContent()
		return scrollFrame
	end
	
	function window:Destroy()
		windowFrame:Destroy()
	end
	
	function window:Show()
		windowFrame.Visible = true
	end
	
	function window:Hide()
		windowFrame.Visible = false
	end
	
	setmetatable(window, {
		__index = function(self, key)
			if rawget(self, key) ~= nil then
				return rawget(self, key)
			end
			return windowFrame[key]
		end,
		__newindex = function(self, key, value)
			if key == "Parent" then
				windowFrame.Parent = value
			else
				rawset(self, key, value)
			end
		end
	})
	
	closeBtn.MouseButton1Click:Connect(function()
		windowFrame.Visible = false
	end)
	
	return window
end

function ModernDarkUI:CreateButton(options, parent)
	local options = options or {}
	local button = Instance.new("TextButton")
	button.Name = options.Name or "ModernButton"
	button.Size = options.Size or UDim2.new(1, 0, 0, 40)
	button.BackgroundColor3 = self.Theme.Secondary
	button.Text = options.Text or "Button"
	button.TextColor3 = self.Theme.Text
	button.TextSize = 14
	button.Font = self.Font.Body
	button.AutoButtonColor = false
	button.Parent = parent
	
	createCorner(8).Parent = button
	createStroke(self.Theme.Border, 1).Parent = button
	
	button.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(
			button,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = self.Theme.Hover}
		):Play()
	end)
	
	button.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(
			button,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = self.Theme.Secondary}
		):Play()
	end)
	
	button.MouseButton1Down:Connect(function()
		game:GetService("TweenService"):Create(
			button,
			TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = self.Theme.Pressed}
		):Play()
	end)
	
	button.MouseButton1Up:Connect(function()
		game:GetService("TweenService"):Create(
			button,
			TweenInfo.new(0.1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = self.Theme.Hover}
		):Play()
	end)
	
	if options.Callback then
		button.MouseButton1Click:Connect(options.Callback)
	end
	
	return button
end

function ModernDarkUI:CreateLabel(options, parent)
	local options = options or {}
	local label = Instance.new("TextLabel")
	label.Name = options.Name or "ModernLabel"
	label.Size = options.Size or UDim2.new(1, 0, 0, 30)
	label.BackgroundTransparency = 1
	label.Text = options.Text or "Label"
	label.TextColor3 = options.TextColor3 or self.Theme.Text
	label.TextSize = options.TextSize or 14
	label.Font = options.Font or self.Font.Body
	label.TextXAlignment = options.Alignment or Enum.TextXAlignment.Left
	label.TextWrapped = true
	label.Parent = parent
	
	return label
end

function ModernDarkUI:CreateTextBox(options, parent)
	local options = options or {}
	local textBox = Instance.new("TextBox")
	textBox.Name = options.Name or "ModernTextBox"
	textBox.Size = options.Size or UDim2.new(1, 0, 0, 40)
	textBox.BackgroundColor3 = self.Theme.Secondary
	textBox.PlaceholderText = options.Placeholder or "Enter text..."
	textBox.PlaceholderColor3 = self.Theme.SubText
	textBox.Text = options.Text or ""
	textBox.TextColor3 = self.Theme.Text
	textBox.TextSize = 14
	textBox.Font = self.Font.Body
	textBox.ClearTextOnFocus = options.ClearOnFocus or false
	textBox.Parent = parent
	
	createCorner(8).Parent = textBox
	createStroke(self.Theme.Border, 1).Parent = textBox
	
	textBox.Focused:Connect(function()
		game:GetService("TweenService"):Create(
			textBox,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = self.Theme.Hover}
		):Play()
		
		game:GetService("TweenService"):Create(
			textBox.UIStroke,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Color = self.Theme.Accent}
		):Play()
	end)
	
	textBox.FocusLost:Connect(function()
		game:GetService("TweenService"):Create(
			textBox,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = self.Theme.Secondary}
		):Play()
		
		game:GetService("TweenService"):Create(
			textBox.UIStroke,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Color = self.Theme.Border}
		):Play()
		
		if options.Callback then
			options.Callback(textBox.Text)
		end
	end)
	
	return textBox
end

function ModernDarkUI:CreateToggle(options, parent)
	local options = options or {}
	local toggleFrame = Instance.new("Frame")
	toggleFrame.Name = options.Name or "ModernToggle"
	toggleFrame.Size = options.Size or UDim2.new(1, 0, 0, 30)
	toggleFrame.BackgroundTransparency = 1
	toggleFrame.Parent = parent
	
	local toggleButton = Instance.new("TextButton")
	toggleButton.Name = "ToggleButton"
	toggleButton.Size = UDim2.new(0, 50, 0, 25)
	toggleButton.Position = UDim2.new(1, -50, 0.5, -12.5)
	toggleButton.AnchorPoint = Vector2.new(1, 0.5)
	toggleButton.BackgroundColor3 = self.Theme.Secondary
	toggleButton.Text = ""
	toggleButton.AutoButtonColor = false
	toggleButton.Parent = toggleFrame
	
	createCorner(12).Parent = toggleButton
	createStroke(self.Theme.Border, 1).Parent = toggleButton
	
	local toggleCircle = Instance.new("Frame")
	toggleCircle.Name = "ToggleCircle"
	toggleCircle.Size = UDim2.new(0, 19, 0, 19)
	toggleCircle.Position = UDim2.new(0, 3, 0.5, -9.5)
	toggleCircle.AnchorPoint = Vector2.new(0, 0.5)
	toggleCircle.BackgroundColor3 = self.Theme.Text
	toggleCircle.Parent = toggleButton
	
	createCorner(9).Parent = toggleCircle
	
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, -60, 1, 0)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = options.Text or "Toggle"
	label.TextColor3 = self.Theme.Text
	label.TextSize = 14
	label.Font = self.Font.Body
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = toggleFrame
	
	local state = options.Default or false
	
	local function updateToggle()
		if state then
			game:GetService("TweenService"):Create(
				toggleButton,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = self.Theme.Accent}
			):Play()
			
			game:GetService("TweenService"):Create(
				toggleCircle,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Position = UDim2.new(1, -22, 0.5, -9.5)}
			):Play()
		else
			game:GetService("TweenService"):Create(
				toggleButton,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = self.Theme.Secondary}
			):Play()
			
			game:GetService("TweenService"):Create(
				toggleCircle,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Position = UDim2.new(0, 3, 0.5, -9.5)}
			):Play()
		end
		
		if options.Callback then
			options.Callback(state)
		end
	end
	
	updateToggle()
	
	toggleButton.MouseButton1Click:Connect(function()
		state = not state
		updateToggle()
	end)
	
	function toggleFrame:SetState(newState)
		state = newState
		updateToggle()
	end
	
	function toggleFrame:GetState()
		return state
	end
	
	function toggleFrame:Toggle()
		state = not state
		updateToggle()
	end
	
	return toggleFrame
end

function ModernDarkUI:CreateSlider(options, parent)
	local options = options or {}
	local sliderFrame = Instance.new("Frame")
	sliderFrame.Name = options.Name or "ModernSlider"
	sliderFrame.Size = options.Size or UDim2.new(1, 0, 0, 60)
	sliderFrame.BackgroundTransparency = 1
	sliderFrame.Parent = parent
	
	local label = Instance.new("TextLabel")
	label.Name = "Label"
	label.Size = UDim2.new(1, 0, 0, 20)
	label.Position = UDim2.new(0, 0, 0, 0)
	label.BackgroundTransparency = 1
	label.Text = options.Text or "Slider"
	label.TextColor3 = self.Theme.Text
	label.TextSize = 14
	label.Font = self.Font.Body
	label.TextXAlignment = Enum.TextXAlignment.Left
	label.Parent = sliderFrame
	
	local valueLabel = Instance.new("TextLabel")
	valueLabel.Name = "ValueLabel"
	valueLabel.Size = UDim2.new(0, 60, 0, 20)
	valueLabel.Position = UDim2.new(1, -60, 0, 0)
	valueLabel.AnchorPoint = Vector2.new(1, 0)
	valueLabel.BackgroundTransparency = 1
	valueLabel.Text = tostring(options.Default or options.Min or 0)
	valueLabel.TextColor3 = self.Theme.SubText
	valueLabel.TextSize = 14
	valueLabel.Font = self.Font.Body
	valueLabel.TextXAlignment = Enum.TextXAlignment.Right
	valueLabel.Parent = sliderFrame
	
	local sliderTrack = Instance.new("Frame")
	sliderTrack.Name = "Track"
	sliderTrack.Size = UDim2.new(1, 0, 0, 6)
	sliderTrack.Position = UDim2.new(0, 0, 0, 30)
	sliderTrack.BackgroundColor3 = self.Theme.Secondary
	sliderTrack.Parent = sliderFrame
	
	createCorner(3).Parent = sliderTrack
	createStroke(self.Theme.Border, 1).Parent = sliderTrack
	
	local sliderFill = Instance.new("Frame")
	sliderFill.Name = "Fill"
	sliderFill.Size = UDim2.new(0, 0, 1, 0)
	sliderFill.Position = UDim2.new(0, 0, 0, 0)
	sliderFill.BackgroundColor3 = self.Theme.Accent
	sliderFill.Parent = sliderTrack
	
	createCorner(3).Parent = sliderFill
	
	local sliderButton = Instance.new("TextButton")
	sliderButton.Name = "SliderButton"
	sliderButton.Size = UDim2.new(0, 20, 0, 20)
	sliderButton.Position = UDim2.new(0, -10, 0.5, -10)
	sliderButton.AnchorPoint = Vector2.new(0, 0.5)
	sliderButton.BackgroundColor3 = self.Theme.Text
	sliderButton.Text = ""
	sliderButton.AutoButtonColor = false
	sliderButton.Parent = sliderTrack
	
	createCorner(10).Parent = sliderButton
	
	local min = options.Min or 0
	local max = options.Max or 100
	local default = options.Default or min
	local step = options.Step or 1
	local value = default
	
	local function roundToStep(num)
		return math.floor((num - min) / step + 0.5) * step + min
	end
	
	local function updateSlider(percentage)
		percentage = math.clamp(percentage, 0, 1)
		value = roundToStep(min + (max - min) * percentage)
		
		sliderFill.Size = UDim2.new(percentage, 0, 1, 0)
		sliderButton.Position = UDim2.new(percentage, -10, 0.5, -10)
		valueLabel.Text = tostring(value)
		
		if options.Callback then
			options.Callback(value)
		end
	end
	
	updateSlider((default - min) / (max - min))
	
	local dragging = false
	
	local function updateFromMouse()
		local mouse = game:GetService("Players").LocalPlayer:GetMouse()
		local trackAbsolutePos = sliderTrack.AbsolutePosition
		local trackAbsoluteSize = sliderTrack.AbsoluteSize
		
		local relativeX = (mouse.X - trackAbsolutePos.X) / trackAbsoluteSize.X
		updateSlider(relativeX)
	end
	
	sliderButton.MouseButton1Down:Connect(function()
		dragging = true
		
		game:GetService("TweenService"):Create(
			sliderButton,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{Size = UDim2.new(0, 24, 0, 24)}
		):Play()
		
		updateFromMouse()
	end)
	
	game:GetService("UserInputService").InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			if dragging then
				dragging = false
				
				game:GetService("TweenService"):Create(
					sliderButton,
					TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Size = UDim2.new(0, 20, 0, 20)}
				):Play()
			end
		end
	end)
	
	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateFromMouse()
		end
	end)
	
	sliderTrack.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			updateFromMouse()
		end
	end)
	
	function sliderFrame:SetValue(newValue)
		newValue = math.clamp(newValue, min, max)
		updateSlider((newValue - min) / (max - min))
	end
	
	function sliderFrame:GetValue()
		return value
	end
	
	return sliderFrame
end

function ModernDarkUI:CreateDropdown(options, parent)
	local options = options or {}
	local dropdownFrame = Instance.new("Frame")
	dropdownFrame.Name = options.Name or "ModernDropdown"
	dropdownFrame.Size = options.Size or UDim2.new(1, 0, 0, 40)
	dropdownFrame.BackgroundTransparency = 1
	dropdownFrame.ClipsDescendants = true
	dropdownFrame.Parent = parent
	
	local dropdownButton = Instance.new("TextButton")
	dropdownButton.Name = "DropdownButton"
	dropdownButton.Size = UDim2.new(1, 0, 0, 40)
	dropdownButton.Position = UDim2.new(0, 0, 0, 0)
	dropdownButton.BackgroundColor3 = self.Theme.Secondary
	dropdownButton.Text = options.Text or "Select..."
	dropdownButton.TextColor3 = self.Theme.Text
	dropdownButton.TextSize = 14
	dropdownButton.Font = self.Font.Body
	dropdownButton.TextXAlignment = Enum.TextXAlignment.Left
	dropdownButton.AutoButtonColor = false
	dropdownButton.Parent = dropdownFrame
	
	createCorner(8).Parent = dropdownButton
	createStroke(self.Theme.Border, 1).Parent = dropdownButton
	
	local dropdownIcon = Instance.new("TextLabel")
	dropdownIcon.Name = "Icon"
	dropdownIcon.Size = UDim2.new(0, 20, 0, 20)
	dropdownIcon.Position = UDim2.new(1, -30, 0.5, -10)
	dropdownIcon.AnchorPoint = Vector2.new(1, 0.5)
	dropdownIcon.BackgroundTransparency = 1
	dropdownIcon.Text = "▼"
	dropdownIcon.TextColor3 = self.Theme.SubText
	dropdownIcon.TextSize = 12
	dropdownIcon.Font = self.Font.Body
	dropdownIcon.Parent = dropdownButton
	
	local dropdownList = Instance.new("ScrollingFrame")
	dropdownList.Name = "DropdownList"
	dropdownList.Size = UDim2.new(1, 0, 0, 0)
	dropdownList.Position = UDim2.new(0, 0, 0, 45)
	dropdownList.BackgroundColor3 = self.Theme.Secondary
	dropdownList.BorderSizePixel = 0
	dropdownList.ScrollBarImageColor3 = self.Theme.Accent
	dropdownList.ScrollBarThickness = 5
	dropdownList.AutomaticCanvasSize = Enum.AutomaticSize.Y
	dropdownList.CanvasSize = UDim2.new(0, 0, 0, 0)
	dropdownList.Visible = false
	dropdownList.Parent = dropdownFrame
	
	createCorner(8).Parent = dropdownList
	createStroke(self.Theme.Border, 1).Parent = dropdownList
	
	local listLayout = Instance.new("UIListLayout")
	listLayout.Parent = dropdownList
	listLayout.Padding = UDim.new(0, 2)
	listLayout.SortOrder = Enum.SortOrder.LayoutOrder
	
	local items = options.Items or {}
	local selected = options.Default
	local isOpen = false
	
	local function toggleDropdown()
		isOpen = not isOpen
		
		if isOpen then
			dropdownList.Visible = true
			game:GetService("TweenService"):Create(
				dropdownList,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Size = UDim2.new(1, 0, 0, math.min(#items * 35, 150))}
			):Play()
			
			game:GetService("TweenService"):Create(
				dropdownIcon,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Rotation = 180}
			):Play()
		else
			game:GetService("TweenService"):Create(
				dropdownList,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Size = UDim2.new(1, 0, 0, 0)}
			):Play()
			
			game:GetService("TweenService"):Create(
				dropdownIcon,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{Rotation = 0}
			):Play()
			
			wait(0.2)
			dropdownList.Visible = false
		end
	end
	
	local function selectItem(itemText)
		dropdownButton.Text = itemText
		selected = itemText
		toggleDropdown()
		
		if options.Callback then
			options.Callback(itemText)
		end
	end
	
	for i, item in ipairs(items) do
		local itemButton = Instance.new("TextButton")
		itemButton.Name = "Item_" .. i
		itemButton.Size = UDim2.new(1, -10, 0, 30)
		itemButton.Position = UDim2.new(0, 5, 0, (i-1)*35)
		itemButton.BackgroundColor3 = self.Theme.Primary
		itemButton.Text = item
		itemButton.TextColor3 = self.Theme.Text
		itemButton.TextSize = 14
		itemButton.Font = self.Font.Body
		itemButton.AutoButtonColor = false
		itemButton.Parent = dropdownList
		
		createCorner(6).Parent = itemButton
		
		itemButton.MouseEnter:Connect(function()
			game:GetService("TweenService"):Create(
				itemButton,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = self.Theme.Hover}
			):Play()
		end)
		
		itemButton.MouseLeave:Connect(function()
			game:GetService("TweenService"):Create(
				itemButton,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = self.Theme.Primary}
			):Play()
		end)
		
		itemButton.MouseButton1Click:Connect(function()
			selectItem(item)
		end)
	end
	
	dropdownButton.MouseButton1Click:Connect(toggleDropdown)
	
	game:GetService("UserInputService").InputBegan:Connect(function(input)
		if isOpen and input.UserInputType == Enum.UserInputType.MouseButton1 then
			local mousePos = game:GetService("Players").LocalPlayer:GetMouse()
			if not dropdownFrame:IsDescendantOf(mousePos.Target) then
				toggleDropdown()
			end
		end
	end)
	
	dropdownButton.MouseEnter:Connect(function()
		if not isOpen then
			game:GetService("TweenService"):Create(
				dropdownButton,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = self.Theme.Hover}
			):Play()
		end
	end)
	
	dropdownButton.MouseLeave:Connect(function()
		if not isOpen then
			game:GetService("TweenService"):Create(
				dropdownButton,
				TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
				{BackgroundColor3 = self.Theme.Secondary}
			):Play()
		end
	end)
	
	function dropdownFrame:SetItems(newItems)
		items = newItems
		
		for _, child in ipairs(dropdownList:GetChildren()) do
			if child:IsA("TextButton") then
				child:Destroy()
			end
		end
		
		for i, item in ipairs(items) do
			local itemButton = Instance.new("TextButton")
			itemButton.Name = "Item_" .. i
			itemButton.Size = UDim2.new(1, -10, 0, 30)
			itemButton.Position = UDim2.new(0, 5, 0, (i-1)*35)
			itemButton.BackgroundColor3 = self.Theme.Primary
			itemButton.Text = item
			itemButton.TextColor3 = self.Theme.Text
			itemButton.TextSize = 14
			itemButton.Font = self.Font.Body
			itemButton.AutoButtonColor = false
			itemButton.Parent = dropdownList
			
			createCorner(6).Parent = itemButton
			
			itemButton.MouseButton1Click:Connect(function()
				selectItem(item)
			end)
		end
	end
	
	function dropdownFrame:GetSelected()
		return selected
	end
	
	function dropdownFrame:SetSelected(item)
		if table.find(items, item) then
			selectItem(item)
		end
	end
	
	return dropdownFrame
end

function ModernDarkUI:CreateNotification(options, parent)
	local options = options or {}
	local notification = Instance.new("Frame")
	notification.Name = "ModernNotification"
	notification.Size = UDim2.new(0, 300, 0, 80)
	notification.Position = UDim2.new(1, -320, 1, -100)
	notification.BackgroundColor3 = self.Theme.Primary
	notification.BorderSizePixel = 0
	notification.Parent = parent
	
	createCorner(8).Parent = notification
	createStroke(self.Theme.Border, 2).Parent = notification
	
	local title = Instance.new("TextLabel")
	title.Name = "Title"
	title.Size = UDim2.new(1, -20, 0, 25)
	title.Position = UDim2.new(0, 10, 0, 10)
	title.BackgroundTransparency = 1
	title.Text = options.Title or "Notification"
	title.TextColor3 = self.Theme.Text
	title.TextSize = 16
	title.Font = self.Font.Heading
	title.TextXAlignment = Enum.TextXAlignment.Left
	title.Parent = notification
	
	local message = Instance.new("TextLabel")
	message.Name = "Message"
	message.Size = UDim2.new(1, -20, 1, -45)
	message.Position = UDim2.new(0, 10, 0, 35)
	message.BackgroundTransparency = 1
	message.Text = options.Message or "This is a notification message."
	message.TextColor3 = self.Theme.SubText
	message.TextSize = 14
	message.Font = self.Font.Body
	message.TextXAlignment = Enum.TextXAlignment.Left
	message.TextYAlignment = Enum.TextYAlignment.Top
	message.TextWrapped = true
	message.Parent = notification
	
	local closeBtn = Instance.new("TextButton")
	closeBtn.Name = "CloseButton"
	closeBtn.Size = UDim2.new(0, 20, 0, 20)
	closeBtn.Position = UDim2.new(1, -25, 0, 10)
	closeBtn.AnchorPoint = Vector2.new(1, 0)
	closeBtn.BackgroundColor3 = self.Theme.Secondary
	closeBtn.Text = "×"
	closeBtn.TextColor3 = self.Theme.Text
	closeBtn.TextSize = 18
	closeBtn.Font = self.Font.Body
	closeBtn.AutoButtonColor = false
	closeBtn.Parent = notification
	
	createCorner(4).Parent = closeBtn
	
	local typeColor = self.Theme.Accent
	if options.Type == "success" then
		typeColor = self.Theme.Success
	elseif options.Type == "warning" then
		typeColor = self.Theme.Warning
	elseif options.Type == "error" then
		typeColor = self.Theme.Error
	end
	
	local typeIndicator = Instance.new("Frame")
	typeIndicator.Name = "TypeIndicator"
	typeIndicator.Size = UDim2.new(0, 4, 1, 0)
	typeIndicator.Position = UDim2.new(0, 0, 0, 0)
	typeIndicator.BackgroundColor3 = typeColor
	typeIndicator.BorderSizePixel = 0
	typeIndicator.Parent = notification
	
	closeBtn.MouseEnter:Connect(function()
		game:GetService("TweenService"):Create(
			closeBtn,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = self.Theme.Hover}
		):Play()
	end)
	
	closeBtn.MouseLeave:Connect(function()
		game:GetService("TweenService"):Create(
			closeBtn,
			TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
			{BackgroundColor3 = self.Theme.Secondary}
		):Play()
	end)
	
	closeBtn.MouseButton1Click:Connect(function()
		notification:Destroy()
	end)
	
	if options.Duration then
		task.delay(options.Duration, function()
			if notification and notification.Parent then
				game:GetService("TweenService"):Create(
					notification,
					TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
					{Position = UDim2.new(1, -320, 1, 100)}
				):Play()
				
				wait(0.3)
				notification:Destroy()
			end
		end)
	end
	
	return notification
end

function ModernDarkUI.LoadFromGitHub(url)
	return loadstring(game:HttpGet(url))()
end

return ModernDarkUI
