Feature: Pruebas automatizadas para la API de personajes de Marvel

  Background:
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com/rodneyj3214/api/characters'

  Scenario: Obtener todos los personajes (lista vacía)
    Given path ''
    When method get
    Then status 200
    And match response == []

  Scenario: Obtener personaje por ID (exitoso)
    Given path '1'
    When method get
    Then status 200
    And match response == { id: 1, name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }

  Scenario: Obtener personaje por ID (no existe)
    Given path '999'
    When method get
    Then status 404
    And match response == { error: 'Character not found' }

  Scenario: Crear personaje (exitoso)
    Given request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }
    When method post
    Then status 201
    And match response contains { name: 'Iron Man', alterego: 'Tony Stark', description: 'Genius billionaire', powers: ['Armor', 'Flight'] }

  Scenario: Crear personaje (nombre duplicado)
    Given request { name: 'Iron Man', alterego: 'Otro', description: 'Otro', powers: ['Armor'] }
    When method post
    Then status 400
    And match response == { error: 'Character name already exists' }

  Scenario: Crear personaje (faltan campos requeridos)
    Given request { name: '', alterego: '', description: '', powers: [] }
    When method post
    Then status 400
    And match response == { name: 'Name is required', alterego: 'Alterego is required', description: 'Description is required', powers: 'Powers are required' }

  Scenario: Actualizar personaje (exitoso)
    Given path '1'
    And request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    When method put
    Then status 200
    And match response == { id: 1, name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }

  Scenario: Actualizar personaje (no existe)
    Given path '999'
    And request { name: 'Iron Man', alterego: 'Tony Stark', description: 'Updated description', powers: ['Armor', 'Flight'] }
    When method put
    Then status 404
    And match response == { error: 'Character not found' }

  Scenario: Eliminar personaje (exitoso)
    Given path '1'
    When method delete
    Then status 204

  Scenario: Eliminar personaje (no existe)
    Given path '999'
    When method delete
    Then status 404
    And match response == { error: 'Character not found' }