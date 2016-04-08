Feature: User can be an admin of a Brigade

  As an admin user
    I can activate or deactivate a Brigade
    I can make other users an admin of the same Brigade

  Scenario
    Given I was the creator of the Brigade or was made admin by another admin
    Then I should be an admin of said Brigade
