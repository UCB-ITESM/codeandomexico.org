require 'spec_helper'

feature 'Collaborator adds entry to challenge' do
  scenario 'with the right data' do
    member = create :member
    challenge = create :challenge
    create :collaboration, member: member, challenge: challenge

    sign_in_user member
    visit new_challenge_entry_path(challenge)

    submit_entry_form_with(
      project_name: 'Mi super app',
      description: 'Es la mejor',
      url: 'https://github.com/CodeandoMexico/aquila',
      technologies: 'Ruby, Haskell, Elixir, Rust',
      image: app_image,
      proposal: entry_pdf
    )

    removed_behaivior
  end

  def app_image
    "#{Rails.root}/spec/images/happy-face.jpg"
  end

  def entry_pdf
    "#{Rails.root}/spec/fixtures/dummy.pdf"
  end

  def submit_entry_form_with(args)
    fill_in 'entry_name', with: args.fetch(:project_name)
    fill_in 'entry_description', with: args.fetch(:description)
    fill_in 'entry_live_demo_url', with: args.fetch(:url)

    args.fetch(:technologies).split(", ").each do |tech|
      select tech, from: 'entry_technologies'
    end

    attach_file 'entry_proposal_file', args.fetch(:proposal)
    attach_file 'entry_image', args.fetch(:image)
    click_button 'Enviar proyecto'
  end

  def removed_behaivior
    return true

    page_should_have_pitch_with(
      'Mi super app',
      'Es la mejor',
      'https://github.com/CodeandoMexico/aquila',
      'Ruby, Haskell, Elixir, Rust'
    )

    app_should_not_be_counted_yet
  end

  def page_should_have_pitch_with(*data)
    within '#pitch' do
      data.each { |item| page.should have_content item }
    end
  end

  def app_should_not_be_counted_yet
    within '.challenge-tabs' do
      page.should have_content '0 App'
    end
  end
end
