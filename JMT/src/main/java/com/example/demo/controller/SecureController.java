package com.example.demo.controller;


import com.example.demo.model.RespResult;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

/**
 * check the jwt, if the token is valid then return "Login Successful"
 * If is not valid, the request will be intercepted by JwtFilter
 **/
@RestController
@RequestMapping("/secure")
public class SecureController {

    @RequestMapping("/micro")
    public RespResult loginSuccess()
    {

        RespResult result = new RespResult();
        result.setStatuscode("200 OK");
        result.setMessage("Login Successful!");
        return result;


        //return "Login Successful!";
    }
}
