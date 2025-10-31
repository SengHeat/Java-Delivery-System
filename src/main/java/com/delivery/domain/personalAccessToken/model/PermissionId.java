package com.delivery.domain.personalAccessToken.model;

import com.delivery.domain.base.BaseId;

import java.util.UUID;

public class PermissionId extends BaseId {

    public PermissionId(UUID value) {
        super(value);
    }

    public static PermissionId generate() {
        return new PermissionId(UUID.randomUUID());
    }
}
