require 'rails_helper'
require_relative '../helpers/application_helper'

describe 'restaurant reviews' do
	context 'restaurant profile page' do
		before do 
			@restaurant = Restaurant.create(name: 'Spitzweg', description: 'This is an awesome restaurant')
			visit '/'
			user = create(:user)	
	  		login_as(user, :scope => :user)
			leave_review('horrible stuff, will never eat there again',1)
			leave_review('great stuff, will eat there again',1)
		end
		it 'has its own profile page' do 
			visit "/restaurants/#{@restaurant.id}"
			expect(page).to have_content('Spitzweg')
			expect(page).to have_content('This is an awesome restaurant')
		end

		it 'has all its reviews printed on its page' do 
			visit "/restaurants/#{@restaurant.id}"
			expect(page).to have_content("great")
			expect(page).to have_content("horrible")
		end

		it 'has all its reviews printed on its page' do 
			visit "/restaurants/#{@restaurant.id}"
			expect(page).to have_link('Leave Review')
		end

		it 'has fields for writing the review and rating the restaurant on a scale' do
			visit "/restaurants/#{@restaurant.id}"
			click_link('Leave Review')
			expect(page).to have_field('review[content]')
			expect(page).to have_field('review[rating]')
			expect(page).to have_button('Post Review')
		end

		it 'saves new review to the database' do
			visit "/restaurants/#{@restaurant.id}"
			leave_review("Awesome Restaurant", 5)
			expect(@restaurant.reviews.last.content).to eq('Awesome Restaurant')
		end

	end

	context 'invalid review' do
		before do 
			@restaurant = Restaurant.create(name: 'Spitzweg', description: 'This is an awesome restaurant')
			visit '/'
			user = create(:user)	
	  		login_as(user, :scope => :user)
		end

		it 'displays an error if rating is not provided' do
			visit "/restaurants/#{@restaurant.id}"
			leave_review("Awesome Restaurant")
			expect(page).to have_content('Rating can\'t be blank')
		end
	end

	context 'user details of the author of the review' do

		before do
			@restaurant = Restaurant.create(name: 'Spitzweg', description: 'This is an awesome restaurant')
			user = create(:user)	
	  		login_as(user, :scope => :user)
		end

		it 'displays the email of the user next to the review' do 
			visit "/restaurants/#{@restaurant.id}"
			leave_review('horrible stuff, will never eat there again',1)
			within(:css, '.review:first-of-type') do
				expect(page).to have_content 'ethel@factorygirl.com'
			end
		end
	end
end