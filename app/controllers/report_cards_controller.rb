class ReportCardsController < ApplicationController
  layout 'judges'
  before_filter :set_report_card, only: :update
  before_filter :set_evaluation, only: :update

  def update
    # TODO: Refactor this update attributes to be more secure
    if @report_card.update_attributes(grades: params[:grades], comments: params[:comments], feedback: params[:feedback])
      flash[:notice] = if @report_card.entry.next.nil?
        I18n.t('report_cards.evaluation_has_been_saved_successfully')
      else
        I18n.t('report_cards.evaluation_has_been_saved_successfully_go_to_next',
              href: evaluations_path(challenge_id: @report_card.evaluation.challenge,
                            entry_id:  @report_card.entry.next))
      end
      OrganizationMailer.judge_finished_evaluating(@report_card.evaluation).deliver if @report_card.evaluation.status == FINISHED_EVALUATING_CHALLENGE
    else
      flash[:alert] = I18n.t('report_cards.there_was_an_error_while_saving_the_evaluation')
    end
    redirect_to evaluations_path(challenge_id: @report_card.evaluation.challenge, entry_id: @report_card.entry)
  end

  private

  def set_report_card
    @report_card ||= ReportCard.find(params[:id])
  end

  def set_evaluation
    @evaluation ||= Evaluation.find(params[:evaluation_id])
  end
end
