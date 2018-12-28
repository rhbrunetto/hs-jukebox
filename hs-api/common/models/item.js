'use strict';

module.exports = function(Item) {

  Item.enqueue = (body, callback) => {
    const a = new Item();
    console.log(body);
    a.url = body;
    a.title = 'Nameless';
    a.duration = 100;
    Item.create(a, (err, record) => {
      if (err) callback(err);
      else callback(null, record);
    });
  }

  Item.remoteMethod(
    'enqueue', {
      accepts: { arg: 'body', type: 'string' },
      http: {
        verb: 'post'
      }
    })

};
