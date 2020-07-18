require 'spec_helper'
require 'ruby-ambient'

describe Ambient do
  let(:channel_id) { '1111' }
  let(:obj) { Ambient.new(channel_id)}

  before do
    allow(obj).to receive(:post)
    allow(obj).to receive(:get)
  end

  describe 'Ambient#send' do
    before do
      obj.write_key = 'write_key'
    end
    context 'sending only one of data(hash)' do
      subject { obj.send(data) }

      let(:data) { {d1: 1, d2: 2} }

      it 'the parameters must be passed in an array' do
        expect(obj).to receive(:post).with(anything, { writeKey: 'write_key', data: [data] }.to_json, anything)

        subject
      end
    end

    context 'sending only one of data(array of hash)' do
      subject { obj.send([data]) }

      let(:data) { {d1: 1, d2: 2} }

      it 'the parameters must be passed in an array' do
        expect(obj).to receive(:post).with(anything, { writeKey: 'write_key', data: [data] }.to_json, anything)

        subject
      end
    end
  end

  describe 'Ambient#read' do
    subject { obj.read(**param) }

    before do
      obj.read_key = 'read_key'
    end

    let(:param) {
      {
        date: '2020/7/18',
        start: '2020/6/18',
        end: '2020/7/17',
        n: 3,
        skip: 4
      }
    }

    context 'If you have a specific date' do
      it 'No unnecessary parameters are added' do
        expect(obj).to receive(:get) do |uri|
          expect(uri.query).to eq "readKey=read_key&date=2020/7/18"
        end.and_return("[]")

        subject
      end
    end

    context 'If a range of dates is specified' do
      before do
        param.delete :date
      end

      it 'No unnecessary parameters are added' do
        expect(obj).to receive(:get) do |uri|
          expect(uri.query).to eq "readKey=read_key&start=2020/6/18&end=2020/7/17"
        end.and_return("[]")

        subject
      end
    end

    context 'If the number of items is specified' do
      before do
        param.delete :date
        param.delete :start
        param.delete :end
      end

      it 'No unnecessary parameters are added' do
        expect(obj).to receive(:get) do |uri|
          expect(uri.query).to eq "readKey=read_key&n=3&skip=4"
        end.and_return("[]")

        subject
      end
    end
  end

  describe 'Ambient.symbolize_keys' do
    subject { Ambient.symbolize_keys(data) }

    let(:data) {
      {
        'aa': 'bb',
        'cc': {
          'hoge': 3,
          ge: 'ee'
        },
        ee: [
          1,
          3,
          {
            'ho': 2
          }
        ]
      }
    }
    let(:expected) {
      {
        aa: 'bb',
        cc: {
          hoge: 3,
          ge: 'ee'
        },
        ee: [
          1,
          3,
          {
            ho: 2
          }
        ]
      }
    }

    it { is_expected.to eq expected }      
  end
end
