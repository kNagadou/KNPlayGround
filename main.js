/**
 * Created by k_nagadou on 11/20/15.
 */
var MTRand = require('./js/mt.js')
    ,mt = new MTRand.MersenneTwister();

test_MTRand();

function test_MTRand() {

    for (var i = 0; i < 10; i++) {
        console.log(mt.next());
    }
}