class LecturesController < ApplicationController
  before_filter :fetch_top_standings

  def index
    @assessments = Assessment.paginate(page: params[:page] || 1)
  end

  def search
    @query = params[:query]
    @query.gsub!(/[+\-|!(){}\[\]\^"~*?:\\]/, "\\\\\\0") if @query

    if @query && @query.length > 0
      @result = Lecture.search("*#{@query}*", :page => params[:page] || 1, :load => true)
    else
      @result = Lecture.paginate :page => params[:page] || 1
    end
  end

  def show
    @lecture = Lecture.find params[:id]
    @lecture.update_hit_count

    @assessment = current_user.assessment_for(@lecture) || Assessment.new
    @assessments = @lecture.assessments.all

    @presentation_score_count = [0, 0, 0, 0, 0]
    @workload_score_count = [0, 0, 0, 0, 0]
    @grading_score_count = [0, 0, 0, 0, 0]

    @assessments.each do |a|
      ps = g(a.presentation_score)
      ws = g(a.workload_score)
      gs = g(a.grading_score)
      
      if ps == "A" || ps == "A+"
        @presentation_score_count[0] += 1;
      elsif ps == "B" || ps == "B+"
        @presentation_score_count[1] += 1;
      elsif ps == "C" || ps == "C+"
        @presentation_score_count[2] += 1;
      elsif ps == "D" || ps == "D+"
        @presentation_score_count[3] += 1;
      else
        @presentation_score_count[4] += 1;
      end
      
      if ws == "A" || ws == "A+"
        @workload_score_count[0] += 1;
      elsif ws == "B" || ws == "B+"
        @workload_score_count[1] += 1;
      elsif ws == "C" || ws == "C+"
        @workload_score_count[2] += 1;
      elsif ws == "D" || ws == "D+"
        @workload_score_count[3] += 1;
      else
        @workload_score_count[4] += 1;
      end

      if gs == "A" || gs == "A+"
        @grading_score_count[0] += 1;
      elsif gs == "B" || gs == "B+"
        @grading_score_count[1] += 1;
      elsif gs == "C" || gs == "C+"
        @grading_score_count[2] += 1;
      elsif gs == "D" || gs == "D+"
        @grading_score_count[3] += 1;
      else
        @grading_score_count[4] += 1;
      end
 
   end
  end

  private
    def fetch_top_standings
      @lectures = Lecture.where('assessment_count >= ?', Lecture::MIN_NUMBER_OF_ASSESSMENTS).order('overall_score DESC').first(20)
    end
end
