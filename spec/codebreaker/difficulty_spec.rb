# frozen_string_literal: true

RSpec.describe Codebreaker::Difficulty do
  subject(:difficulty) { described_class.new(name: 'Medium', attempts: 10, hints: 2) }

  let(:equal_difficulty) { described_class.new(name: 'Normal', attempts: 10, hints: 2) }
  let(:easy_difficulty) { described_class.new(name: 'Easy', attempts: 15, hints: 3) }
  let(:hell_difficulty) { described_class.new(name: 'Hell', attempts: 5, hints: 1) }

  describe '#valid?' do
    let(:valid_name) { 'Easy' }
    let(:valid_attempts) { 10 }
    let(:valid_hints) { 5 }
    let(:invalid_name) { '' }
    let(:invalid_attempts) { 0 }
    let(:invalid_hints) { -1.65 }

    it 'returns true if instance is valid' do
      valid_difficulty = described_class.new(name: valid_name, attempts: valid_attempts, hints: valid_hints)
      expect(valid_difficulty).to be_valid
    end

    it 'returns false if instance is not valid' do
      invalid_difficulty = described_class.new(name: invalid_name, attempts: invalid_attempts, hints: invalid_hints)
      expect(invalid_difficulty).not_to be_valid
    end
  end

  describe '#<=>' do
    it 'is harder when fewer attempts and hints' do
      expect(difficulty <=> easy_difficulty).to eq(-1)
    end

    it 'is easier when more attempts and hints' do
      expect(difficulty <=> hell_difficulty).to eq 1
    end

    it 'is equal another difficulty when has same amount of attempts and hints' do
      expect(difficulty <=> equal_difficulty).to eq 0
    end
  end

  describe '.difficulties' do
    it 'returns game with easy difficulty' do
      expect(described_class.difficulties(:easy)).to be_a described_class
    end

    it 'returns game with medium difficulty' do
      expect(described_class.difficulties(:medium)).to be_a described_class
    end

    it 'returns game with hell difficulty' do
      expect(described_class.difficulties(:hell)).to be_a described_class
    end

    it 'returns nil if unknown difficulty keyword passed' do
      expect(described_class.difficulties(:invalid)).to be_nil
    end
  end
end
