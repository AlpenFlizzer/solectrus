class MenuItem::Component < ViewComponent::Base
  def initialize(
    name:,
    href: nil,
    data: {},
    field: nil,
    icon: nil,
    current: false
  )
    super
    @name = name
    @href = href
    @data = data
    @field = field

    @icon = icon
    @current = current
  end

  def target
    href&.start_with?('http') ? '_blank' : nil
  end

  attr_reader :name, :href, :icon, :current, :data, :field

  CSS_CLASSES = %w[block w-full].freeze
  private_constant :CSS_CLASSES

  def call(with_icon: false, css_extra: nil)
    return tag.hr(class: 'my-2 hidden lg:block') if name == '-'

    if href
      render_link(with_icon:, css_extra:)
    else
      render_button(with_icon:, css_extra:)
    end
  end

  def render_link(with_icon:, css_extra:)
    link_to href,
            target:,
            class: [CSS_CLASSES, css_extra],
            data: @data,
            'aria-current' => current ? 'page' : nil do
      tag.div class: 'flex items-center justify-between gap-2' do
        render_inner(with_icon:)
      end
    end
  end

  def render_button(with_icon:, css_extra:)
    tag.button class: [CSS_CLASSES, css_extra], data: @data do
      render_inner(with_icon:)
    end
  end

  def render_inner(with_icon:)
    tag.div class: 'flex items-center gap-3' do
      if with_icon
        concat(
          if icon
            tag.i(class: "w-6 text-gray-500 fa fa-fw fa-#{@icon} fa-lg")
          else
            tag.span(class: 'w-6 block')
          end,
        )
      end

      concat(tag.div(class: 'flex-1 text-left') { name })
    end
  end
end
