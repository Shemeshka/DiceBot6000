class Roller
  def roll(roll_text)
    if /^\d+$/.match?(roll_text)
      return roll_text.to_i
    elsif roll_text.include?('+')
      return roll_text.split('+').map{ |roll_part| roll(roll_part.strip) }.inject(0){ |sum, roll_part| sum + roll_part}
    elsif roll_text.include?('-')
      return roll_text.split('-').map{ |roll_part| roll(roll_part.strip) }.inject{ |sum, roll_part| sum - roll_part}
    elsif /^d\d+$/.match?(roll_text)
      return d_roll(1,roll_text.sub(/d/,'').to_i)
    elsif /^\d+d\d+$/.match?(roll_text)
      params = roll_text.split('d')
      return d_roll(params[0].to_i,params[1].to_i)
    elsif /^\d+k\d+$/.match?(roll_text)
      params = roll_text.split('k')
      return k_roll(params[0].to_i,params[1].to_i,10)
    elsif /^\d+k\d+e\d+$/.match?(roll_text)
      params = roll_text.split(/[ek]/)
      return k_roll(params[0].to_i,params[1].to_i,params[2].to_i)
    end

  end

  def d_roll(dice,sides)
    return -9999 if dice > 999
    prng = Random.new
    (1..dice).inject(0){ |sum , i| sum + prng.rand(sides) + 1 }
  end

  def k_roll(dice,kept,explode)
    return -9999 if explode <= 1 || dice > 999
    dice_pool = (1..dice).map { |i| k_single_roll(explode) }.sort.reverse
    kept = dice if kept > dice
    dice_pool = dice_pool.slice(0,kept)
    return dice_pool.inject(0) { |sum, i| sum + i }
  end

  def k_single_roll(explode)
    prng = Random.new
    roll = prng.rand(10) + 1
    roll += k_single_roll(explode) if roll >= explode
    roll
  end
end