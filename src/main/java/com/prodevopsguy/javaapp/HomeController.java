package com.prodevopsguy.javaapp;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import java.time.LocalDateTime;

@Controller
public class HomeController {

    @Value("${app.version:1.0.0}")
    private String appVersion;

    @GetMapping("/")
    public String home(Model model) {
        model.addAttribute("appName", "JavaApp CI/CD Pipeline");
        model.addAttribute("version", appVersion);
        model.addAttribute("time", LocalDateTime.now());
        return "index";
    }

}

@RestController
class VersionController {

    @Value("${app.version:1.0.0}")
    private String appVersion;

    @GetMapping("/api/version")
    @ResponseBody
    public String version() {
        return "{\"app\":\"JavaApp-CICD\",\"version\":\"" + appVersion + "\"}";
    }

}
