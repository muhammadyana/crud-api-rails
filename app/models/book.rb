# == Schema Information
#
# Table name: books
#
#  id          :bigint(8)        not null, primary key
#  title       :string
#  slug        :string
#  author      :string
#  cover       :string
#  publisher   :string
#  description :string
#  genre       :string
#  price       :decimal(, )      default(0.0)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Book < ApplicationRecord
end
