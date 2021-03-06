class BookSerializer < ActiveModel::Serializer
  attributes :id, :title, :description, :price, :cover, :author, :publisher

  def price
  	object.formated_price
  end

  def cover
  	object.cover.url
  end

end
