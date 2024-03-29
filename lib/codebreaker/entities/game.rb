# frozen_string_literal: true

module Codebreaker
  class Game < ValidatableEntity
    attr_reader :difficulty, :user, :attempts_amount, :hints_amount, :code

    def initialize(difficulty, user)
      super()
      @difficulty = difficulty
      @user = user
    end

    def start
      prepare_game
    end

    def self.user_statistic
      store = CodebreakerStore.new
      store.data[:user_statistics].sort_by { |stats| [stats.difficulty, stats.attempts, stats.hints] }
    end

    def save_statistic
      store = CodebreakerStore.new
      store.data[:user_statistics] << current_statistic
      store.save
    end

    def take_hint
      @hints_amount -= 1
      @hints.pop
    end

    def make_turn(guess)
      @guess = guess
      @attempts_amount -= 1

      matcher = CodeMatcher.new(code, guess.code)
      matcher.match_codes
    end

    def win?
      code == @guess&.code
    end

    def lose?
      attempts_amount < 1 && !win?
    end

    def restart
      prepare_game
    end

    private

    def current_statistic
      UserStatistics.new(user: user, difficulty: difficulty,
                         attempts: difficulty.attempts - attempts_amount,
                         hints: difficulty.hints - hints_amount)
    end

    def validate
      add_error(:user, I18n.t(:unexpected_class_error)) unless valid_class?(User, user)
      add_error(:difficulty, I18n.t(:unexpected_class_error)) unless valid_class?(Difficulty, difficulty)
    end

    def prepare_game
      @attempts_amount = difficulty.attempts
      @hints_amount = difficulty.hints
      @code = CodeGenerator.new.generate
      @hints = code.sample(hints_amount)
    end
  end
end
