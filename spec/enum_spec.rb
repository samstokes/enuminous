require 'enuminous'

class Gender < Enum
  value :male
  value :female

  def_case :address do
  when_male { 'Sir' }
  when_female { "Ma'am" }
  end
end

class MaritalStatus < Enum
  value :single
  value :married
  value :divorced
end


describe Gender do
  describe 'dynamic construction' do
    it 'should allow constructing with valid values' do
      Gender.new(:male).should be_a Gender
    end

    it 'should disallow constructing with invalid values' do
      expect { Gender.new(:sasquatch) }.to raise_error ArgumentError, /sasquatch/
    end
  end

  describe 'constants' do
    subject { Gender::MALE }

    it { should be_a Gender }
    it { should equal Gender::MALE }
  end

  describe 'instance' do
    subject { Gender::MALE }

    describe 'query methods' do
      it { should be_male }
      it { should_not be_female }
    end

    its(:to_s) { should == 'male' }
  end

  describe 'case' do
    let(:gender1) { Gender::MALE }
    let(:gender2) { Gender::FEMALE }

    it 'should branch based on value' do
      pronoun = gender1.case do
      when_male { 'him' }
      when_female { 'her' }
      end

      pronoun.should == 'him'

      title = gender2.case do
      when_male { 'Mr' }
      when_female { 'Ms' }
      end

      title.should == 'Ms'
    end

    describe 'checking' do
      it 'should blow up at runtime if you forget a case' do
        expect {
          gender1.case do
          when_male { 42 }
          end
        }.to raise_error Enum::MissingCaseError, /female/
      end

      it 'should blow up before executing the case block' do
        expect {
          gender1.case do
          when_male { raise "block was executed" }
          end
        }.to_not raise_error "block was executed"
      end
    end
  end
end


describe Enum do
  it 'should not leak values between enum definitions' do
    expect { MaritalStatus.new :single }.to_not raise_error
    expect { MaritalStatus.new :male }.to raise_error(/male/)
  end

  it 'should not leak constants between enum definitions' do
    defined?(MaritalStatus::SINGLE).should be_true
    defined?(MaritalStatus::MALE).should be_false
  end
end
