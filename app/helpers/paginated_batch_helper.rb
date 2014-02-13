module PaginatedBatchHelper
	def paginate(batch)
		return "" if batch.pages == 1
		pages_to_show = Range.new([1,batch.page-1].max, [batch.page+1, batch.pages].min)
		page_links = ""
		pages_to_show.each do |i|
			page_links = page_links + <<-EOLINK
	<li class="#{batch.page == i ? "active" : ""}"">
		#{link_to i, params.merge({page: i})}
	</li>
			EOLINK
		end

		page_links = page_links + <<-EONEXT
	<li class="#{batch.page == batch.pages ? "disabled" : ""}">
		#{link_to ">", params.merge({page: batch.page + 1})}
	</li>
		EONEXT

		prev = <<-EOPREV
	<li class="#{batch.page > 1 ? "" : "disabled"}">
		#{link_to "<", params.merge({page: batch.page - 1})}
	</li>
		EOPREV
		page_links = prev + page_links


		min = <<-EOMIN
	<li class="#{pages_to_show.min > 1 ? "" : "disabled"}">
		#{link_to "<<", params.merge({page: 1})}
	</li>
		EOMIN
		page_links = min + page_links


		page_links = page_links + <<-EOMAX
	<li class="#{pages_to_show.max < batch.pages ? "" : "disabled"}">
		#{link_to ">>", params.merge({page: batch.pages})}
	</li>
		EOMAX


		res = <<-EOCONT
<ul class="pagination">
#{page_links}
</ul>
		EOCONT
		res.html_safe
	end
end