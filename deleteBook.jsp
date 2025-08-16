<%@ page import="java.sql.*, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Delete Book</title>
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: #f4f4f9;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #e74c3c;
            color: white;
            text-align: center;
            padding: 20px;
            font-size: 24px;
        }
        .container {
            max-width: 800px;
            margin: 20px auto;
            padding: 20px;
            background: white;
            border-radius: 8px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.1);
        }
        .message {
            font-size: 18px;
            text-align: center;
            padding: 15px;
            margin-bottom: 20px;
            border-radius: 5px;
        }
        .error {
            background-color: #f8d7da;
            color: #721c24;
            border: 1px solid #f5c6cb;
        }
        .success {
            background-color: #d4edda;
            color: #155724;
            border: 1px solid #c3e6cb;
        }
        a {
            display: inline-block;
            background-color: #3498db;
            color: white;
            padding: 10px 20px;
            border-radius: 4px;
            text-decoration: none;
            font-size: 16px;
            text-align: center;
            margin-top: 20px;
        }
        a:hover {
            background-color: #2980b9;
        }
    </style>
</head>
<body>

<header>Delete Book</header>

<div class="container">
    <%
        String dbURL = "jdbc:mysql://localhost:3306/lms";
        String dbUser = "root";
        String dbPassword = "tiger";
        Connection conn = null;
        PreparedStatement pstmt = null;
        String bookId = request.getParameter("bookId");

        if (bookId != null) {
            try {
                Class.forName("com.mysql.cj.jdbc.Driver");
                conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                String sql = "DELETE FROM books WHERE book_id = ?";
                pstmt = conn.prepareStatement(sql);
                pstmt.setInt(1, Integer.parseInt(bookId));

                int result = pstmt.executeUpdate();
                if (result > 0) {
                    out.println("<div class='message success'><h3>Book deleted successfully!</h3></div>");
                } else {
                    out.println("<div class='message error'><h3>Failed to delete the book.</h3></div>");
                }
            } catch (Exception e) {
                e.printStackTrace();
                out.println("<div class='message error'><h3>Error occurred: " + e.getMessage() + "</h3></div>");
            } finally {
                if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
            }
        }
    %>

    <a href="Book.jsp">Back to Book List</a>
</div>

</body>
</html>
