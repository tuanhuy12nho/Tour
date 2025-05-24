/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package DAO;

import db.DBContext;
import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import model.Tour;

/**
 *
 * @author USA
 */
public class TourDAO extends DBContext {

    // Method to retrieve all tours from the database
    public ArrayList<Tour> getAllTours() {
        // Initialize an empty ArrayList to store the tour records
        ArrayList<Tour> tours = new ArrayList<>();
        // SQL query to select all tours from the Tour table
        String query = "SELECT * FROM Tour";

        // Use try-with-resources to automatically close database resources
        try ( Connection conn = getConnection(); // Establish database connection
                  PreparedStatement ps = conn.prepareStatement(query); // Prepare the SQL query
                  ResultSet rs = ps.executeQuery()) {  // Execute the query and get the result set

            // Check if the connection is null (though this check is redundant due to try-with-resources)
            if (conn == null) {
                System.out.println("❌ Unable to connect to the database");
                return null;
            }

            // Loop through each row in the result set
            while (rs.next()) {
                // Create a new Tour object with the retrieved data
                Tour tour = new Tour(
                        rs.getInt("id"), // Tour ID
                        rs.getString("name"), // Tour name
                        rs.getString("location"), // Tour location
                        rs.getBigDecimal("price"), // Tour price
                        rs.getString("transport"), // Mode of transport
                        rs.getString("description"), // Tour description
                        rs.getDate("startDate"), // Start date
                        rs.getDate("endDate"), // End date
                        rs.getString("image_url") // Image URL (corrected column name in DB)
                );
                // Add the tour object to the list
                tours.add(tour);
                // Debug statement to print the name of the retrieved tour
                System.out.println("📌 Retrieved tour: " + tour.getName());
            }

            // Debug statement to print the total number of tours retrieved
            System.out.println("✅ Total tours retrieved: " + tours.size());

        } catch (SQLException ex) {
            // Print an error message if a SQL query error occurs
            System.out.println("❌ SQL Query Error: " + ex.getMessage());
        }
        // Return the list of tours
        return tours;
    }

    // Method to retrieve a tour by its ID from the database
    public Tour getTourById(int id) {
        // Initialize the tour variable as null
        Tour tour = null;
        // SQL query to select a tour by its ID
        String sql = "SELECT * FROM Tour WHERE id = ?";

        // Use try-with-resources to automatically close database resources
        try ( PreparedStatement pstmt = conn.prepareStatement(sql)) {  // Prepare the SQL query
            // Set the tour ID as the parameter in the query
            pstmt.setInt(1, id);
            try ( ResultSet rs = pstmt.executeQuery()) {  // Execute the query and get the result set
                // Check if a tour is found
                if (rs.next()) {
                    // Create a new Tour object with the retrieved data
                    tour = new Tour(
                            rs.getInt("id"), // Tour ID
                            rs.getString("name"), // Tour name
                            rs.getString("location"), // Tour location
                            rs.getBigDecimal("price"), // Tour price
                            rs.getString("transport"), // Mode of transport
                            rs.getDate("startDate"), // Start date
                            rs.getDate("endDate") // End date
                    );
                    // Set the description separately (possibly due to constructor limitations)
                    tour.setDescription(rs.getString("description"));
                }
            }
        } catch (SQLException e) {
            // Print the stack trace if a database error occurs
            e.printStackTrace();
        }
        // Return the tour object (or null if not found)
        return tour;
    }

    // Method to retrieve tours with filtering by type and pagination
    public List<Tour> getToursByFilter(String type, int offset, int limit) {
        // Initialize an empty list to store the tour records
        List<Tour> tours = new ArrayList<>();
        // SQL query to select distinct tours with filtering by type, ordered by start date, with pagination
        String sql = "SELECT DISTINCT * FROM Tour "
                + "WHERE (? IS NULL OR type = ?) "
                + "ORDER BY startDate ASC " // Order by departure date
                + "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";  // Implement pagination

        // Use try-with-resources to automatically close database resources
        try ( Connection conn = new DBContext().getConnection(); // Establish database connection
                  PreparedStatement stmt = conn.prepareStatement(sql)) {  // Prepare the SQL query

            // Set the type parameter for filtering (can be null to select all types)
            stmt.setString(1, type);
            stmt.setString(2, type);
            // Set the offset for pagination
            stmt.setInt(3, offset);
            // Set the limit for pagination
            stmt.setInt(4, limit);

            // Execute the query and get the result set
            ResultSet rs = stmt.executeQuery();
            // Loop through each row in the result set
            while (rs.next()) {
                // Create a new Tour object with the retrieved data and add it to the list
                tours.add(new Tour(
                        rs.getInt("id"), // Tour ID
                        rs.getString("name"), // Tour name
                        rs.getString("location"), // Tour location
                        rs.getBigDecimal("price"), // Tour price
                        rs.getString("transport"), // Mode of transport
                        rs.getString("description"), // Tour description
                        rs.getDate("startDate"), // Start date
                        rs.getDate("endDate"), // End date
                        rs.getString("image_url"), // Image URL
                        rs.getString("type") // Tour type
                ));
            }
        } catch (SQLException e) {
            // Print the stack trace if a database error occurs
            e.printStackTrace();
        }
        // Return the list of filtered tours
        return tours;
    }

    // Method to retrieve tours with filtering by type, sorting, and pagination
    public List<Tour> getSortedTours(String type, String sort, int offset, int limit) {
        // Initialize an empty list to store the tour records
        List<Tour> tours = new ArrayList<>();
        // Base SQL query to select distinct tours with filtering by type (case-insensitive)
        String sql = "SELECT DISTINCT id, name, location, price, transport, description, startDate, endDate, image_url, type "
                + "FROM Tour WHERE (? IS NULL OR (type IS NULL OR UPPER(type) = UPPER(?))) "; // Fixed condition for case-insensitive comparison

        // Add sorting condition based on the sort parameter
        if ("priceAsc".equals(sort)) {
            sql += "ORDER BY price ASC ";  // Sort by price in ascending order
        } else if ("priceDesc".equals(sort)) {
            sql += "ORDER BY price DESC ";  // Sort by price in descending order
        } else {
            sql += "ORDER BY id ASC ";  // Default sorting by ID in ascending order
        }

        // Add pagination to the query
        sql += "OFFSET ? ROWS FETCH NEXT ? ROWS ONLY";

        // Use try-with-resources to automatically close database resources
        try ( Connection conn = new DBContext().getConnection(); // Establish database connection
                  PreparedStatement stmt = conn.prepareStatement(sql)) {  // Prepare the SQL query
            // Set the type parameter for filtering (can be null to select all types)
            stmt.setString(1, type);  // First parameter: check if type is null
            stmt.setString(2, type);  // Second parameter: compare with type if not null (case-insensitive)
            // Set the offset for pagination
            stmt.setInt(3, offset);
            // Set the limit for pagination
            stmt.setInt(4, limit);

            // Execute the query and get the result set
            ResultSet rs = stmt.executeQuery();
            // Loop through each row in the result set
            while (rs.next()) {
                // Create a new Tour object with the retrieved data and add it to the list
                tours.add(new Tour(
                        rs.getInt("id"), // Tour ID
                        rs.getString("name"), // Tour name
                        rs.getString("location"), // Tour location
                        rs.getBigDecimal("price"), // Tour price
                        rs.getString("transport"), // Mode of transport
                        rs.getString("description"), // Tour description
                        rs.getDate("startDate"), // Start date
                        rs.getDate("endDate"), // End date
                        rs.getString("image_url"), // Image URL
                        rs.getString("type") // Tour type
                ));
            }
        } catch (SQLException e) {
            // Print the stack trace if a database error occurs
            e.printStackTrace();
        }
        // Return the list of sorted tours
        return tours;
    }

    // Method to get the total number of distinct tours, optionally filtered by type
    public int getTotalTours(String tourType) {
        // SQL query to count distinct tours with filtering by type (case-insensitive)
        String sql = "SELECT COUNT(DISTINCT id) FROM Tour WHERE (? IS NULL OR (type IS NULL OR UPPER(type) = UPPER(?)))";

        // Use try-with-resources to automatically close database resources
        try ( Connection conn = new DBContext().getConnection(); // Establish database connection
                  PreparedStatement stmt = conn.prepareStatement(sql)) {  // Prepare the SQL query
            // Set the type parameter for filtering (can be null to count all types)
            stmt.setString(1, tourType);
            stmt.setString(2, tourType);
            // Execute the query and get the result set
            ResultSet rs = stmt.executeQuery();
            // Check if a result is found
            if (rs.next()) {
                // Return the total count of distinct tours
                return rs.getInt(1);
            }
        } catch (SQLException e) {
            // Print the stack trace if a database error occurs
            e.printStackTrace();
        }
        // Return 0 if an error occurs or no tours are found
        return 0;
    }

    // Main method to test the TourDAO class
    public static void main(String[] args) {
        // Create an instance of TourDAO to interact with the Tour table
        TourDAO tourDAO = new TourDAO();

        // Call the getAllTours method to retrieve the list of tours
        List<Tour> tours = tourDAO.getAllTours();

        // Check if the list of tours is null or empty
        if (tours == null || tours.isEmpty()) {
            // Print a message if no tours are found or the database connection failed
            System.out.println("No tours found or database connection failed.");
        } else {
            // Print the total number of tours found
            System.out.println("Total tours found: " + tours.size());
            // Loop through each tour in the list and print its details
            for (Tour tour : tours) {
                System.out.println("-----------------------------");
                System.out.println("ID: " + tour.getId());
                System.out.println("Tour Name: " + tour.getName());
                System.out.println("Location: " + tour.getLocation());
                System.out.println("Price: " + tour.getPrice());
                System.out.println("Transport: " + tour.getTransport());
                System.out.println("Description: " + tour.getDescription());
                System.out.println("Start Date: " + tour.getStartDate());
                System.out.println("End Date: " + tour.getEndDate());
                System.out.println("Image: " + tour.getImageUrl());
            }
        }
    }
}
