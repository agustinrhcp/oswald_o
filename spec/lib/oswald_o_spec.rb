require 'spec_helper'

describe OswaldO do
  describe 'a oswald instance' do
    let(:hash) { { a: 1, b: 2, c: 3, 'd' => 4, e: nil } }

    subject { OswaldO.new(hash) }

    its(:a) { should eql(1) }
    its(:b) { should eql(2) }
    its(:c) { should eql(3) }
    its(:d) { should eql(4) }
    its(:e) { should eql(nil) }

    context 'when the hash contains a inner hash' do
      let(:hash) { { a: { b: 1 } } }

      its(:a) { should be_kind_of(OswaldO) }

      it 'returns the inner value by chaining keys' do
        expect(subject.a.b).to eql(hash[:a][:b])
      end
    end

    context 'when the hash contains an array' do
      let(:hash) { { a: [1, 2, 3] } }

      its(:a) { should be_kind_of(Array) }

      describe 'the inner array' do
        subject { OswaldO.new(hash).a }

        it 'behaves normally' do
          expect(subject[0]).to eql(hash[:a][0])
        end
      end

      context 'when the array contains a hash' do
        let(:hash) { { a: [b: 1] } }

        its(:a) { should be_kind_of(Array) }

        describe 'the inners array hash elements' do
          subject { OswaldO.new(hash).a[0] }

          its(:b) { should eql(hash[:a][0][:b]) }
        end                
      end
    end
  end
end