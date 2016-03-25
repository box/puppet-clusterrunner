require 'spec_helper'
describe 'clusterrunner' do

  context 'with defaults for all parameters' do
    it { should contain_class('clusterrunner') }
  end
end
