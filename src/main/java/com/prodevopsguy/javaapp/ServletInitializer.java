package com.prodevopsguy.javaapp;

import org.springframework.boot.builder.SpringApplicationBuilder;
import org.springframework.boot.web.servlet.support.SpringBootServletInitializer;

/**
 * Required so this Spring Boot app can be packaged as a WAR
 * and deployed into an external Tomcat / Apache Tomcat server
 * (instead of only running via the embedded server / java -jar).
 */
public class ServletInitializer extends SpringBootServletInitializer {

    @Override
    protected SpringApplicationBuilder configure(SpringApplicationBuilder application) {
        return application.sources(JavaAppApplication.class);
    }

}
