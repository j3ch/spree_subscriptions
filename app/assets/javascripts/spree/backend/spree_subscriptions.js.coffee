$(document).ready ->
  #handle edit click
  $('a.edit-subscription-item').click toggleSubscriptionItemEdit

  #handle cancel click
  $('a.cancel-subscription-item').click toggleSubscriptionItemEdit

  #handle save click
  $('a.save-subscription-item').click ->
    save = $ this
    subscription_item_id = save.data('subscription-item-id')
    quantity = parseInt(save.parents('tr').find('input.subscription_item_quantity').val())

    toggleItemEdit()
    adjustSubscriptionItem(subscription_item_id, quantity)
    false

  # handle delete
  $('a.delete-subscription-item').click ->
    if confirm(Spree.translations.are_you_sure_delete)
      del = $(this);
      subscription_item_id = del.data('subscription-item-id');

      toggleItemEdit()
      deleteSubscriptionItem(subscription_item_id)

  # handle adding 
  $('#add_subscription_item_variant_id').change ->
    variant_id = parseInt($(this).val())
    variant = _.find(window.variants, (variant) ->
      variant.id == variant_id
    )
    
    $('#stock_details').html variantLineItemTemplate(variant: variant)
    $('#stock_details').show()
    $('button.add_variant').click addSubscriptionVariant
    # Add some tips
    $('.with-tip').powerTip
      smartPlacement: true
      fadeInTime: 50
      fadeOutTime: 50
      intentPollInterval: 300


toggleSubscriptionItemEdit = ->
  link = $(this);
  link.parent().find('a.edit-subscription-item').toggle();
  link.parent().find('a.cancel-subscription-item').toggle();
  link.parent().find('a.save-subscription-item').toggle();
  link.parent().find('a.delete-subscription-item').toggle();
  link.parents('tr').find('td.subscription-item-qty-show').toggle();
  link.parents('tr').find('td.subscription-item-qty-edit').toggle();

  false

subscriptionItemURL = (subscription_id, subscription_item_id) ->
  url = Spree.pathFor('api/subscriptions/' + subscription_id + '/subscription_items/' + subscription_item_id)

adjustSubscriptionItem = (subscription_item_id, quantity) ->
  url = subscriptionItemURL(subscription_id, subscription_item_id)
  $.ajax(
    type: "PUT",
    url: Spree.url(url),
    data:
      subscription_item:
        quantity: quantity
      token: Spree.api_key
  ).done (msg) ->    
    show_flash 'success', 'Successfully updated the quantity.'
    $('.subscription-item-qty-show').text(quantity)
    $('a.edit-subscription-item').trigger 'click'

deleteSubscriptionItem = (subscription_item_id) ->
  url = Spree.pathFor('api/subscriptions/' + subscription_id + '/subscription_items/' + subscription_item_id)
  $.ajax(
    type: "DELETE"
    url: Spree.url(url)
    data:
      token: Spree.api_key
  ).done (msg) ->
    $('#subscription-item-' + subscription_item_id).remove()
    if $('.subscription-items tr.subscription-item').length == 0
      $('.subscription-items').remove()


addSubscriptionVariant = ->
  $('#stock_details').hide()
  variant_id = $('input.variant_autocomplete').val()
  quantity = $('input.quantity[data-variant-id=\'' + variant_id + '\']').val()
  adjustSubscriptionItems subscription_id, variant_id, quantity
  1

adjustSubscriptionItems = (subscription_id, variant_id, quantity) ->
  url = Spree.pathFor('api/subscriptions/' + subscription_id + '/subscription_items')
  $.ajax(
    type: 'POST'
    url: Spree.url(url)
    data:
      subscription_item:
        variant_id: variant_id
        quantity: quantity
      token: Spree.api_key).done (msg) ->
#    window.location.reload()