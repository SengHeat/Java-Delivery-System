package com.delivery;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.boot.autoconfigure.domain.EntityScan;

@SpringBootApplication(scanBasePackages = "com.delivery")
@EntityScan("com.delivery.domain.personalAccessToken.model")
public class DeliverySystemApplication {
	public static void main(String[] args) {
		SpringApplication.run(DeliverySystemApplication.class, args);
	}
}


