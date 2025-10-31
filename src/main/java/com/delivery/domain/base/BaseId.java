package com.delivery.domain.base;

import java.io.Serializable;
import java.util.Objects;
import java.util.UUID;

public abstract class BaseId implements Serializable {

    private final UUID value;

    protected BaseId(UUID value) {
        if (value == null) {
            throw new IllegalArgumentException("UUID value cannot be null");
        }
        this.value = value;
    }

    public UUID getValue() {
        return value;
    }

    @Override
    public String toString() {
        return value.toString();
    }

    @Override
    public boolean equals(Object o) {
        if (this == o) return true;
        if (o == null || getClass() != o.getClass()) return false;
        BaseId baseId = (BaseId) o;
        return Objects.equals(value, baseId.value);
    }

    @Override
    public int hashCode() {
        return Objects.hash(value);
    }
}
