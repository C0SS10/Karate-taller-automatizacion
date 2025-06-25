function fn() {
  karate.configure("connectTimeout", 5000);
  karate.configure("readTimeout", 5000);

  var protocol = "https";
  var server = "thinking-tester-contact-list.herokuapp.com";

  if (karate.env == "local") {
    protocol = "http";
    server = "localhost:3000";
  }

  var config = {
    baseUrl: protocol + "://" + server,
  };

  config.faker = Java.type("com.github.javafaker.Faker");

  return config;
}
