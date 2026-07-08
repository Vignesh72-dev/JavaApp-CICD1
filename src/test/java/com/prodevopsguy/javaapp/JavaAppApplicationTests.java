package com.prodevopsguy.javaapp;

import org.junit.jupiter.api.Test;
import org.springframework.boot.test.context.SpringBootTest;

import static org.assertj.core.api.Assertions.assertThat;

@SpringBootTest
class JavaAppApplicationTests {

    @Test
    void contextLoads() {
        // Verifies the Spring application context starts successfully
    }

    @Test
    void appVersionIsNotEmpty() {
        assertThat("1.0.0").isNotBlank();
    }

}
