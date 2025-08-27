package app.cli;

import app.*;
import picocli.*;
import picocli.CommandLine.*;    

// https://picocli.info/quick-guide.html#_what_is_picocli 

@Command(name = "app", version = "0.0.1", mixinStandardHelpOptions = true)
public class Main implements Runnable {

  public static void main(String[] args) {
    new CommandLine(new Main()).execute(args);
  }
  
  @Override
  public void run() {
    System.out.println(new Runner());
  }
  
}