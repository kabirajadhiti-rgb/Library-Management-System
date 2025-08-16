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

        // Check if the book is available
        String checkSQL = "SELECT status FROM books WHERE book_id = ?";
        pstmt = conn.prepareStatement(checkSQL);
        pstmt.setInt(1, bookId);
        rs = pstmt.executeQuery();

        if (rs.next() && rs.getString("status").equals("available")) {
            // Update book status to 'borrowed'
            String updateBookSQL = "UPDATE books SET status = 'borrowed' WHERE book_id = ?";
            pstmt = conn.prepareStatement(updateBookSQL);
            pstmt.setInt(1, bookId);
            pstmt.executeUpdate();

            // Insert the borrow record into borrowers table
            String insertBorrowSQL = "INSERT INTO borrowers (name, book_id, borrow_date) VALUES (?, ?, NOW())";
            pstmt = conn.prepareStatement(insertBorrowSQL);
            pstmt.setString(1, userName);
            pstmt.setInt(2, bookId);
            pstmt.executeUpdate();

            out.println("<p>Book borrowed successfully!</p>");
        } else {
            out.println("<p>Sorry, this book is already borrowed or unavailable.</p>");
        }
    } catch (Exception e) {
        e.printStackTrace();
        out.println("<p>Error occurred during borrowing the book.</p>");
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>
