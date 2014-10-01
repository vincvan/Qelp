require 'rails_helper'

# >>> Debugging = save_and_open_page


describe 'restaurant' do

	context 'without any restaurants created' do 
		it 'can prompt that there are no restaurants' do
			visit '/restaurants' 
			expect(page).to have_content('No restaurants')
			expect(page).to have_link('Create restaurant')
		end
	end
	
	context 'restaurants have been added' do 
		before do 
			Restaurant.create(name: 'Spitzweg', description: 'This is an awesome restaurant', rating: 5)
		end

		it 'shows one restaurant' do 
			visit '/restaurants'
			expect(page). to have_content('Spitzweg')
			expect(page).not_to have_content('No restaurants')
		end

		it 'has name which is a link' do 
			visit '/restaurants'
      		expect(page).to have_link('Spitzweg')
		end
	end

	context 'add restaurants' do

		before do
		  user = User.create email: 'ethel@gmail.com', password: '12345678', password_confirmation: '12345678'
		  visit '/restaurants'
		  click_link 'Login'
		  fill_in 'Email', with: 'ethel@gmail.com'
		  fill_in 'Password', with: '12345678'
		  click_button 'Log in'
		end

		it 'has a form' do 
			visit '/restaurants/new'
			expect(page).to have_css('form')
		end

		it 'when form is filled in, it shows the restaurant' do
			visit '/restaurants/new'
			fill_in('restaurant[name]', with: 'McDonalds')
			fill_in('restaurant[description]', with: 'Shit restaurant')
			fill_in('restaurant[rating]', with: '1')
			click_button('Create')
			expect(page).to have_content('McDonalds')
			expect(page).not_to have_content('No restaurants')
		end

		it 'can show errors' do 
			visit '/restaurants/new'
			fill_in('restaurant[name]', with: 'Mc')
			fill_in('restaurant[description]', with: 'Shit restaurant')
			fill_in('restaurant[rating]', with: '1')
			click_button('Create')
			expect(page).to have_content('Name is too short')
		end
	end

	xcontext 'editing restaurants' do
		it 'can be edited' do
			visit "/restaurants"
			click_button('edit')
		 	fill_in('restaurant[name]', with: 'McDonalds')
			fill_in('restaurant[description]', with: 'Shit restaurant')
			fill_in('restaurant[rating]', with: '1')
			click_button('Update')
		end
	end
end

