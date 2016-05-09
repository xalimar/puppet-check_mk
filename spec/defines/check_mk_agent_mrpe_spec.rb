require 'spec_helper'
describe 'check_mk::agent::mrpe', :type => :define do
  let :title do
    'checkname'
  end
  context 'Unsupported OS' do
    context 'with mandatory command' do
      let :params do
        {:command => 'command'}
      end
      it 'should fail' do
        expect { catalogue }.to raise_error(Puppet::Error, /Creating mrpe.cfg is unsupported for osfamily/)
      end
    end
  end
  context 'RedHat Linux' do
    let :facts do
      {
          :osfamily => 'RedHat',
      }
    end
    context 'with mandatory command' do
      let :params do
        {:command => 'command'}
      end
      it { should contain_check_mk__agent__mrpe('checkname') }
      it { should contain_concat('/etc/check_mk/mrpe.cfg').with_ensure('present') }
      it { should contain_concat__fragment('checkname-mrpe-check').with({
            :target  => '/etc/check_mk/mrpe.cfg',
            :content => /^checkname command\n$/,
        })
      }
    end
  end
end
