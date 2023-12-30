const express = require("express");
const router = express.Router();

/* GET users listing. */
router.get("/", async (req, res, next) => {
  try {
    const result = await req.db.query(
      "SELECT apelido, nome, stack FROM usuarios ORDER BY id DESC LIMIT 100",
    );
    const { command, rowCount, rows } = result;
    console.info(command, rowCount);
    console.table(rows);
    res.json({ command, rowCount, rows });
  } catch (error) {
    console.error("Error on query:", error);
    res.status(500).json({ error });
  }
});

// add a new user
router.post("/", async (req, res, next) => {
  const { apelido, nome, stack, nascimento } = req.body;

  if (!apelido || !nome || !nascimento) {
    console.log(
      "Falta apelido, nome, ou nascimento",
      apelido,
      nome,
      nascimento,
    );
    console.log("\n");
    return res
      .status(400)
      .send(
        "Falta apelido, nome, ou nascimento" +
          apelido +
          " " +
          nome +
          " " +
          nascimento,
      );
  }

  // regex to validate email
  // const emailRegex = /^[^\s@]+([_\.-]?[^\s@]+)*@[^\s@]+\.[^\s@]+$/;

  // validate email
  // if (!emailRegex.test(email) || email.length < 5) {
  //   return res.status(400).send("Invalid email");
  // }

  // regex to guarantee that the name contains only letters or spaces
  const onlyLettersRegex = /[a-zA-Z]/g;
  const onlyLettersOrWhitespaceRegex = /[a-zA-Z\s]/g;
  const dateRegex = /^\d{4}-\d{2}-\d{2}$/;

  //   validate name
  if (
    nome.length < 1 ||
    nome.length > 100
    // !onlyLettersOrWhitespaceRegex.test(nome)
  ) {
    console.log("Erro validacao nome:", nome);
    // console.log(
    //   "!onlyLettersOrWhitespaceRegex.test(nome)",
    //   !onlyLettersOrWhitespaceRegex.test(nome),
    // );
    console.log("\n");
    return res.status(400).send("Erro validacao nome: " + nome);
  }

  if (
    apelido.length < 1 ||
    apelido.length > 32
    // !onlyLettersRegex.test(apelido)
  ) {
    console.log("Erro validacao apelido", apelido);
    // console.log(
    //   "!onlyLettersRegex.test(apelido)",
    //   !onlyLettersRegex.test(apelido),
    // );
    console.log("\n");
    return res.status(400).send("Erro validacao apelido: " + apelido);
  }

  if (nascimento.length !== 10 || !dateRegex.test(nascimento)) {
    console.log("Erro validacao nascimento", nascimento);
    console.log("nascimento.length", nascimento.length !== 10);
    console.log("!dateRegex.test(nascimento)", !dateRegex.test(nascimento));
    console.log("\n");
    return res.status(400).send("Erro validacao nascimento: " + nascimento);
  }

  try {
    const result = await req.db.query(
      "INSERT INTO usuarios (apelido, nome, nascimento, stack) VALUES ($1, $2, $3, $4)",
      [apelido, nome, nascimento, stack],
    );
    const { command, rowCount } = result;
    console.info(command, rowCount);
    // add a line break
    console.log("\n");
    res.json({ command, apelido });
  } catch (error) {
    console.error("Error executing query:", error);
    console.log("\n");
    res.status(500).send(error);
  }
});

module.exports = router;
