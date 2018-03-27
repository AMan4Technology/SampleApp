module ApplicationHelper
  # 根据所在页面返回完整的标题
  def full_title(page_title = '')
    base_title = 'Ruby on Rails Tutorial Sample App'
    return base_title if page_title.empty?
    page_title + " | " + base_title
  end
end
