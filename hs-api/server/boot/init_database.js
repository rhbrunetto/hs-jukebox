module.exports = function (app) {

  var Item = app.models.Item

  var items = require('../../data/items.json')

  Item.create(items, (err, totem) => {
    if (err) {
      console.log(err)
    }
  })

}
