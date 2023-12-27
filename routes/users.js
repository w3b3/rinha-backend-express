const express = require("express");
const router = express.Router();

/* GET users listing. */
router.get("/", async (req, res, next) => {
  /*req.db.client.query('SELECT * FROM users', function(err, result) {
        if (err) {
        return next(err);
        }
        res.send(result.rows);
    });*/
  try {
    const result = await req.db.query(
      "SELECT email FROM users ORDER BY created_on DESC LIMIT 100",
    );
    const { command, rowCount, rows } = result;
    console.info(command, rowCount);
    console.table(rows);
    res.json({ command, rowCount, rows });
  } catch (error) {
    console.error("Error executing query:", error);
    res.status(500).json(error.detail);
  }
});

// add a new user
router.post("/", async (req, res, next) => {
  const { name, email } = req.body;

  if (!name || !email) {
    console.log("Missing name or email", name, email);
    console.log("\n");
    return res.status(400).send("Missing name or email");
  }

  // regex to validate email
  const emailRegex = /^[^\s@]+([_\.-]?[^\s@]+)*@[^\s@]+\.[^\s@]+$/;

  // validate email
  if (!emailRegex.test(email) || email.length < 5) {
    return res.status(400).send("Invalid email");
  }

  // regex to guarantee that the name contains only letters
  const onlyLettersRegex = /[^a-zA-Z]/g;

  //   validate name
  if (name.length < 3 || name.length > 255 || onlyLettersRegex.test(name)) {
    console.log("Name must be at 3 to 255 characters", name);
    console.log("\n");
    return res.status(400).send("Name must be at 3 to 255 characters");
  }

  try {
    const result = await req.db.query(
      "INSERT INTO users (name, email) VALUES ($1, $2)",
      [name, email],
    );
    const { command, rowCount } = result;
    console.info(command, rowCount);
    // add a line break
    console.log("\n");
    res.json({ command, email });
  } catch (error) {
    console.error("Error executing query:", error);
    console.log("\n");
    res.status(500).send("foo");
  }
});

module.exports = router;
