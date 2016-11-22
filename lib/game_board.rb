class GameBoard
  attr_reader :board
  def initialize
    @board = create_board
    @player = "p1"
  end

  def create_board
    ([:empty]*6).map {|empty| [nil]*7 }
  end

  def reverse_board
    board.reverse
  end

  def field_empty?(x, y)
    board[x][y].nil?
  end

  def drop_disc(location, player)
    x, y = location
    if field_empty?(x, y)
      board[x][y] = player
    else
      return false
    end
    board
  end

  def format_row(arr)
    arr.map do |column|
      if column.nil?
        "⛚"
      elsif column == 'p1'
        "○"
      else
        "●"
      end
    end * ' '
  end

  def format_board
    board.map do |row|
      format_row(row)
    end.join("\n") + "\n"
  end

  def get_winner
    check_horizontal || check_vertical || check_diagonal || check_anti_diagonal
  end

  def check_horizontal
    board.each do |row|
      row.each_cons(4) do |col|
        if col.uniq.length == 1 && !col.first.nil?
          return col.first
        end
      end
    end
    return nil
  end

  def check_vertical
    board.transpose.each do |col|
      col.each_cons(4) do |row|
        if row.uniq.length == 1 && !row.first.nil?
          return row.first
        end
      end
    end
    return nil
  end

  def check_diagonal
    4.times do |k|
      a, b, i, j = [], [], 0, 0
      loop do
        j = i + k
        break if j > 6 || i > 5
        a << reverse_board[i][j]
        b << reverse_board[j][i] if j <= 5 && j != i
        i += 1
      end
      a.each_cons(4) { |e| return e.first if e.uniq.length == 1 && !e.first.nil? }
      b.each_cons(4) { |e| return e.first if e.uniq.length == 1 && !e.first.nil? }
    end
    return nil
  end

  def check_anti_diagonal
    4.times do |k|
      a, b, i, j = [], [], 0, 0
      loop do
        j = i + k
        break if j > 6 || i > 5
        a << board[i][j]
        b << board[j][i] if j <= 5 && j != i
        i += 1
      end
      a.each_cons(4) { |e| return e.first if e.uniq.length == 1 && !e.first.nil? }
      b.each_cons(4) { |e| return e.first if e.uniq.length == 1 && !e.first.nil? }
    end
    return nil
  end
end