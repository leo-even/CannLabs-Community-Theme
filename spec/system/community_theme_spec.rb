# frozen_string_literal: true

RSpec.describe "CannLabs Community theme" do
  let!(:theme) { upload_theme }

  fab!(:user)
  fab!(:category)
  fab!(:topic) { Fabricate(:topic, category:) }
  fab!(:post) { Fabricate(:post, topic:) }

  let(:light_shell) { "rgb(22, 26, 21)" }
  let(:light_paper) { "rgb(242, 244, 240)" }

  let(:computed) do
    ->(selector, property) do
      element = "document.querySelector(#{selector.to_json})"
      page.evaluate_script(
        "getComputedStyle(#{element}).getPropertyValue(#{property.to_json}).trim()",
      )
    end
  end

  let(:normalized_family) { ->(value) { value.delete("\"' ").downcase } }

  it "pairs the two frozen colour schemes on install" do
    expect(theme.color_scheme.name).to eq("CannLabs Comunidade Claro")
    expect(theme.dark_color_scheme.name).to eq("CannLabs Comunidade Escuro")
  end

  it "paints the sidebar with the shell while modernize is on" do
    SiteSetting.modernize_foundation_theme = true
    sign_in(user)

    visit("/latest")

    expect(page).to have_css("body.uc-modernize-foundation-theme")
    expect(page).to have_css(".sidebar-wrapper")
    expect(computed.call(".sidebar-wrapper", "background-color")).to eq(light_shell)
  end

  it "paints the drawer with the shell while the user menu stays paper" do
    SiteSetting.navigation_menu = "header dropdown"
    sign_in(user)

    visit("/latest")

    find("#toggle-hamburger-menu").click
    expect(page).to have_css(".hamburger-panel .menu-panel")
    expect(computed.call(".hamburger-panel .menu-panel", "background-color")).to eq(light_shell)

    find("#toggle-hamburger-menu").click
    expect(page).to have_no_css(".hamburger-panel")

    find("#toggle-current-user").click
    expect(page).to have_css(".user-menu.menu-panel")
    expect(computed.call(".user-menu.menu-panel", "background-color")).to eq(light_paper)
  end

  it "removes the category accent in both modernize states" do
    [false, true].each do |modernize|
      SiteSetting.modernize_foundation_theme = modernize
      sign_in(user)

      visit("/categories")

      expect(page).to have_css(".category-list tbody .category")
      expect(computed.call(".category-list tbody .category", "border-left-width")).to eq("0px")
    end
  end

  it "sets topic-list titles in the title family" do
    visit("/latest")

    expect(page).to have_css(".topic-list .main-link a.title")

    title_family =
      normalized_family.call(computed.call(".topic-list .main-link a.title", "font-family"))
    title_variable = normalized_family.call(computed.call(".topic-list", "--cl-font-title"))

    expect(title_family).to eq(title_variable)
    expect(title_family).to start_with("petrona,")
  end
end
