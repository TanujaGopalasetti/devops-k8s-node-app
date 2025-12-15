/*
  Super basic "test" so CI can run something.
  It just loads server.js to make sure there are no syntax errors.
*/
try {
  require("./server");
  console.log("ok");
  process.exit(0);
} catch (e) {
  console.error(e);
  process.exit(1);
}
