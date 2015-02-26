require 'spec_helper'

feature 'Judge enters the evaluations panel and' do
  attr_reader :organization, :evaluation_with_no_criteria,
               :evaluation_with_criteria, :judge, :evaluation, :entries

  before do
    @judge = create :judge
    @organization = create :organization
    challenge_with_no_criteria = create :challenge, organization: organization
    challenge_with_criteria = create :challenge, :with_criteria, organization: organization

    @evaluation_with_no_criteria = create :evaluation, challenge: challenge_with_no_criteria, judge: @judge
    @evaluation_with_criteria = create :evaluation, challenge: challenge_with_criteria, judge: @judge
    @entries = entries_with_different_members(3, challenge_with_criteria)

    # manually create the report cards
    @evaluation_with_criteria.initialize_report_cards

    sign_in_user(@judge)
  end

  scenario 'lists the first entry for a challenge.' do
    # for this scenario we're using a challenge_with_criteria
    click_on evaluation_with_criteria.challenge.title

    expect(evaluation_with_criteria.challenge.entries.count).to eq entries.length
    expect(page).to have_content entries.first.name
  end

  scenario 'starts a evaluating the all entries for a challenge.' do
    # for this scenario we're using a challenge_with_criteria
    click_on evaluation_with_criteria.challenge.title

    expect(page).to have_content "0%"

    evaluate(entries[0], 3)
    page_should_not_have_prev_entry_link
    expect(page).to have_content "34%"
    navigate_to_next_entry

    evaluate(entries[1], 4)
    expect(page).to have_content "67%"
    page_should_have_prev_entry_link
    page_should_have_next_entry_link

    navigate_to_next_entry

    evaluate(entries[2], 5)
    expect(page).to have_content "100%"
    page_should_have_prev_entry_link

    page_should_not_have_next_entry_link
  end

  scenario 'starts a evaluating when a challenge has no criteria been set.' do
    # for this scenario we're using a challenge_with_no_criteria
    click_on evaluation_with_no_criteria.challenge.title
    expect(page).to have_content I18n.t('evaluations.index.no_evaluation_criteria', email: organization.email)
  end

  scenario 'sees a different description when admin changes the criteria' do
    admin_updates_criteria_definition
    sign_in_user(@judge)
    click_on evaluation_with_criteria.challenge.title
    check_for_updated_criteria
  end

  def check_for_updated_criteria
    10.times { |idx| expect(page).to have_content "New criteria #{idx+1}" }
  end

  def admin_updates_criteria_definition
    click_link 'Cerrar sesión'
    sign_in_user(organization)
    click_link 'Jurado'
    click_link evaluation_with_criteria.challenge.title
    click_link I18n.t('dashboard.judges.index.define_criteria')
    update_criteria_fields
    click_link 'Cerrar sesión'
  end

  def update_criteria_fields
    10.times { |idx| all(:css, "#criteria__description")[idx].set("New criteria #{idx+1}") }
    click_on 'Guardar'
  end

  def set_criteria_fields_to(grade)
    10.times { |idx| all(:css, "#grades__value")[idx].set(grade) }
  end

  def navigate_to_next_entry
    click_on I18n.t('evaluations.index.next_entry')
  end

  def page_should_have_next_entry_link
    expect(page).to have_content I18n.t('evaluations.index.next_entry')
  end

  def page_should_have_prev_entry_link
    expect(page).to have_content I18n.t('evaluations.index.previous_entry')
  end

  def page_should_not_have_next_entry_link
    expect(page).to_not have_content I18n.t('evaluations.index.next_entry')
  end

  def page_should_not_have_prev_entry_link
    expect(page).to_not have_content I18n.t('evaluations.index.previous_entry')
  end
end
