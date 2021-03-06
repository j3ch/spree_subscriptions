FactoryGirl.define do
  factory :subscribable_variant, parent: :base_variant do
    frequency = Spree::OptionType.find_or_create_by(name: 'frequency', presentation: 'frequency')
    two_weeks = Spree::OptionValue.find_or_create_by({ name: 2, presentation: 'Every 2 weeks', option_type: frequency })
    sku = "subscribe-to-me-#{Spree::Variant.count}"

    after(:create) do |variant|
      variant.option_values << two_weeks

      build(:stock_item, variant: variant)
    end
  end

  factory :subscribable_product, parent: :base_product do
    variant   = FactoryGirl.create(:subscribable_variant)
    after(:create) do |product|
      product.variants << variant
    end
  end
end
