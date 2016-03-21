require 'spec_helper'
describe 'dapb' do

  context 'with defaults for all parameters' do
    it { should contain_class('dapb') }
  end
end
