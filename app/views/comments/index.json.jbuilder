json.array!(@comments) do |comment|
  json.extract! comment, :id, :commenttext, :author, :blogpost_id
  json.url comment_url(comment, format: :json)
end
