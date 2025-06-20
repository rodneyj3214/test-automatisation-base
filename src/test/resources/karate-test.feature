Feature: Pruebas automatizadas para la API de personajes de Marvel

  Background:
    * def url_ = "http://bp-se-test-cabcd9b246a5.herokuapp.com/rodneyj3214/api/characters"
    * def bodyRequest_ = read('data/CharacterObj.json')
    Given def urlBase = url_


  Scenario: T-MIC-TEST-CHAPTER-2025-CA1- Obtener todos los personajes (lista vacía)
    * url urlBase
    When method get
    Then status 200
    And match response == []

  Scenario: T-MIC-TEST-CHAPTER-2025-CA2 - Crear personaje (exitoso)
    * url urlBase
    * def bodyRequest = bodyRequest_
    Given request bodyRequest
    When method post
    Then status 201
    And match response contains bodyRequest

  Scenario: T-MIC-TEST-CHAPTER-2025-CA3 - Obtener personaje por ID (exitoso)
    * url urlBase
    Given path '1'
    When method get
    Then status 200
    And match response == { id: 1, name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }

  Scenario: T-MIC-TEST-CHAPTER-2025-CA4 - Obtener personaje por ID (no existe)
    * url urlBase
    Given path '999'
    When method get
    Then status 404
    And match response == { error: 'Character not found' }

  Scenario: T-MIC-TEST-CHAPTER-2025-CA5 - Crear personaje (nombre duplicado)
    * url urlBase
    Given request { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    When method post
    Then status 400
    And match response == { error: 'Character name already exists' }

  Scenario: T-MIC-TEST-CHAPTER-2025-CA6 - Crear personaje (faltan campos requeridos)
    * url urlBase
    Given request { name: '', alterego: '', description: '', powers: [] }
    When method post
    Then status 400
    And match response == { name: 'Name is required', alterego: 'Alterego is required', description: 'Description is required', powers: 'Powers are required' }

  Scenario: T-MIC-TEST-CHAPTER-2025-CA7 - Actualizar personaje (exitoso)
    * url urlBase
    Given path '1'
    * def bodyRequest = bodyRequest_
    * set bodyRequest.description = 'Updated description'
    And request  bodyRequest
    When method put
    Then status 200
    And match response.description == 'Updated description'

  Scenario: T-MIC-TEST-CHAPTER-2025-CA8 - Actualizar personaje (no existe)
    * url urlBase
    Given path '999'
    And request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    When method put
    Then status 404
    And match response == { error: 'Character not found' }

  Scenario: T-MIC-TEST-CHAPTER-2025-CA9 - Eliminar personaje (exitoso)
    * url urlBase
    Given path '1'
    When method delete
    Then status 204

  Scenario: T-MIC-TEST-CHAPTER-2025-CA10 - Eliminar personaje (no existe)
    * url urlBase
    Given path '999'
    When method delete
    Then status 404
    And match response == { error: 'Character not found' }