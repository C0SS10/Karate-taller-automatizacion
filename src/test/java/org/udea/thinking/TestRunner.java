package org.udea.thinking;

import com.intuit.karate.junit5.Karate;

class TestRunner {

  @Karate.Test
  Karate test01_ThinkingLogin() {
    return Karate.run("/login/login")
        .relativeTo(getClass())
        .outputCucumberJson(true);
  }

  @Karate.Test
  Karate test02_ThinkingCreateContact() {
    return Karate.run("contacts/create-contact")
        .relativeTo(getClass())
        .outputCucumberJson(true);
  }

}