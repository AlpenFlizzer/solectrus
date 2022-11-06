# @label RadialBadge::Component
class RadialBadgeComponentPreview < ViewComponent::Preview
  # @!group Percent
  def percent_min(percent: 0, title: 'Value')
    render RadialBadge::Component.new(percent:, title:)
  end

  def percent_low(percent: 25, title: 'Value')
    render RadialBadge::Component.new(percent:, title:)
  end

  def percent_medium(percent: 50, title: 'Value')
    render RadialBadge::Component.new(percent:, title:)
  end

  def percent_high(percent: 75, title: 'Value')
    render RadialBadge::Component.new(percent:, title:)
  end

  def percent_max(percent: 100, title: 'Value')
    render RadialBadge::Component.new(percent:, title:)
  end

  def percent_neutral(percent: 66, title: 'Value', neutral: true)
    render RadialBadge::Component.new(percent:, title:, neutral:)
  end
  # @!endgroup

  # @!group Money
  def money_low(title: 'Profit')
    render RadialBadge::Component.new(title:) do
      '€ 1<small>,23</small>'.html_safe
    end
  end

  def money_high(title: 'Profit')
    render RadialBadge::Component.new(title:) do
      '€ 1.429'
    end
  end
  # @!endgroup
end
