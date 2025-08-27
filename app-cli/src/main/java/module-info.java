module app.cli {
  requires app;
  exports app.cli;
  requires info.picocli;
  opens app.cli to info.picocli;
}