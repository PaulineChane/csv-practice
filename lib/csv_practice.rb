# Pauline Chane (@PaulineChane on GitHub)
# Ada Developers Academy C14
# CSV Practice - csv_practice.rb
# 09/18/2020

# Writing methods to utilize Ruby's ability to read and parse CSV files as well as use TDD to pass methods to manipulate
# data provided by an external file. Includes responses to questions listed in documentation.

require 'csv'
require 'awesome_print'

# GET ALL OLYMPIC ATHLETES
# Before reading the test file, write down a description of 2 test cases that test the core functionality, and are nominal tests.
# RESPONSE
# Test Case 1: Verify that the output is an array of hashes, that is to say the return type is correct (array of hashes).
# Test Case 2: Verify that the function read the file and added the correct number of attributes (9 out of 15 attributes per athlete).

# Read through the tests in `test/csv_practice_test.rb`.
# How did we "Assert" and check that the method returns an array of hashes?
# RESPONSE
# "expect(olympic_athletes).must_be_instance_of Array" verifies the outer layer is an array (line 31).
# "olympic_athletes.each do |athlete|
#         # Check that each element in the array is a hash
#         expect(athlete).must_be_instance_of Hash
#         ...
#         end" block loops through each element of the array to confirm each element is a hash (lines 33-43)

# How did we "Assert" and check that the method returns an array of hashes with the correct keys?
# RESPONSE
# Continuing from the previous assert, as we verify that each element in the array is a hash, we also verify
# the keys with an array of the correct keys saved as a constant REQUIRED_OLYMPIAN_FIELDS in line 15 that each hash
# contains the correct keys in another code block within the block from lines 33-43:
#         "expect(athlete.keys.length).must_equal REQUIRED_OLYMPIAN_FIELDS.length
#         REQUIRED_OLYMPIAN_FIELDS.each do |required_field|
#           expect(athlete.keys).must_include required_field
#         end" (lines 39-41)

# How did we "Assert" and check that the method returns an accurate list of Olympic medalists?
# RESPONSE
# Knowing that there are a total of 49503 athletes, we check for the correct length of the array of hashes:
# "expect(olympic_athletes.length).must_equal 49503" (line 51)
# We also check that the first and last lines of the CSV file are copied correctly through checking the first 3 keys:
# "      # Arrange & Act
#       olympic_athletes = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)
#
#       # Assert
#       expect(olympic_athletes.first['ID']).must_equal '21'
#       expect(olympic_athletes.first['Name']).must_equal 'Ragnhild Margrethe Aamodt'
#       expect(olympic_athletes.first['Team']).must_equal 'Norway'
#       expect(olympic_athletes.last['ID']).must_equal '135568'
#       expect(olympic_athletes.last['Name']).must_equal 'Olga Igorevna Zyuzkova'
#       expect(olympic_athletes.last['Team']).must_equal 'Belarus'" (lines 55-64)

# What nominal tests did we miss?
# RESPONSE
# 1. Verify that the code does not modify the original file.
# 2. Verify that the header in the CSV has not been included as a separate hash element in the array.
# 3. Verify the correct information has been copied to the correct keys, in essence expanding upon the test case of
#    verifying an accurate list of medalists.

# Write down descriptions of 2 edge test cases that aren't in our tests. (Don't write the tests, just come up with your test cases for practice!)
# RESPONSE
# 1. Verifying that the correct file has been inputted, or rather the input file is correctly formatted.
# 2. Potentially invalid characters in, for instance, athlete names and how to print them correctly. (Or misspelled data)

# BEGIN CODE
# reads a file with an given filename (string parameter) and returns an array of hashes, where each hash contains athlete info from the file
# {attribute => info} for 9 different attributes per athlete
def get_all_olympic_athletes(filename)
  # maps by row athlete info and slices for 9 specific attributes we want in particular into an array of hashes
  athletes = CSV.read(filename, headers: true).map {|row| row.to_h.slice("ID","Name","Height","Team","Year","City","Sport","Event","Medal")}

  return athletes
end


# TOTAL MEDALS PER TEAM
# Before reading the test file, write down a description of 2 test cases that test the core functionality, and are nominal tests.
# RESPONSE
# Test Case 1: Verify that the output is a hash with no additional structures.
# Test Case 2: Verify the hash is accurate in team name and medal count for each key/value pair.

# Read through the tests in `test/csv_practice_test.rb`.
# In the tests, how do we "Arrange" and setup the data of all Olympic athletes?
# RESPONSE
# A hash containing key/value pairs of countries and their medal counts (but only for select countries) is first created.
# These key/value pairs are compared against those produced by the function as the model data.

# How did we "Assert" and check that the method returns a hash?
# RESPONSE
# From the output of calling the function and storing it in a variable, a single line verifies that the structure
# out put is a hash:
# " expect(total_medals).must_be_instance_of Hash" (line 88)


# How did we "Assert" and check that the method returns an accurate hash?
# RESPONSE
# Using the values from the structure created in the "Arrange" step with the hash of some key-value pairs,
# the test can verify a sampling of matching key-value pairs in the output hash against this "mini-hash:"
# "      expected_totals.each do |expected_team, expected_count|
#         expect(total_medals[expected_team]).must_equal expected_count
#       end" (lines 89-91)

# What nominal tests did we miss?
# RESPONSE
# 1. Verify that the correct number of key/value pairs are in the hash.
# 2. Expand verification testing that each key/value pair is correct.

# Write down descriptions of 2 edge test cases that aren't in our tests. (Don't write the tests, just come up with your test cases for practice!)
# RESPONSE
# 1. Verify that the hash input can be verified as correct output from get_all_olympic_athletes.
# 2. How to account for medals won as part of a team?
# 3. How to account for countries that go by multiple names or have historically changed names or borders?

# receives an array of hashes containing olympic_data to return a hash containing countries (Team) for keys and number of medals won (Medals) for values.
def total_medals_per_team(olympic_data)
  # collect an array of all unique teams/countries in the data
  teams = olympic_data.map{|athlete| athlete["Team"]}.uniq

  # filter out all athletes who do not have a medal into an array of hashes
  athletes_with_medals = olympic_data.filter{|athlete| athlete["Medal"] != "NA"}

  # using the previous two structures, use the countries in teams of the keys and the counts of all medals per team as found in athletes_with_medals
  # create a hash (with the help of reduce/merge!) to return
  medals_per_team = teams.map{|team| {team => athletes_with_medals.count{|athlete| athlete["Team"] == team}}}.reduce({}, :merge).to_h

  return medals_per_team
end

# ALL GOLD MEDALISTS
# Write descriptions for 2 test cases that test the core functionality, and are nominal tests.
# RESPONSE
# 1. Verify that output is an array of hashes.
# 2. Verify that all elements have "Gold" as the value for their "Medal" key.

# Read through the tests in `test/csv_practice_test.rb`.
# In the tests, how do we "Arrange" and setup the data of all Olympic athletes?
# RESPONSE
# data was stored in an array of hashes generated by called the get_all_olympic_athletes function:
#   "data = get_all_olympic_athletes(OLYMPIC_DATA_FILENAME)" (line 99)

# How did we "Assert" and check that the method returns an array of hashes?
# How did we "Assert" and check that the method returns an accurate list of only gold medalists?
# RESPONSE
# The above two cases are checked in a single code block (and a line before that). First, the following statement
# verifies that the outer layer is an array:
# "expect(all_gold_medalists).must_be_instance_of Array" (line 105)
#
# Then, an each loop iterates over each element to 1) confirm that the element is a hash, and
# 2) there exists a "Medal" => "Gold" key-value pair:
#  "all_gold_medalists.each do |medalist|
#         expect(medalist).must_be_instance_of Hash
#         expect(medalist['Medal']).must_equal "Gold"
#       end" (lines 106-109)"

# What nominal tests did we miss?
# RESPONSE
# 1. Verify the correct number of gold medalists were captured in the output.
# 2. Verify that the remaining keys are correct and preserved in case of invalid input


# Write descriptions for 2 edge test cases that aren't in our tests. (Don't write the tests, just come up with your test cases for practice!)
# RESPONSE
# 1. How should athletes that won multiple gold medals be accounted for?
# 2. Again, how to account for gold medals won as part of a team?

# using an array of hashes full of athlete info, returns an array of hashes of all athletes who have won gold medals
def get_all_gold_medalists(olympic_data)
  # use filter to remove any athletes without gold medals
  return olympic_data.filter{|athlete| athlete["Medal"] == "Gold"}
end

# MOST MEDALS
# Come up with 2 test cases that test the core functionality, and are nominal tests. (I won't be focusing on these, mostly nominal.)
# 1. Returns a hash with the correct keys.
# 2. Keys point to correct values.

# Come up with 2 edge test cases.
# 1. How to account for team medals? Do they count as one or multiple?
# 2. How to account for territories undergoing political boundary changes (ex) Yugoslavia, East Germany)?
# 3. How to verify input is an output from total_medals_per_team?

# takes medal_totals, a hash assumed to be returned from total_medals_per_team, with "Team"=># Medals key/value pairs
# returns hash with team with highest number of values as hash {'Team' => #{TEAM NAME}, 'Count' => #{NUMBER OF MEDALS}}
def team_with_most_medals(medal_totals)
  # could also sort by medal in ascending or descending order, then pull the last or first element.
  # pull key/value pair for max value into array
  max_medals = medal_totals.max_by{|team, medals| medals}
  # return as formatted into hash
  return {'Team' => max_medals[0], 'Count' => max_medals[1]}
end

# MOST MEDALS
# Come up with 2 test cases that test the core functionality, and are nominal tests.
# 1. Returns an array of hashes that is a deep, not SHALLOW copy.
# 2. "Height" key value is correctly converted to inches.

# Come up with 2 edge test cases (I won't be focusing on these, mostly nominal.)
# 1. How to verify height in cm has been entered correctly and as an integer/float?
# 2. I think this is an edge case -- how to ensure the remaining key-value pairs are preserved? (input validation)

# returns a deep copy of olympic_data, containing stats of all athletes, where
def athlete_height_in_inches(olympic_data)
  # create deep copy
  olympic_data_in = olympic_data.clone

  # modify deep copy to convert all heights to inches
  # could refactor using map? but i think you have to individually add/edit all contents of the hash element per loop
  olympic_data_in.each do |athlete|
    athlete.update["Height"] = (((athlete["Height"].to_i) * 0.393701).to_i).to_s
  end

  return olympic_data_in

end