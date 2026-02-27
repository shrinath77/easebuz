package com.easybuzz.util;
import java.io.InputStream;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;
import java.util.Properties;

public class DBConnection {

    private static String URL;
    private static String USER;
    private static String PASSWORD;
    private static String DRIVER;

    static {
        try {
            Properties props = new Properties();
            InputStream input = DBConnection.class
                    .getClassLoader()
                    .getResourceAsStream("application.properties");

            if (input == null) {
                throw new RuntimeException("application.properties not found in classpath");
            }

            props.load(input);

            URL      = props.getProperty("db.url");
            USER     = props.getProperty("db.username");
            PASSWORD = props.getProperty("db.password");
            DRIVER   = props.getProperty("db.driver");

            Class.forName(DRIVER);
            System.out.println("[DBConnection] MySQL Driver Loaded Successfully");
            System.out.println("[DBConnection] DB URL = " + URL);

        } catch (ClassNotFoundException e) {
            // Driver JAR missing — log clearly but do NOT throw, so Tomcat still starts
            System.err.println("[DBConnection] ERROR: MySQL Driver not found on classpath — " + e.getMessage());
        } catch (Exception e) {
            // Config error — log clearly but do NOT throw, so Tomcat still starts
            System.err.println("[DBConnection] ERROR: Failed to load DB properties — " + e.getMessage());
        }
    }

    public static Connection getConnection() {
        try {
            Connection conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Database Connected Successfully!");
            return conn;
        } catch (SQLException e) {
            System.out.println("Database Connection Failed!");
            e.printStackTrace();
            return null;
        }
    }
}