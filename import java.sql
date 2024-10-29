import java.sql.*;
import java.util.Scanner;

public class ProductManager {

    private static final String URL = "jdbc:mysql://localhost:3306/your_database";
    private static final String USER = "your_username";
    private static final String PASSWORD = "your_password";
    private Connection conn;

    public ProductManager() {
        try {
            conn = DriverManager.getConnection(URL, USER, PASSWORD);
            System.out.println("Connected to the database.");
            createProductTable();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    private void createProductTable() {
        String createTableSQL = "CREATE TABLE IF NOT EXISTS product ("
                + "id INT PRIMARY KEY NOT NULL, "
                + "name VARCHAR(50), "
                + "category VARCHAR(50), "
                + "price DECIMAL(10, 2) CHECK (price >= 0)"
                + ")";
        try (Statement stmt = conn.createStatement()) {
            stmt.execute(createTableSQL);
            System.out.println("Product table created or already exists.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void createProduct() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter product ID: ");
        int id = scanner.nextInt();
        scanner.nextLine();
        System.out.print("Enter product name: ");
        String name = scanner.nextLine();
        System.out.print("Enter product category: ");
        String category = scanner.nextLine();
        System.out.print("Enter product price: ");
        double price = scanner.nextDouble();

        String insertSQL = "INSERT INTO product (id, name, category, price) VALUES (?, ?, ?, ?)";
        try (PreparedStatement pstmt = conn.prepareStatement(insertSQL)) {
            pstmt.setInt(1, id);
            pstmt.setString(2, name);
            pstmt.setString(3, category);
            pstmt.setDouble(4, price);
            pstmt.executeUpdate();
            System.out.println("Product added successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void readProduct() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter search type (ID/Name/Category): ");
        String type = scanner.nextLine().toLowerCase();
        String query = "SELECT * FROM product WHERE ";

        switch (type) {
            case "id":
                System.out.print("Enter product ID: ");
                int id = scanner.nextInt();
                query += "id = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    pstmt.setInt(1, id);
                    displayResults(pstmt);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                break;
            case "name":
                System.out.print("Enter product name: ");
                String name = scanner.nextLine();
                query += "name = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    pstmt.setString(1, name);
                    displayResults(pstmt);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                break;
            case "category":
                System.out.print("Enter product category: ");
                String category = scanner.nextLine();
                query += "category = ?";
                try (PreparedStatement pstmt = conn.prepareStatement(query)) {
                    pstmt.setString(1, category);
                    displayResults(pstmt);
                } catch (SQLException e) {
                    e.printStackTrace();
                }
                break;
            default:
                System.out.println("Invalid search type.");
                break;
        }
    }

    private void displayResults(PreparedStatement pstmt) throws SQLException {
        ResultSet rs = pstmt.executeQuery();
        while (rs.next()) {
            System.out.println("ID: " + rs.getInt("id") + ", Name: " + rs.getString("name")
                    + ", Category: " + rs.getString("category") + ", Price: " + rs.getDouble("price"));
        }
    }

    public void updateProduct() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter product ID to update: ");
        int id = scanner.nextInt();
        scanner.nextLine();
        System.out.print("Enter new name: ");
        String name = scanner.nextLine();
        System.out.print("Enter new category: ");
        String category = scanner.nextLine();
        System.out.print("Enter new price: ");
        double price = scanner.nextDouble();

        String updateSQL = "UPDATE product SET name = ?, category = ?, price = ? WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(updateSQL)) {
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

    public void deleteProduct() {
        Scanner scanner = new Scanner(System.in);
        System.out.print("Enter product ID to delete: ");
        int id = scanner.nextInt();

        String deleteSQL = "DELETE FROM product WHERE id = ?";
        try (PreparedStatement pstmt = conn.prepareStatement(deleteSQL)) {
            pstmt.setInt(1, id);
            pstmt.executeUpdate();
            System.out.println("Product deleted successfully.");
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public void closeConnection() {
        try {
            if (conn != null && !conn.isClosed()) {
                conn.close();
                System.out.println("Connection closed.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }

    public static void main(String[] args) {
        ProductManager manager = new ProductManager();
        Scanner scanner = new Scanner(System.in);

        while (true) {
            System.out.println("\n1. Create Product\n2. Read Product\n3. Update Product\n4. Delete Product\n5. Exit");
            System.out.print("Choose an option: ");
            int choice = scanner.nextInt();

            switch (choice) {
                case 1:
                    manager.createProduct();
                    break;
                case 2:
                    manager.readProduct();
                    break;
                case 3:
                    manager.updateProduct();
                    break;
                case 4:
                    manager.deleteProduct();
                    break;
                case 5:
                    manager.closeConnection();
                    System.out.println("Exiting...");
                    return;
                default:
                    System.out.println("Invalid choice. Please try again.");
                    break;
            }
        }
    }
}
