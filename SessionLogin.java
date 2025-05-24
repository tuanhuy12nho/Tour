/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package util;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import model.User;

/**
 *
 * @author Admin
 */
public class SessionLogin {

    /**
     * Checks if a user is logged in by verifying the presence of a session and
     * a "currentUser" attribute.
     *
     * @param request The HTTP servlet request containing the session
     * @return True if the user is logged in, false otherwise
     */
    public static boolean isLoggedIn(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // Get session without creating a new one
        return session != null && session.getAttribute("user") != null; // Return true if session exists and user is set
    }

    /**
     * Retrieves the username of the logged-in user from the session.
     *
     * @param request The HTTP servlet request containing the session
     * @return The username if available, null if no session or username is
     * found
     */
    public static String getLoggedInUsername(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // Get session without creating a new one
        if (session != null) {
            return (String) session.getAttribute("username"); // Return username from session, if present
        }
        return null; // Return null if no session exists
    }

    /**
     * Checks if the logged-in user has admin privileges.
     *
     * @param request The HTTP servlet request containing the session
     * @return True if the user is an admin, false otherwise
     */
    public static boolean isAdmin(HttpServletRequest request) {
        HttpSession session = request.getSession(false); // Get session without creating a new one
        if (session == null) {
            return false; // Return false if no session exists
        }

        User user = (User) session.getAttribute("user"); // Retrieve the current user object from session
        return (user != null && "Admin".equalsIgnoreCase(user.getUserRole())); // Return true if user exists and has "admin" role
    }
}
