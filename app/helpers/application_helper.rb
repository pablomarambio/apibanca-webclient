module ApplicationHelper
	def human_dep_count count
		number_to_human(count, units: {thousand: "k", million: "M"})
	end
end
