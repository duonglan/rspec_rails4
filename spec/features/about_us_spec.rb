# coding: utf-8

require 'spec_helper'

feature 'About BigCo modal' do
  scenario 'toggles display of the modal about display', js: true  do
    about_content     = 'About BigCo'
    about_description = 'BigCo produces the finest widgets in all the land'
    visit root_path

    expect(page).to_not have_content about_content
    expect(page).to_not have_content about_description

    click_link 'About Us'

    expect(page).to have_content about_content
    expect(page).to have_content about_description

    within '#about_us' do
      click_button 'Close'
    end

    expect(page).to_not have_content about_content
    expect(page).to_not have_content about_description
  end
end
