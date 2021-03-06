module ApplicationHelper
  def dress_select(f, property, dress)
    f.select property.downcase.to_sym, options_from_collection_for_select(DressConsist.where(property: property), :id, :title, default_dress_consists(dress, property)), include_blank: false, label: false
  end

  def default_dress_consists(dress, property)
    dress_consists = dress.dress_consists.where(property: property).first
    dress_consists.id if dress_consists.present?
  end
end
