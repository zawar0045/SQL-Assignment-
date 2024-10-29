import java.sql.*;
import java.util.Scanner;

public class ProductCRUD {
    private static final String URL = "jdbc:mysql://localhost:3306/yourDatabase";
    private static final String USERNAME = "yourUsername";
    private static final String PASSWORD = "yourPassword";

    private static Connection connect() throws SQLException {
        return DriverManager.getConnection(URL, USERNAME, PASSWORD);
    }

    public static void createProduct(int id, String name, String category, double price) {
        try (Connection conn = connect();
             PreparedStatement pstmt = conn.prepareStatement("INSERT INTO product (id, name, category, price) VALUES (?, ?, ?, ?)")) {
            pstmt.setInt(1, id);
            pstmt.setString(2, name);
            pstmt.setString(3, category);
            pstmt.setDouble(4, price);
            pstmt.executeUpdate();
            System.out.println("Product created successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void readProduct(String filter, String value) {
        String query = "SELECT * FROM product WHERE " + filter + " = ?";
        try (Connection conn = connect();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, value);
            ResultSet rs = pstmt.executeQuery();
            while (rs.next()) {
                System.out.println("ID: " + rs.getInt("id") + ", Name: " + rs.getString("name") + 
                                   ", Category: " + rs.getString("category") + ", Price: " + rs.getDouble("price"));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void updateProduct(int id, String name, String category, double price) {
        String query = "UPDATE product SET name = ?, category = ?, price = ? WHERE id = ?";
        try (Connection conn = connect();
             PreparedStatement pstmt = conn.prepareStatement(query)) {
            pstmt.setString(1, name);
            pstmt.setString(2, category);
            pstmt.setDouble(3, price);
            pstmt.setInt(4, id);
            pstmt.executeUpdate();
            System.out.println("Product updated successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void deleteProduct(int id) {
        try (Connection conn = connect();
             PreparedStatement pstmt = conn.prepareStatement("DELETE FROM product WHERE id = ?")) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            System.out.println("Product deleted successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        // Sample usage with user prompts (for demonstration)
        System.out.println("Choose operation: 1. Create 2. Read 3. Update 4. Delete");
        int choice = scanner.nextInt();
        
        switch (choice) {
            case 1: // Create
                System.out.print("Enter ID, Name, Category, Price: ");
                int id = scanner.nextInt();
                String name = scanner.next();
                String category = scanner.next();
                double price = scanner.nextDouble();
                createProduct(id, name, category, price);
                break;
                
            case 2: // Read
                System.out.print("Enter filter (id/name/category) and value: ");
                String filter = scanner.next();
                String value = scanner.next();
                readProduct(filter, value);
                break;
                
            case 3: // Update
                System.out.print("Enter ID, new Name, new Category, new Price: ");
                id = scanner.nextInt();
                name = scanner.next();
                category = scanner.next();
                price = scanner.nextDouble();
                updateProduct(id, name, category, price);
                break;
                
            case 4: // Delete
                System.out.print("Enter ID to delete: ");
                id = scanner.nextInt();
                deleteProduct(id);
                break;
                
            default:
                System.out.println("Invalid choice.");
        }
        scanner.close();
    }
}
