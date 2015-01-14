require 'spec_helper'

describe Validic::REST::Users do
  let(:client) { Validic::Client.new }

  describe '#get_users' do
    before do
      stub_get("/organizations/1/users.json")
        .with(query: { access_token: '1' })
        .to_return(body: fixture('users.json'),
                   headers: { content_type: 'application/json; charset=utf-8' })
    end
    it 'returns a validic response object' do
      users = client.get_users
      expect(users).to be_a Validic::Response
    end
    it 'makes a users request to the correct url' do
      client.get_users
      expect(a_get('/organizations/1/users.json').with(query: { access_token: '1' })).to have_been_made
    end
  end

  describe '#provision_user' do
    before do
      stub_post('/organizations/1/users.json')
        .with(body: { user: { uid: '123467890' }, access_token: '1' }.to_json)
        .to_return(body: fixture('user.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end
    it 'requests the correct resource' do
      client.provision_user(uid: '123467890')
      expect(a_post('/organizations/1/users.json')
        .with(body: { user: { uid: '123467890' }, access_token: '1' }.to_json))
        .to have_been_made
    end
    it 'returns a User' do
      user = client.provision_user(uid: '123467890')
      expect(user).to be_a Validic::User
      expect(user.uid).to eq '123467890'
    end
  end

  describe '#update_user' do
    before do
      stub_put('/organizations/1/users/1.json')
        .with(body: { user: { uid: 'abcde' }, access_token: '1' }.to_json)
        .to_return(body: fixture('updated_user.json'), headers: { content_type: 'application/json; charset=utf-8' })
    end
    it 'requests the correct resource' do
      client.update_user('1', uid: 'abcde')
      expect(a_put('/organizations/1/users/1.json')
        .with(body: { user: { uid: 'abcde' }, access_token: '1' }.to_json))
        .to have_been_made
    end
    it 'returns a User' do
      user = client.update_user('1', uid: 'abcde')
      expect(user).to be_a Validic::User
      expect(user.uid).to eq 'abcde'
    end
  end

  describe '#delete_user' do
    before do
      stub_delete('/organizations/1/users/1.json').to_return(status: 200)
    end
    it 'returns true' do
      response = client.delete_user('1')
      expect(response).to be true
    end
  end

  describe '#me' do
    before do
      stub_get('/me.json').with(query: { access_token: '1', authentication_token: 'auth_token' })
        .to_return(body: fixture('me.json'),
            headers: { content_type: 'application/json; charset=utf-8' })
    end
    it 'makes a request to the correct resource' do
      client.me('auth_token')
      expect(a_get('/me.json').with(query: { access_token: '1', authentication_token: 'auth_token' }))
        .to have_been_made
    end
    it 'returns a String' do
      me = client.me('auth_token')
      expect(me).to eq '1'
    end
  end

  describe '#suspend_user' do
    before do
      stub_put('/organizations/1/users/1.json')
        .with(body: { suspend: '1', access_token: '1' }.to_json)
        .to_return(status: 200)
    end
    it 'makes a request to the correct resource' do
      client.suspend_user('1')
      expect(a_put('/organizations/1/users/1.json')
        .with(body: { suspend: '1', access_token: '1' }.to_json))
        .to have_been_made
    end
    it 'returns true' do
      response = client.suspend_user('1')
      expect(response).to be true
    end
  end

  describe '#unsuspend_user' do
    before do
      stub_put('/organizations/1/users/1.json')
        .with(body: { suspend: '0', access_token: '1' }.to_json)
        .to_return(status: 200)
    end
    it 'makes a request to the correct resource' do
      client.unsuspend_user('1')
      expect(a_put('/organizations/1/users/1.json')
        .with(body: { suspend: '0', access_token: '1' }.to_json))
        .to have_been_made
    end
    it 'returns true' do
      response = client.unsuspend_user('1')
      expect(response).to be true
    end
  end

  describe '#refresh_token' do
    before do
      stub_get('/organizations/1/users/1/refresh_token.json')
        .with(query: { access_token: '1' })
        .to_return(body: fixture('refresh_token.json'),
                   headers: { content_type: 'application/json; charset=utf-8' })
    end
    it 'makes a request to the correct resource' do
      client.refresh_token('1')
      expect(a_get('/organizations/1/users/1/refresh_token.json')
        .with(query: { access_token: '1' }))
        .to have_been_made
    end
    it 'returns a User' do
      user = client.refresh_token('1')
      expect(user).to be_a Validic::User
    end
  end
end
