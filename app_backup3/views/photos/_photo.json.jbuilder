json.extract! photo, :id, :image, :legend, :created_at, :updated_at
json.url photo_url(photo, format: :json)
