@thinking_login
Feature: Login de usuario

  Background:
    * url baseUrl
    * header Accept = 'application/json'
    * def loginUrl = '/users/login'

  Scenario: Reutilizar token JWT para obtener contactos
    Given path loginUrl
    And request {email: 'estebancossiogonzalez1@gmail.com', password: 'password123'}
    When method POST
    Then status 200
    * def authToken = response.token
    * print 'TOKEN:', authToken

    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200
    Then assert response.length > 0
    And match response[0] contains { _id: '#string',firstName: '#string',lastName: '#string',birthdate: '#string',email: '#string',phone: '#string',street1: '#string',street2: '#string',city: '#string',stateProvince: '#string',postalCode: '#string',country: '#string',owner: '#string',__v: '#number'}

  Scenario: Login fallido con credenciales inválidas
    Given path loginUrl
    And request {email:'invalido@ejemplo.com', password:'malapassword'}
    When method POST
    Then status 401