
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
import model.AdminBooking;
import model.Booking;

/**
 *
 * @author kloane
 */
public class AdminStatisticsDAO extends DBContext {

    // Method to calculate the total revenue for a specific month, year, and tour type from the Statistics table
    public double getRevenueByMonth(int month, int year, String tourType) {
        // SQL query to sum the total revenue from the Statistics table for the given month, year, and tour type
        String query = "SELECT SUM(s.total_revenue) FROM [Statistics] s "
                + "WHERE s.month = ? AND s.year = ? AND s.tour_type = ?";

        // Initialize the revenue variable to 0
        double revenue = 0;
        // Create a new DBContext instance to manage database connections
        DBContext databaseConnection = new DBContext();

        // Use try-with-resources to automatically close database resources
        try ( Connection conn = databaseConnection.getConnection(); // Establish database connection
                  PreparedStatement ps = conn.prepareStatement(query)) {  // Prepare the SQL query
            // Set the month as the first parameter in the query
            ps.setInt(1, month);
            // Set the year as the second parameter in the query
            ps.setInt(2, year);
            // Set the tour type as the third parameter in the query
            ps.setString(3, tourType);
            // Execute the query and get the result set
            ResultSet rs = ps.executeQuery();

            // Check if there is a result and retrieve the revenue
            if (rs.next()) {
                revenue = rs.getDouble(1);  // Get the sum of total revenue from the first column
            }
        } catch (SQLException e) {
            // Print the stack trace if a database error occurs
            e.printStackTrace();
        }
        // Return the calculated revenue
        return revenue;
    }

    // Method to get the total number of bookings for a specific month, year, and tour type from the Statistics table
    public int getBookingCountByMonth(int month, int year, String tourType) {
        // SQL query to sum the total number of bookings from the Statistics table for the given month, year, and tour type
        String query = "SELECT SUM(s.total_bookings) FROM [Statistics] s "
                + "WHERE s.month = ? AND s.year = ? AND s.tour_type = ?";

        // Initialize the count variable to 0
        int count = 0;
        // Create a new DBContext instance to manage database connections
        DBContext databaseConnection = new DBContext();

        // Use try-with-resources to automatically close database resources
        try ( Connection conn = databaseConnection.getConnection(); // Establish database connection
                  PreparedStatement ps = conn.prepareStatement(query)) {  // Prepare the SQL query
            // Set the month as the first parameter in the query
            ps.setInt(1, month);
            // Set the year as the second parameter in the query
            ps.setInt(2, year);
            // Set the tour type as the third parameter in the query
            ps.setString(3, tourType);
            // Execute the query and get the result set
            ResultSet rs = ps.executeQuery();

            // Check if there is a result and retrieve the booking count
            if (rs.next()) {
                count = rs.getInt(1);  // Get the sum of total bookings from the first column
            }
        } catch (SQLException e) {
            // Print the stack trace if a database error occurs
            e.printStackTrace();
        }
        // Return the total number of bookings
        return count;
    }

    // Method to retrieve detailed booking information for a specific month, year, and tour type
    public List<AdminBooking> getRevenueDetailsByMonth(int month, int year, String tourType) {
        // Initialize an empty list to store the booking records
        List<AdminBooking> bookingList = new ArrayList<>();

        // SQL query to fetch detailed booking information for confirmed bookings in the specified month, year, and tour type
        String query = "SELECT b.id AS Booking_ID, u.full_name AS Customer_Name, "
                + "u.phone_number AS Phone, u.email AS Email, "
                + "t.startDate AS Departure, t.location AS Destination, "
                + "t.price AS Price, (t.price * b.numberOfPeople) AS Total_Amount, "
                + "b.status AS Booking_Status, "
                + "t.tourType AS Tour_Type " // Include the tour type from the Tour table
                + "FROM Booking b "
                + "JOIN Tour t ON b.tourId = t.id "
                + "JOIN [User] u ON b.userId = u.id "
                + "WHERE MONTH(b.bookingDate) = ? "
                + "AND YEAR(b.bookingDate) = ? "
                + "AND b.status = 'Confirmed' " // Only include confirmed bookings
                + "AND t.tourType = ?";  // Filter by the specified tour type

        // Use try-with-resources to automatically close database resources
        try ( Connection conn = new DBContext().getConnection(); // Establish database connection
                  PreparedStatement ps = conn.prepareStatement(query)) {  // Prepare the SQL query
            // Set the month as the first parameter in the query
            ps.setInt(1, month);
            // Set the year as the second parameter in the query
            ps.setInt(2, year);
            // Set the tour type as the third parameter in the query
            ps.setString(3, tourType);  // Assign the tour type parameter

            // Execute the query and get the result set
            ResultSet rs = ps.executeQuery();

            // Loop through each row in the result set
            while (rs.next()) {
                // Create a new AdminBooking object for each row
                AdminBooking booking = new AdminBooking();
                // Set the booking ID
                booking.setId(rs.getInt("Booking_ID"));
                // Set the customer's full name
                booking.setCustomerName(rs.getString("Customer_Name"));
                // Set the customer's phone number
                booking.setPhone(rs.getString("Phone"));
                // Set the customer's email
                booking.setEmail(rs.getString("Email"));
                // Set the departure date of the tour
                booking.setDeparture(rs.getDate("Departure"));
                // Set the tour destination
                booking.setDestination(rs.getString("Destination"));
                // Set the tour price
                booking.setPrice(rs.getDouble("Price"));
                // Set the total amount (price * number of people)
                booking.setTotalAmount(rs.getDouble("Total_Amount"));
                // Set the booking status
                booking.setPaymentStatus(rs.getString("Booking_Status"));
                // Set the tour type
                booking.setTourType(rs.getString("Tour_Type"));  // Add tour type information

                // Add the booking object to the list
                bookingList.add(booking);
            }
        } catch (SQLException e) {
            // Print the stack trace if a database error occurs
            e.printStackTrace();
        }
        // Return the list of booking details
        return bookingList;
    }

    // Method to retrieve all confirmed booking details for revenue reporting
    public List<AdminBooking> getAllRevenueDetails() {
        // Initialize an empty list to store the booking records
        List<AdminBooking> bookingList = new ArrayList<>();

        // SQL query to fetch all confirmed booking details by joining Booking, Tour, and User tables
        String query = "SELECT "
                + "b.id AS Booking_ID, "
                + "u.full_name AS Customer_Name, "
                + "u.phone_number AS Phone, "
                + "u.email AS Email, "
                + "t.startDate AS Departure, "
                + "t.location AS Destination, "
                + "t.price AS Price, "
                + "b.status AS Payment_Status, "
                + "(t.price * b.numberOfPeople) AS Total_Amount "
                + "FROM Booking b "
                + "JOIN Tour t ON b.tourId = t.id "
                + "JOIN [User] u ON b.userId = u.id "
                + "WHERE b.status = 'Confirmed'";  // Only include confirmed bookings

        // Use try-with-resources to automatically close database resources
        try ( Connection conn = new DBContext().getConnection(); // Establish database connection
                  PreparedStatement ps = conn.prepareStatement(query); // Prepare the SQL query
                  ResultSet rs = ps.executeQuery()) {  // Execute the query and get the result set

            // Loop through each row in the result set
            while (rs.next()) {
                // Create a new AdminBooking object for each row
                AdminBooking booking = new AdminBooking();
                // Set the booking ID
                booking.setId(rs.getInt("Booking_ID"));
                // Set the customer's full name
                booking.setCustomerName(rs.getString("Customer_Name"));
                // Set the customer's phone number
                booking.setPhone(rs.getString("Phone"));
                // Set the customer's email
                booking.setEmail(rs.getString("Email"));
                // Set the departure date of the tour
                booking.setDeparture(rs.getDate("Departure"));
                // Set the tour destination
                booking.setDestination(rs.getString("Destination"));
                // Set the tour price
                booking.setPrice(rs.getDouble("Price"));
                // Set the total amount (price * number of people)
                booking.setTotalAmount(rs.getDouble("Total_Amount"));
                // Set the payment status
                booking.setPaymentStatus(rs.getString("Payment_Status"));
                // Add the booking object to the list
                bookingList.add(booking);
            }

            // Debug statement to print the number of bookings found
            System.out.println("📢 DEBUG: Tìm thấy " + bookingList.size() + " bookings.");

        } catch (SQLException e) {
            // Print the stack trace if a database error occurs
            e.printStackTrace();
        }
        // Return the list of all confirmed booking details
        return bookingList;
    }

    // Method to calculate the total revenue for a specific month and year from confirmed bookings
    public double getTotalRevenueByMonth(int month, int year) {
        // SQL query to calculate the total revenue from confirmed bookings for the specified month and year
        String query = "SELECT COALESCE(SUM(t.price * b.numberOfPeople), 0) AS total_revenue "
                + "FROM Booking b "
                + "JOIN Tour t ON b.tourId = t.id "
                + "WHERE MONTH(b.bookingDate) = ? AND YEAR(b.bookingDate) = ? "
                + "AND b.status = 'Confirmed'";  // Only include confirmed bookings

        // Initialize the revenue variable to 0
        double revenue = 0;

        // Use try-with-resources to automatically close database resources
        try ( Connection conn = new DBContext().getConnection(); // Establish database connection
                  PreparedStatement ps = conn.prepareStatement(query)) {  // Prepare the SQL query
            // Set the month as the first parameter in the query
            ps.setInt(1, month);
            // Set the year as the second parameter in the query
            ps.setInt(2, year);

            // Execute the query and get the result set
            ResultSet rs = ps.executeQuery();
            // Check if there is a result and retrieve the total revenue
            if (rs.next()) {
                revenue = rs.getDouble("total_revenue");  // Get the total revenue from the result
            }
        } catch (SQLException e) {
            // Print the stack trace if a database error occurs
            e.printStackTrace();
        }

        // Return the calculated total revenue
        return revenue;
    }
}
