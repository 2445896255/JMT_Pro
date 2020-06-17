package com.example.demo.service;


import com.example.demo.model.Person;

/**
 * Interface for handling SQL operator in PersonCache
 **/
public interface PersonService {

    /**
     *
     * @param person Person Object
     * @return The Person object saved in Ignite DB.
     */
    Person save(Person person);

    /**
     * Find a Person from Ignite DB with given name.
     * @param name Person name.
     * @return The person found in Ignite DB
     */
    Person findPersonByUsername(String name);

}
