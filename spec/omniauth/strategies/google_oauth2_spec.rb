require 'spec_helper'
require 'omniauth-google'

describe OmniAuth::Strategies::Google do
  subject do
    OmniAuth::Strategies::Google.new(nil, @options || {})
  end

  it_should_behave_like 'an oauth2 strategy'

  describe '#client' do
    it 'has correct Google site' do
      subject.client.site.should eq('https://accounts.google.com')
    end

    it 'has correct authorize url' do
      subject.client.options[:authorize_url].should eq('/o/oauth2/auth')
    end

    it 'has correct token url' do
      subject.client.options[:token_url].should eq('/o/oauth2/token')
    end
  end

  describe '#callback_path' do
    it "has the correct callback path" do
      subject.callback_path.should eq('/auth/google/callback')
    end
  end

  describe '#authorize_params' do
    it 'should expand scope shortcuts' do
      @options = { :authorize_options => [:scope], :scope => 'userinfo.email'}
      subject.authorize_params['scope'].should eq('https://www.googleapis.com/auth/userinfo.email')
    end

    it 'should leave full scopes as is' do
      @options = { :authorize_options => [:scope], :scope => 'https://www.googleapis.com/auth/userinfo.profile'}
      subject.authorize_params['scope'].should eq('https://www.googleapis.com/auth/userinfo.profile')
    end

    it 'should join scopes' do
      @options = { :authorize_options => [:scope], :scope => 'userinfo.profile,userinfo.email'}
      subject.authorize_params['scope'].should eq('https://www.googleapis.com/auth/userinfo.profile https://www.googleapis.com/auth/userinfo.email')
    end

    it 'should set default scope to userinfo.email,userinfo.profile' do
      @options = { :authorize_options => [:scope]}
      subject.authorize_params['scope'].should eq('https://www.googleapis.com/auth/userinfo.email https://www.googleapis.com/auth/userinfo.profile')
    end

     it 'should set the state parameter' do
      @options = {:state => "some_state"}
      subject.authorize_params['state'].should eq('some_state')
    end
  end

end