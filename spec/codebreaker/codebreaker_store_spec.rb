# frozen_string_literal: true

RSpec.describe Codebreaker::CodebreakerStore do
  let(:directory_path) { 'Codebreaker::CodebreakerStore::STORAGE_DIRECTORY' }
  let(:filename) { 'Codebreaker::CodebreakerStore::STORAGE_FILE' }

  describe 'instance creation' do
    context 'when db initialized' do
      let(:fixtures_directory_path) { 'spec/codebreaker/fixtures' }
      let(:fixtures_filename) { 'user_statistics.yml' }

      before do
        stub_const(directory_path, fixtures_directory_path)
        stub_const(filename, fixtures_filename)
      end

      it 'can load users statistics' do
        store = described_class.new
        expect(store.data[:user_statistics]).not_to be_empty
      end
    end

    context 'when db is not initialized' do
      let(:initialized_directory_path) { 'test_db' }
      let(:initialized_filename) { 'user_statistics.yml' }

      before do
        stub_const(directory_path, initialized_directory_path)
        stub_const(filename, initialized_filename)
      end

      after do
        File.delete(File.join(initialized_directory_path, initialized_filename))
        Dir.rmdir(initialized_directory_path)
      end

      it 'initialize db and return default data' do
        store = described_class.new
        expect(store.data[:user_statistics]).to be_empty
      end
    end
  end

  describe '#save' do
    let(:saving_directory_path) { 'test_db' }
    let(:saving_filename) { 'saved_user_statistics.yml' }
    let(:user) { Codebreaker::User.new(Faker::Name.first_name) }
    let(:difficulty) { Codebreaker::Difficulty.new(name: 'Easy', attempts: 10, hints: 5) }
    let(:attempts) { 3 }
    let(:hints) { 2 }

    before do
      stub_const(directory_path, saving_directory_path)
      stub_const(filename, saving_filename)
    end

    after do
      File.delete(File.join(saving_directory_path, saving_filename))
      Dir.rmdir(saving_directory_path)
    end

    it 'can save users statistics' do
      store = described_class.new
      statistics = Codebreaker::UserStatistics.new(user: user, difficulty: difficulty, attempts: attempts, hints: hints)
      store.data[:user_statistics] << statistics
      expect { store.save }.not_to raise_error
    end
  end
end
