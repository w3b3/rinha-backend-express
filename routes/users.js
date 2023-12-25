const express = require('express');
const router = express.Router();

/* GET users listing. */
router.get('/', async (req, res, next) => {
    // res.send('respond with a resource');
//   query select * from users from a postgresql database
    /*req.db.client.query('SELECT * FROM users', function(err, result) {
        if (err) {
        return next(err);
        }
        res.send(result.rows);
    });*/
    try {
        const result = await req.db.query('SELECT NOW()');
        res.json(result.rows);
    } catch (error) {
        console.error('Error executing query:', error);
        res.status(500).send('Internal Server Error');
    }
});

module.exports = router;
