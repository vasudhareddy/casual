package com.example.demo.dto;

import java.time.LocalDateTime;
import java.util.List;

public record ApiResponse<T>(
        LocalDateTime timestamp,
        String message,
        T data,
        List<String> errors
) {
    public static <T> ApiResponse<T> success(T data) {
        return new ApiResponse<>(LocalDateTime.now(), "Success", data, null);
    }

    public static <T> ApiResponse<T> error(String message, List<String> errors) {
        return new ApiResponse<>(LocalDateTime.now(), message, null, errors);
    }
}
