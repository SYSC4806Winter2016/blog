json.array!(@blogposts) do |blogpost|
  json.extract! blogpost, :id, :title, :contents
  json.url blogpost_url(blogpost, format: :json)
end
