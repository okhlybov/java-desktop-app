module app.javafx {
  requires app;
  exports app.javafx;
  requires javafx.fxml;
  requires javafx.controls;
  requires javafx.graphics;
  opens app.javafx to javafx.fxml, javafx.graphics;
}