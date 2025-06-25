@thinking_login
Feature: Login de usuario

  Background:
    * url baseUrl
    * def loginUrl = '/users/login'

  Scenario: Login exitoso con credenciales válidas
    Given path loginUrl
    And request { 
      email: 'estebancossiogonzalez1@gmail.com', 
      password: 'password123' 
    }
    When method POST
    Then status 200
    And match response.token == '#string'
    And match response.user.email == 'estebancossiogonzalez1@gmail.com'
    * def authToken = response.token

  Scenario: Login fallido con credenciales inválidas
    Given path loginUrl
    And request { email: 'invalido@ejemplo.com', password: 'malapassword' }
    When method POST
    Then status 401
    # No body expected in 401, so no match for response content

  Scenario: Reutilizar token JWT para obtener contactos
    # Login
    Given path loginUrl
    And request { 
      email: 'estebancossiogonzalez1@gmail.com', 
      password: 'password123' 
    }
    When method POST
    Then status 200
    * def authToken = response.token

    # Obtener contactos
    Given path '/contacts'
    And header Authorization = 'Bearer ' + authToken
    When method GET
    Then status 200
    And match response == '#[0]' # Al menos un contacto registrado
    And match response[0] == { 
      _id: '#string',
      firstName: '#string',
      lastName: '#string',
      birthdate: '#string',
      email: '#string',
      phone: '#string',
      street1: '#string',
      street2: '#string',
      city: '#string',
      stateProvince: '#string',
      postalCode: '#string',
      country: '#string',
      owner: '#string',
      __v: '#number'
    }

  Scenario: Login con campos vacíos
    Given path loginUrl
    And request { email: '', password: '' }
    When method POST
    Then status 401

  Scenario: Login con email inválido (sin @)
    Given path loginUrl
    And request { email: 'correo-invalido', password: 'password123' }
    When method POST
    Then status 401
