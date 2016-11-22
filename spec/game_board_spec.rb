# spec/game_board_spec.rb
require 'game_board'
describe GameBoard do
  let(:empty_board) { [[nil]*7]*6 }
  let(:p1) { "p1" }
  let(:p2) { "p2" }
  let(:winning_horizontal) { [[nil]*7,
                         [nil]*7,
                         [p1, p1, p2, p2, p1, p2, p2],
                         [p1, p1, p2, p1, p1, p1, p1],
                         [p2, p2, p1, p2, p1, p2, p2],
                         [p1, p1, p2, p1, p1, p2, p1]] }
  let(:winning_vertical) { winning_horizontal.transpose }
  let(:winning_diagonal) { [[nil]*7,
                           [nil]*7,
                           [p1, p1, p2, p1, p1, p2, p2],
                           [p1, p1, p2, p1, p1, p2, p1],
                           [p2, p2, nil, p2, p2, p1, p2],
                           [p2, p1, p2, p2, p2, p2, p1]] }
  let(:another_winning_diagonal) { [[nil]*7,
                            [nil]*7,
                            [p2, p1, p2, p2, p1, p2, p1],
                            [p1, p1, p2, p2, p1, p1, p1],
                            [p2, p2, p1, p2, p1, p1, p2],
                            [p1, p1, p2, p1, p2, p2, p1]] }
  let(:winning_anti_diagonal) { [[p2, p1, p2, p2, p1, p2, p1],
                                 [p1, p2, p2, p2, p1, p1, p1],
                                 [p2, p2, p2, p2, p1, p1, p2],
                                 [p1, p1, p2, p2, p2, p2, p1],
                                 [nil]*7,
                                 [nil]*7] }
  describe "#create_board" do
    it("creates an array of arrays") { expect(subject.create_board).to eql(empty_board) }
  end

  describe "#board" do
    it("returns an empty board") { expect(subject.board).to eql(empty_board) }
  end

  describe "#drop_disc" do
    context "given player p1 and" do
      context "given location [0,5]" do
        it "marks the field at the location with the player name" do
          expect(subject.drop_disc([0, 5], p1)[0][5]).to eql(p1)
        end

        context "dropping the disc twice at the same location" do
          it "returns the board the first time; returns false the second time" do
            expect(subject.drop_disc([0,5], p1)).to be_an Array
            expect(subject.drop_disc([0,5], p1)).to be false
          end
        end
      end
    end
  end

  describe "#field_empty?" do
    context "given location [4, 5]" do
      it "returns true" do
        expect(subject.field_empty?(4,5)).to be true
      end

      context "with dropped disc at the location" do
        before do
          @game_board = GameBoard.new
          @game_board.drop_disc [4,5], p1
        end

        it "returns false" do
          expect(@game_board.field_empty?(4,5)).to be false
        end
      end
    end
  end

  describe "#format_row" do
    context "given array [nil, nil, nil]" do
      it "returns string '⛚ ⛚ ⛚'" do
        expect(subject.format_row([nil, nil, nil])).to eql("⛚ ⛚ ⛚")
      end
    end

    context "given array [nil, 'p2', 'p1']" do
      it "returns string '⛚ ● ○'" do
        expect(subject.format_row([nil, p2, p1])).to eql("⛚ ● ○")
      end
    end
  end

  describe "#format_board" do
    context "without dropping any discs" do
      it "returns an empty board" do
        b = %(⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
)
        expect(subject.format_board).to eql(b)
      end
    end

    context "when dropped a ball at location [0,0] by player 1" do
      before do
        @game_board = GameBoard.new
        @game_board.drop_disc [0,0], p1
      end
      b = %(○ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
⛚ ⛚ ⛚ ⛚ ⛚ ⛚ ⛚
)
      it "returns board with disc at location 0,0 by player 1 (○)" do
        expect(@game_board.format_board).to eql(b)
      end
    end
  end

  describe "#check_horizontal" do
    context "given empty board" do
      it "returns nil" do
        expect(subject.check_horizontal).to be nil
      end
    end
    context "given a winning board with 4 horizontally connected discs" do
      before do
        @game_board = GameBoard.new
        @game_board.instance_variable_set("@board", winning_horizontal)
      end

      it "returns 'p1'" do
        expect(@game_board.check_horizontal).to eql('p1')
      end
    end
  end

  describe "#check_vertical" do
    context "given a winning board with 4 vertically connected discs" do
      before do
        @game_board = GameBoard.new
        @game_board.instance_variable_set("@board", winning_vertical)
      end

      it "returns 'p1'" do
        expect(@game_board.check_vertical).to eql('p1')
      end
    end

    context "given empty board" do
      it "returns nil" do
        expect(subject.check_vertical).to be nil
      end
    end
  end

  describe "#check_diagonal" do
    context "given a winning board with 4 diagonally connected discs" do
      before do
        @game_board = GameBoard.new
        @game_board.instance_variable_set("@board", winning_diagonal)
      end

      it "returns 'p2'" do
        expect(@game_board.check_diagonal).to eql('p2')
      end
    end

    context "given another winning board with 4 diagonally connected discs" do
      before do
        @game_board = GameBoard.new
        @game_board.instance_variable_set("@board", another_winning_diagonal)
      end

      it "returns 'p1'" do
        expect(@game_board.check_diagonal).to eql('p1')
      end
    end

    context "given empty board" do
      it "returns nil" do
        expect(subject.check_diagonal).to be nil
      end
    end
  end

  describe "#check_anti_diagonal" do
    context "given a winning board with 4 anti-diagonally connected discs" do
      before do
        @game_board = GameBoard.new
        @game_board.instance_variable_set("@board", winning_anti_diagonal)
      end

      it "returns 'p2'" do
        expect(@game_board.check_anti_diagonal).to eql('p2')
      end
    end
  end

  describe '#get_winner' do
    context "given an empty board" do
      it "returns nil" do
        expect(subject.get_winner).to be_falsey
      end
    end

    context "given a winning board with 4 connected discs" do
      before do
        @game_board = GameBoard.new
        @game_board.instance_variable_set("@board", winning_horizontal)
      end

      it "returns 'p1'" do
        expect(@game_board.get_winner).to eql('p1')
      end
    end
  end

  describe "#toggle_player" do
    context "previous player being 'p1'" do
      before do
        @game_board = GameBoard.new
        @game_board.toggle_player
      end

      it "changes player to 'p2'" do
        expect(@game_board.player).to eql('p2')
      end
    end
  end
end