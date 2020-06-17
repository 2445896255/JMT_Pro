package com.example.demo.model;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.Jwts;
import org.springframework.web.filter.GenericFilterBean;

import javax.security.sasl.SaslException;
import javax.servlet.FilterChain;
import javax.servlet.ServletException;
import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.security.SignatureException;

/**
 * 这个类声明了一个JWT过滤器类，从Http请求中提取JWT的信息，并使用了”secretkey”这个密匙对JWT进行验证
 */
public class JwtFilter extends GenericFilterBean {
    @Override
    public void doFilter(ServletRequest servletRequest, ServletResponse servletResponse, FilterChain filterChain) throws IOException, ServletException {

        HttpServletRequest httpServletRequest= (HttpServletRequest) servletRequest;
        HttpServletResponse httpServletResponse=(HttpServletResponse) servletResponse;

        String authHeader=httpServletRequest.getHeader("Authorization");


        if("OPTIONS".equals(httpServletRequest.getMethod()))
        {
            httpServletResponse.setStatus(HttpServletResponse.SC_OK);
            filterChain.doFilter(httpServletRequest,httpServletResponse);
        }
        else
        {
            if(authHeader==null||!authHeader.startsWith("Bearer"))
            {
                throw new ServletException("Missing or invalid Authorization header");
            }

            String token=authHeader.substring(7);

            Claims claims = Jwts.parser().setSigningKey("secretkey").parseClaimsJws(token).getBody();
            httpServletRequest.setAttribute("claims", claims);

            filterChain.doFilter(servletRequest,servletResponse);
        }
    }
}
