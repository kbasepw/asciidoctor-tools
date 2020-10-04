class Integer
  @@conversion = {
    1 => ["I", "V", "X"],
    2 => ["X", "L", "C"],
    3 => ["C", "D", "M"],
    4 => ["M", "M", "M"]
  }

  def to_roman
    numeral = self
    roman_numeral = ""

    # do it by places
    # 1"s place
    # build it up and move on, shovel it in
    # 
    i = 1

    loop do
      place = numeral % 10
      this_place = ""

      if i == 4
        this_place = @@conversion[i][0] * place
        roman_numeral = this_place + roman_numeral
        break
      elsif place.between?(1,3)
        this_place = @@conversion[i][0] * place
      elsif place == 4
        this_place = @@conversion[i][0] + @@conversion[i][1]
      elsif place.between?(5,8)
        this_place = @@conversion[i][1]
        this_place += @@conversion[i][0] * (place - 5)
      elsif place == 9
        this_place = @@conversion[i][0] + @@conversion[i][2]
      elsif place == 0
        i += 1 if i == 3
      end

      roman_numeral = this_place + roman_numeral

      i += 1 if i < 4
      numeral /= 10
      break if numeral == 0
    end

    roman_numeral
  end
end

