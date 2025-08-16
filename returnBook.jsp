<%@ page import="java.sql.*, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    int bookId = Integer.parseInt(request.getParameter("bookId"));
    String userName = "SomeUser"; // Ideally fetched from session or user profile

    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String dbURL = "jdbc:mysql://localhost:3306/lms"; 
    String dbUser = "root"; 
    String dbPassword = "tiger"; 

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Check if the user has borrowed this book
        String checkBorrowSQL = "SELECT borrower_id, book_id FROM borrowers WHERE book_id = ? AND name = ? AND return_date IS NULL";
        pstmt = conn.prepareStatement(checkBorrowSQL);
        pstmt.setInt(1, bookId);
        pstmt.setString(2, userName);
        rs = pstmt.executeQuery();

        if (rs.next()) {
            // Update return date in the borrowers table
            String updateReturnSQL = "UPDATE borrowers SET return_date = NOW() WHERE book_id = ? AND borrower_id = ?";
            pstmt = conn.prepareStatement(updateReturnSQL);
            pstmt.setInt(1, bookId);
            pstmt.setInt(2, rs.getInt("borrower_id"));
            pstmt.executeUpdate();

            // Update book status to 'available'
            String updateBookSQL = "UPDATE books SET status = 'available' WHERE book_id = ?";
            pstmt = conn.prepareStatement(updateBookSQL);
            pstmt.setInt(1, bookId);
            pstmt.executeUpdate();

            out.println("<p>Book returned successfully!</p>");
        } else {
            out.println("<p>You have not borrowed this book or it's already returned.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error occurred during returning the book.</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
