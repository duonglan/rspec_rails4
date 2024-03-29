# coding: utf-8

require 'spec_helper'


describe ContactsController do
  shared_examples('public access to contacts') do
    before :each do
      @contact = create(:contact)
    end
    describe 'GET#index' do
      it 'populates an array of contacts' do
        get :index
        expect(assigns(:contacts)).to match_array [@contact]
      end
  
      it 'renders the :index template' do
        get :index
        expect(response).to render_template :index
      end
    end
  
    describe 'GET#show' do
      it 'assigns the requested contact to @contact' do
        get :show, id: @contact
        expect(assigns(:contact)).to eq @contact
      end
  
      it 'renders the :show template' do
        get :show, id: @contact
        expect(response).to render_template :show
      end
    end
  end

  shared_examples('full access to contacts') do
    describe 'GET #new' do
      it 'assign a new Contact to @contact' do
        get :new
        expect(assigns(:contact)).to be_a_new(Contact)
      end
      it 'renders the :edit template' do
        get :new
        expect(response).to render_template :new
      end
    end

    describe 'GET #edit' do
      it 'assigns the requested contact to @contact' do
        contact = create(:contact)
        get :edit, id: contact
        expect(assigns(:contact)).to eq contact
      end
  
      it 'renders the :edit template' do
        contact = create(:contact)
        get :edit, id: contact
        expect(response).to render_template :edit
      end
    end

    describe 'POST #create' do
      before :each do
        @phones = [
          attributes_for(:phone),
          attributes_for(:phone),
          attributes_for(:phone)
        ]
      end
  
      context 'with valid attributes' do
        it 'saves the new contact in the database' do
          expect {
            post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          }.to change(Contact, :count).by(1)
        end
  
        it 'redirects to contacts#show' do
          post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end
  
      context 'with invalid attributes' do
        it 'does not save the new contact in the database' do
          expect {
            post :create, contact: attributes_for(:invalid_contact)
          }.to_not change(Contact, :count)
        end
        it 're-renders the :new template' do
          post :create, contact: attributes_for(:invalid_contact)
          expect(response).to render_template :new
        end
      end
    end

    describe 'PATCH #update' do
      before :each do
        @contact = create(:contact, firstname: 'Lawrence', lastname: 'Smith')
      end
  
      context 'valid attributes' do
        it 'locates the requested @contact' do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(assigns(:contact)).to eq(@contact)
        end
  
        it "changes @contact's attributes" do
          patch :update, id: @contact, contact: attributes_for(
            :contact, firstname: "Larry", lastname: "Smith"
          )
          @contact.reload
  
          expect(@contact.firstname).to eq("Larry")
          expect(@contact.lastname).to eq("Smith")
        end
  
        it 'redirects to the updated contact' do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(response).to redirect_to @contact
        end
      end
  
      context 'with invalid attributes' do
        it 'does not update the contact' do
          patch :update, id: @contact, 
            contact: attributes_for(:contact, firstname: "Larry", lastname: nil)
          @contact.reload
  
          expect(@contact.firstname).to_not eq("Larry")
          expect(@contact.lastname).to eq("Smith")
        end
  
        it 're-renders the :edit template' do
          patch :update, id: @contact, contact: attributes_for(:invalid_contact)
        end
      end
    end

    describe 'DELETE #destroy' do
      before :each do
        @contact = create(:contact)
      end
  
      it 'deletes the contact from the database' do
        expect { 
          delete :destroy, id: @contact
        }.to change(Contact, :count).by(-1)
      end
  
      it 'redirects to contacts#index' do
        delete :destroy, id: @contact
        expect(response).to redirect_to contacts_url
      end
    end
  end

  describe 'administrator access' do
    before :each do
      #user = create(:admin)
      #session[:user_id] = user.id
      set_user_session(create(:admin))
    end

    it_behaves_like 'public access to contacts'
    it_behaves_like 'full access to contacts'
  end

  describe 'user access to contacts' do
    before :each do
      set_user_session(create(:user))
    end

    it_behaves_like 'public access to contacts'
    it_behaves_like 'full access to contacts'
  end

=begin
    describe 'GET #index' do
      context 'with params[:letter]' do
        it 'populates an array of contacts starting with the letter' do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index, letter: 'S'
          expect(assigns(:contacts)).to match_array([smith])
        end
        it 'renders the :index template' do
          get :index, letter: 'S'
          expect(response).to render_template :index
        end
      end
  
      context 'without param[:letter]' do
        it 'populates an array of all contacts' do
          smith = create(:contact, lastname: 'Smith')
          jones = create(:contact, lastname: 'Jones')
          get :index
          expect(assigns(:contacts)).to match_array([smith, jones])
        end
        it 'renders the :index template' do
          get :index
          expect(response).to render_template :index
        end
      end
    end
  
    describe 'GET #show' do
      it 'assigns the requested contact to @contact' do
        contact =  create(:contact)
        get :show, id: contact
        expect(assigns(:contact)).to eq contact
      end
      it 'renders the :show template' do
        contact = create(:contact)
        get :show, id: contact
        expect(response).to render_template :show
      end
    end
  
    describe 'GET #new' do
      it 'assign a new Contact to @contact' do
        get :new
        expect(assigns(:contact)).to be_a_new(Contact)
      end
      it 'renders the :edit template' do
        get :new
        expect(response).to render_template :new
      end
    end
  
    describe 'GET #edit' do
      it 'assigns the requested contact to @contact' do
        contact = create(:contact)
        get :edit, id: contact
        expect(assigns(:contact)).to eq contact
      end
  
      it 'renders the :edit template' do
        contact = create(:contact)
        get :edit, id: contact
        expect(response).to render_template :edit
      end
    end
  
    describe 'POST #create' do
      before :each do
        @phones = [
          attributes_for(:phone),
          attributes_for(:phone),
          attributes_for(:phone)
        ]
      end
  
      context 'with valid attributes' do
        it 'saves the new contact in the database' do
          expect {
            post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          }.to change(Contact, :count).by(1)
        end
  
        it 'redirects to contacts#show' do
          post :create, contact: attributes_for(:contact, phones_attributes: @phones)
          expect(response).to redirect_to contact_path(assigns[:contact])
        end
      end
  
      context 'with invalid attributes' do
        it 'does not save the new contact in the database' do
          expect {
            post :create, contact: attributes_for(:invalid_contact)
          }.to_not change(Contact, :count)
        end
        it 're-renders the :new template' do
          post :create, contact: attributes_for(:invalid_contact)
          expect(response).to render_template :new
        end
      end
    end
  
    describe 'PATCH #update' do
      before :each do
        @contact = create(:contact, firstname: 'Lawrence', lastname: 'Smith')
      end
  
      context 'valid attributes' do
        it 'locates the requested @contact' do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(assigns(:contact)).to eq(@contact)
        end
  
        it "changes @contact's attributes" do
          patch :update, id: @contact, contact: attributes_for(
            :contact, firstname: "Larry", lastname: "Smith"
          )
          @contact.reload
  
          expect(@contact.firstname).to eq("Larry")
          expect(@contact.lastname).to eq("Smith")
        end
  
        it 'redirects to the updated contact' do
          patch :update, id: @contact, contact: attributes_for(:contact)
          expect(response).to redirect_to @contact
        end
      end
  
      context 'with invalid attributes' do
        it 'does not update the contact' do
          patch :update, id: @contact, 
            contact: attributes_for(:contact, firstname: "Larry", lastname: nil)
          @contact.reload
  
          expect(@contact.firstname).to_not eq("Larry")
          expect(@contact.lastname).to eq("Smith")
        end
  
        it 're-renders the :edit template' do
          patch :update, id: @contact, contact: attributes_for(:invalid_contact)
        end
      end
    end
  
    describe 'DELETE #destroy' do
      before :each do
        @contact = create(:contact)
      end
  
      it 'deletes the contact from the database' do
        expect { 
          delete :destroy, id: @contact
        }.to change(Contact, :count).by(-1)
      end
  
      it 'redirects to contacts#index' do
        delete :destroy, id: @contact
        expect(response).to redirect_to contacts_url
      end
    end
=end

=begin 
    describe "PATCH hide_contact" do
      before :each do
        @contact = create(:contact)
      end
  
      it "marks the contact as hidden" do
        patch :hide_contact, id: @contact
        expect(@contact.reload.hidden?).to be_true
      end
  
      it "redirects to contacts#index" do
        patch :hide_contact, id: @contact
        expect(response).to redirect_to contacts_url
      end
    end
=end
 
=begin
    describe 'CSV output' do
      it 'returns a CSV file' do
        get :index, format: :csv
        expect(response.headers['Content-Type']).to have_content 'text/csv'
      end
  
      it 'returns content' do
        create(:contact, firstname: 'Aaron', lastname: 'Sumner', email: 'aaron@sample.com')
        get :index, format: :csv
        expect(response.body).to have_content 'Aaron Sumner,aaron@sample.com'
      end
    end
  end
=end

  describe 'guest access' do
    it_behaves_like 'public access to contacts'

    describe 'GET#new' do
      it 'requires login' do
        get :new
        #expect(response).to redirect_to login_url
        expect(response).to require_login
      end
    end

    describe 'GET#edit' do
      it 'requires login' do
        contact = create(:contact)
        get :edit, id: contact
        expect(response).to redirect_to login_url
      end
    end

    describe 'POST#create' do
      it 'requires login' do
        post :create, id: create(:contact), contact: attributes_for(:contact)
        expect(response).to redirect_to login_url
      end
    end

    describe 'PUT#update' do
      it 'requires login' do
        put :update, id: create(:contact), contact: attributes_for(:contact)
        expect(response).to redirect_to login_url
      end
    end

    describe 'DELETE#destroy' do
      it 'requires login' do
      end
    end
  end
end
