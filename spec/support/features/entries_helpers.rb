module EntriesHelpers
  def entries_with_different_members(number_of_entries, challenge)
    entries = []
    number_of_entries.times { |idx| entries << create(:entry,
              challenge: challenge,
              member: new_member,
              name: "Propuesta #{idx}",
              description: "This is a description #{idx}",
              idea_url: 'http://localhost:3000',
              technologies: ['PHP', 'Rust'],
              created_at: Time.zone.local(2014,4,25,10,52,24)
            )}
    entries
  end
end