package com.example.demo.service.impl;

import com.example.demo.dao.PersonRepository;
import com.example.demo.model.Person;
import com.example.demo.service.PersonService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class PersonServiceImpl implements PersonService {

    @Autowired
    private PersonRepository personRepository;

    /**
     * Save Person to Ignite DB
     * @param person Person object.
     * @return The Person object saved in Ignite DB.
     */
    public Person save(Person person) {
        // If this username is not used then return null, if is used then return this Person
        return personRepository.save(person.getId(), person);
    }

    /**
     * Find a Person from Ignite DB with given name.
     * @param name Person name.
     * @return The person found in Ignite DB
     */
    public Person findPersonByUsername(String name){
        return personRepository.findByUsername(name);
    }
}
