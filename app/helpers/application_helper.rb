module ApplicationHelper
  GRADE = ["F", "D", "D", "D+", "C", "C+", "B", "B+", "A", "A+"]
  def s(score, options = {})
    if current_user && (current_user.id == options[:user_id] || current_user.finished_registration?)
      if score.is_a? Float
        '%.2f' % score
      else
        score.to_s
      end
    else
      I18n.t('assessments.blinded_score')
    end
  end

  def c(content, options = {})
    if current_user && (current_user.id == options[:user_id] || current_user.finished_registration?)
      content
    else
      I18n.t('assessments.blinded_content')
    end
  end

  def g(score)
    GRADE[score - 1]
  end

  def g_option
    GRADE.map{|g| [g, GRADE.rindex(g) + 1]}.uniq
  end
end
