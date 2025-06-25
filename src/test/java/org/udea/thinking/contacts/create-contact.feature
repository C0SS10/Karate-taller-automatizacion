@thinking_create_contact
Feature: Crear contacto vía API con datos dinámicos usando Faker

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def contactsUrl = '/contacts'
    * def registerUrl = '/users'
    * def loginUrl = '/users/login'
    * def Faker = Java.type('com.github.javafaker.Faker')
    * def faker = new Faker()
    * def randomEmail = faker.internet().emailAddress()
    * def password = 'password123'

    * def newUser = 
    """
    {
      "firstName": "Esteban",
      "lastName": "Cossio",
      "email": "estebangonzalez888@hotmail.es",
      "password": "password123"
    }
    """

    # Registrar usuario
    Given path registerUrl
    And request newUser
    When method POST
    Then status 201
    * print '✅ Usuario registrado:', newUser.email

    # Login con el nuevo usuario
    Given path loginUrl
    And request { email: 'estebangonzalez888@hotmail.es', password: '#(password)' }
    When method POST
    Then status 200
    * def authToken = response.token
    * print '✅ TOKEN:', authToken

    # Definir datos del contacto
    * def contact = 
    """
    {
      "firstName": "#(faker.name().firstName())",
      "lastName": "#(faker.name().lastName())",
      "birthdate": "1999-10-12",
      "email": "#(faker.internet().emailAddress())",
      "phone": "#(faker.phoneNumber().subscriberNumber(9))",
      "street1": "#(faker.address().streetAddress())",
      "street2": "#(faker.address().secondaryAddress())",
      "city": "#(faker.address().city())",
      "stateProvince": "#(faker.address().state())",
      "postalCode": "#(faker.address().zipCode())",
      "country": "#(faker.address().country())"
    }
    """

  Scenario: Crear contacto con token JWT y Faker
    Given path contactsUrl
    And header Authorization = 'Bearer ' + authToken
    And request contact
    When method POST
    Then status 201
    * def contactId = response._id
    * print '✅ Contacto creado:', response

    # Validar que el contacto fue creado
    Given path contactsUrl
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200
    * def found = response.find(x => x._id == contactId)
    Then assert found != null

  Scenario: Error al crear contacto sin `firstName`
    Given path contactsUrl
    And header Authorization = 'Bearer ' + authToken
    And request
    """
    {
      "lastName": "Test1023",
      "birthdate": "1999-10-12",
      "email": "user4521@test.com",
      "phone": "644332165",
      "street1": "Street 60",
      "street2": "Apt 73",
      "city": "City98",
      "stateProvince": "State31",
      "postalCode": "88150",
      "country": "Country0"
    }
    """
    When method POST
    Then status 400
    And match response.message contains 'firstName: Path `firstName` is required.'
