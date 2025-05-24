package controller;

import DAO.AdminStatisticsDAO;
import java.io.IOException;
import java.util.List;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import model.AdminBooking;
import util.SessionLogin;

@WebServlet(name = "AdminStatisticsServlet", urlPatterns = {"/AdminStatisticsServlet"})
public class AdminStatisticsServlet extends HttpServlet {

    // Declare an instance of AdminStatisticsDAO to interact with the statistics database
    private AdminStatisticsDAO statisticsDAO;

    // Initialize the servlet and set up the AdminStatisticsDAO instance
    @Override
    public void init() throws ServletException {
        super.init();  // Call the parent class's init method
        statisticsDAO = new AdminStatisticsDAO();  // Initialize the DAO for statistics operations
    }

    // Method to handle HTTP GET requests for displaying statistics
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Check if the user is an admin; if not, redirect to the admin login page
        if (!SessionLogin.isAdmin(request)) {
            response.sendRedirect(request.getContextPath() + "/admin.jsp");
            return;
        }

        // Get the type parameter from the request to determine the type of statistics to display
        String type = request.getParameter("type");
        // Khi không có type (vừa vào trang) hoặc type="revenueAll", hiển thị toàn bộ doanh thu
        if (type == null || "revenueAll".equals(type)) {
            getAllRevenueDetails(request, response);
            return;
        }

        // Handle the request if the type is "revenueDetails"
        if ("revenueDetails".equals(type)) {
            try {
                // Parse the month and year parameters from the request
                int month = Integer.parseInt(request.getParameter("month"));
                int year = Integer.parseInt(request.getParameter("year"));
                // Get the tour type parameter (e.g., Domestic or International)
                String tourType = request.getParameter("tourType");

                // Retrieve revenue details and total revenue for the specified month, year, and tour type
                List<AdminBooking> revenueDetails = statisticsDAO.getRevenueDetailsByMonth(month, year, tourType);
                double totalRevenue = statisticsDAO.getTotalRevenueByMonth(month, year);

                // Set attributes to pass to the JSP page
                request.setAttribute("revenueDetails", revenueDetails);  // Revenue details list
                request.setAttribute("totalRevenue", totalRevenue);      // Total revenue
                request.setAttribute("month", month);                    // Selected month
                request.setAttribute("year", year);                      // Selected year
                request.setAttribute("tourType", tourType);              // Selected tour type

                // Forward the request to the statistics JSP page to display the results
                request.getRequestDispatcher("Admin/statistics.jsp").forward(request, response);
            } catch (NumberFormatException e) {
                // Handle invalid month or year format by setting an error message
                request.setAttribute("error", "Please enter a valid month and year.");
            }
        }

        // Handle the request if the type is "revenueAll"
        if ("revenueAll".equals(type)) {
            // Debug statement to indicate that all revenue details are being retrieved
            System.out.println("✅ DEBUG: Retrieving all revenue data...");
            // Call the method to get all revenue details
            getAllRevenueDetails(request, response);
            return;
        }

        // Handle the request if the type is "totalRevenue"
        if ("totalRevenue".equals(type)) {
            try {
                // Parse the month and year parameters from the request
                int month = Integer.parseInt(request.getParameter("month"));
                int year = Integer.parseInt(request.getParameter("year"));
                // Debug statement to indicate the total revenue retrieval for the specified month and year
                System.out.println("📌 DEBUG: Retrieving total revenue for month " + month + " year " + year);

                // Retrieve the total revenue for the specified month and year
                double totalRevenue = statisticsDAO.getTotalRevenueByMonth(month, year);
                // Set attributes to pass to the JSP page
                request.setAttribute("totalRevenue", totalRevenue);  // Total revenue
                request.setAttribute("month", month);                // Selected month
                request.setAttribute("year", year);                  // Selected year
                // Forward the request to the statistics JSP page to display the results
                request.getRequestDispatcher("Admin/statistics.jsp").forward(request, response);
                return;
            } catch (NumberFormatException e) {
                // Debug statement to indicate an error with invalid month or year
                System.out.println("🚨 ERROR: Invalid month or year!");
                // Set an error message for invalid input
                request.setAttribute("error", "Please enter a valid month and year.");
            }
        }

        // If the type parameter is not recognized, send an error response
        request.getRequestDispatcher("Admin/statistics.jsp").forward(request, response);
    }

    // Method to retrieve all revenue details without filtering by month or year
    private void getAllRevenueDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Debug statement to indicate that revenue data retrieval is in progress
            System.out.println("🔍 DEBUG: Retrieving revenue data...");

            // Retrieve all revenue details from the database
            List<AdminBooking> revenueDetails = statisticsDAO.getAllRevenueDetails();
            // Debug statement to indicate the number of records retrieved
            System.out.println("✅ DEBUG: Number of records retrieved: " + revenueDetails.size());

            // Set the revenue details as a request attribute to pass to the JSP page
            request.setAttribute("revenueDetails", revenueDetails);
            // Forward the request to the statistics JSP page to display the results
            request.getRequestDispatcher("Admin/statistics.jsp").forward(request, response);
        } catch (Exception e) {
            // Print the stack trace if an error occurs
            e.printStackTrace();
            // Send an HTTP 500 error response if an error occurs during data retrieval
            response.sendError(HttpServletResponse.SC_INTERNAL_SERVER_ERROR, "Error retrieving revenue data.");
        }
    }

    // Method to handle HTTP POST requests by delegating to doGet
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Delegate POST requests to the doGet method
        doGet(request, response);
    }

    // Method to retrieve revenue statistics for domestic and international tours
    private void getRevenueStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Parse the month and year parameters from the request
            int month = Integer.parseInt(request.getParameter("month"));
            int year = Integer.parseInt(request.getParameter("year"));

            // Retrieve revenue for domestic and international tours for the specified month and year
            double revenueDomestic = statisticsDAO.getRevenueByMonth(month, year, "Domestic");
            double revenueInternational = statisticsDAO.getRevenueByMonth(month, year, "International");

            // Set attributes to pass to the JSP page
            request.setAttribute("revenueDomestic", revenueDomestic);        // Revenue for domestic tours
            request.setAttribute("revenueInternational", revenueInternational); // Revenue for international tours
        } catch (NumberFormatException e) {
            // Print the stack trace if the month or year format is invalid
            e.printStackTrace();
        }
        // Forward the request to the statistics JSP page to display the results
        request.getRequestDispatcher("Admin/statistics.jsp").forward(request, response);
    }

    // Method to retrieve booking statistics for domestic and international tours
    private void getBookingStatistics(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Parse the month and year parameters from the request
            int month = Integer.parseInt(request.getParameter("month"));
            int year = Integer.parseInt(request.getParameter("year"));

            // Retrieve the number of bookings for domestic and international tours for the specified month and year
            int bookingsDomestic = statisticsDAO.getBookingCountByMonth(month, year, "Domestic");
            int bookingsInternational = statisticsDAO.getBookingCountByMonth(month, year, "International");

            // Set attributes to pass to the JSP page
            request.setAttribute("bookingsDomestic", bookingsDomestic);        // Number of domestic bookings
            request.setAttribute("bookingsInternational", bookingsInternational); // Number of international bookings
        } catch (NumberFormatException e) {
            // Print the stack trace if the month or year format is invalid
            e.printStackTrace();
        }
        // Forward the request to the statistics JSP page to display the results (Note: Path inconsistency)
        request.getRequestDispatcher("Web Pages/Admin/statistics.jsp").forward(request, response);
    }

    // Method to retrieve revenue details with optional filtering by month, year, and tour type
    private void getRevenueDetails(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Parse the month and year parameters, default to 0 if not provided
            int month = request.getParameter("month") != null ? Integer.parseInt(request.getParameter("month")) : 0;
            int year = request.getParameter("year") != null ? Integer.parseInt(request.getParameter("year")) : 0;
            // Get the tour type parameter
            String tourType = request.getParameter("tourType");

            // Set a default tour type if none is provided
            if (tourType == null || tourType.isEmpty()) {
                tourType = "Domestic";  // Default to Domestic if no tour type is selected
            }

            // Declare a list to store revenue details
            List<AdminBooking> revenueDetails;
            // If month or year is 0, retrieve all revenue details; otherwise, filter by month, year, and tour type
            if (month == 0 || year == 0) {
                revenueDetails = statisticsDAO.getAllRevenueDetails();
            } else {
                revenueDetails = statisticsDAO.getRevenueDetailsByMonth(month, year, tourType);
            }

            // Set attributes to pass to the JSP page
            request.setAttribute("revenueDetails", revenueDetails);  // Revenue details list
            request.setAttribute("month", month);                    // Selected month
            request.setAttribute("year", year);                      // Selected year
            request.setAttribute("tourType", tourType);              // Selected tour type (for display on the UI)

            // Forward the request to the statistics JSP page to display the results
            request.getRequestDispatcher("Admin/statistics.jsp").forward(request, response);
        } catch (NumberFormatException e) {
            // Print the stack trace if the month or year format is invalid
            e.printStackTrace();
            // Send an HTTP 400 error response for invalid input
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Invalid month or year format.");
        }
    }
}
