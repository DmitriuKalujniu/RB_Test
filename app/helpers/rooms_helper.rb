module RoomsHelper
  MONTHS = %w[January February March April May June July August September October November December]

  def cloud_words room
    text = ''
    room.reviews.each do |review|
      text += "#{review.comment}"
    end
    words_with_count = {}
    words_array = text.downcase.split(/\W+/)

    stop_array = %w[the with and to was my for s an that of a this it by has if but he i as am g is are yuo we they in]

    words_array.each do |word|
      next if stop_array.include?(word  )
      if words_with_count[word].present?
        words_with_count[word] += 1
      else
        words_with_count[word] = 1
      end
    end
    words_with_count.to_a
  end

  def chart_data grouped_month_review
    amount_per_months = (1..12).map { |m|  0 }
    grouped_month_review.each do |index, count|
      amount_per_months[index - 1 ] = count
    end
    amount_per_months
  end
end
