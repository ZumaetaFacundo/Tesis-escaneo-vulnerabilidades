package ar.utn.frm;
import java.io.File;
import java.io.IOException;
import ar.utn.frm.escaner.vulnerabilidades.db.DatabaseConnection;
import java.sql.Connection;

public class Main {
    public static void main(String[] args) {

        try (Connection conn = DatabaseConnection.getConnection()) {
            System.out.println("Conexión exitosa a MySQL 🚀");
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
