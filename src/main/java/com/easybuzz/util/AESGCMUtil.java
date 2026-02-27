package com.easybuzz.util;

import javax.crypto.Cipher;
import javax.crypto.spec.GCMParameterSpec;
import javax.crypto.spec.SecretKeySpec;
import java.security.SecureRandom;
import java.util.Base64;

public class AESGCMUtil {

    // AES Configuration
    private static final String ALGORITHM = "AES";
    private static final String TRANSFORMATION = "AES/GCM/NoPadding";
    private static final int GCM_TAG_LENGTH = 128; // 128-bit authentication tag

    // 32 bytes = AES-256 Key (Replace with your real Merchant Key)
    private static final String SECRET_KEY = "12345678901234567890123456789012";        ///secrate key

    /**
     * Encrypt JSON/Data using AES-256 GCM
     */
    public static String encrypt(String plainText) throws Exception {

        // Convert key to SecretKey
        byte[] keyBytes = SECRET_KEY.getBytes("UTF-8");
        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, ALGORITHM);

        // Generate 12-byte IV (recommended for GCM)
        byte[] iv = new byte[12];
        SecureRandom secureRandom = new SecureRandom();
        secureRandom.nextBytes(iv);

        // Initialize Cipher
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.ENCRYPT_MODE, secretKey, gcmSpec);

        // Encrypt data
        byte[] encryptedBytes = cipher.doFinal(plainText.getBytes("UTF-8"));

        // Combine IV + Encrypted Data (Important for decryption)
        byte[] combined = new byte[iv.length + encryptedBytes.length];
        System.arraycopy(iv, 0, combined, 0, iv.length);
        System.arraycopy(encryptedBytes, 0, combined, iv.length, encryptedBytes.length);

        // Return Base64 encoded string (Payment gateway standard)
        return Base64.getEncoder().encodeToString(combined);
    }

    /**
     * Decrypt AES-256 GCM encrypted data (Optional - for testing)
     */
    public static String decrypt(String encryptedData) throws Exception {

        byte[] decoded = Base64.getDecoder().decode(encryptedData);

        // Extract IV (first 12 bytes)
        byte[] iv = new byte[12];
        System.arraycopy(decoded, 0, iv, 0, 12);

        // Extract Cipher Text
        byte[] cipherText = new byte[decoded.length - 12];
        System.arraycopy(decoded, 12, cipherText, 0, cipherText.length);

        // Secret Key
        byte[] keyBytes = SECRET_KEY.getBytes("UTF-8");
        SecretKeySpec secretKey = new SecretKeySpec(keyBytes, ALGORITHM);

        // Decrypt 
        Cipher cipher = Cipher.getInstance(TRANSFORMATION);
        GCMParameterSpec gcmSpec = new GCMParameterSpec(GCM_TAG_LENGTH, iv);
        cipher.init(Cipher.DECRYPT_MODE, secretKey, gcmSpec);

        byte[] decryptedBytes = cipher.doFinal(cipherText);

        return new String(decryptedBytes, "UTF-8");
    }
}