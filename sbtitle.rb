# Program to adjust time in a movie subtitle. The input to the program should be path to the subtitle file and adjust time in seconds (positive value to increase and negative value to decrease time). The program then creates a new subtitle file with adjusted time without changing.
class EditSubtitles

  attr_accessor :main_file, :adjustment_Time, :new_file_name

  def initialize mainfilename, adjustment, newfilename

    @main_file = mainfilename
    @adjustment_Time = adjustment
    @new_file_name = newfilename
  end

  def adjustSubtitles

    newfile=File.new(@new_file_name, 'w')

    File.foreach(main_file).with_index do |current_line|
      if (current_line.to_s.include? '-->')

        durations = current_line.to_s.split("-->")
        current_line = ""
        durations.each do |duration|

          if (current_line != "")
            current_line += " --> "
          end

          hour, min, second_with_millisecond= duration.to_s.split(":")
          second_only, millisecond = second_with_millisecond.to_s.split(",")

          hour = hour.to_i
          min = min.to_i
          second_only = second_only.to_i
          millisecond = millisecond.to_i

          millisecond += @adjustment_Time
          second_only += millisecond / 1000
          millisecond = millisecond % 1000
          min += second_only / 60
          second_only = second_only % 60
          hour += min / 60
          min = min % 60

          if (hour < 0)
            hour, min, second_only, millisecond = '00', '00', '00', '000'
          end

          hour = hour.to_s.rjust(2, '0')
          min = min.to_s.rjust(2, '0')
          second_only = second_only.to_s.rjust(2, '0')
          millisecond = millisecond.to_s.rjust(3, '0')
          current_line += "#{hour}:#{min}:#{second_only},#{millisecond}"

        end
      end

      newfile.puts(current_line)

    end
    newfile.close
    puts 'File successfully created'


  end
end

puts "Please enter file name in current Directory"
filename = gets.chomp.to_s
if (File::exist?(filename))
  puts "Please enter adjustment time in millisecond(- for delay)"
  adjustmentTime = Integer(gets) rescue 0

  ask_for_new_file_name = true
  while ask_for_new_file_name

    puts "Please enter new file name that you want to save "
    newfilename = gets.chomp.to_s

    if (File::exist?(newfilename))
      puts "File with filename #{newfilename} is already exist."
      ask_for_new_file_name = true
    elsif (File.extname(newfilename)!= '.srt')
      puts "File extenstion must be in srt"
      ask_for_new_file_name = true
    else
      ask_for_new_file_name = false
    end

  end

  s1=EditSubtitles.new filename, adjustmentTime, newfilename
  s1.adjustSubtitles
elsif (File.extname(filename)!= '.srt')
  puts "File extenstion must be in srt"
else
  puts "File not found "
end
