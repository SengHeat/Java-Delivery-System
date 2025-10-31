package com.delivery.domain.personalAccessToken.model;

import com.delivery.shared.exception.BusinessRuleException;

import java.util.Objects;

public class TokenName {
    private final String value;

    public TokenName(String value) {
        if (value == null || value.trim().isEmpty()) {
            throw new BusinessRuleException("Token name cannot be empty");
        }
        if (value.length() > 100) {
            throw new BusinessRuleException("Token name cannot exceed 100 characters");
        }
        this.value = value.trim();
    }

    public String getValue() {
        return value;
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        TokenName that = (TokenName) o;
        return Objects.equals(value, that.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value);
    }
}
