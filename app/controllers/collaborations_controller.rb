class CollaborationsController < ApplicationController
  def create
    @challenge = Challenge.find(params[:challenge_id])
    current_member.collaborations.create(challenge: @challenge)
    redirect_to organization_challenge_path(@challenge.organization, @challenge), notice: t('challenges.collaborating')
  end
end
