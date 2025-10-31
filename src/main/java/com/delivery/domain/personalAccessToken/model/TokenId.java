package com.delivery.domain.personalAccessToken.model;

import com.delivery.domain.base.BaseId;

import java.util.UUID;

public class TokenId extends BaseId {
    public TokenId(UUID value) {
        super(value);
    }

    public static TokenId generate() {
        return new TokenId(UUID.randomUUID());
    }
}
