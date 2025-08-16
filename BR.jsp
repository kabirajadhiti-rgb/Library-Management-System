<%@ page import="java.sql.*, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Data</title>
    <!-- Font Awesome for icons -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: whitesmoke;
        }
        table {
            width: 80%;
            background: white;
            margin: 20px auto;
            border-collapse: collapse;
        }
        table, th, td {
            border: 3px solid black;
        }
        th, td {
            padding: 10px;
            text-align: center;
        }
        th {
            background-color: skyblue;
            color: black;
        }
        .action-btn {
            color: white;
            background-color: transparent;
            border: none;
            cursor: pointer;
            font-size: 18px;
            padding: 5px;
        }
        .borrow-icon {
            color: green;
        }
        .return-icon {
            color: orange;
        }
        form.filter-form {
            text-align: center;
            margin: 20px;
            padding: 8px;
        }
    </style>
</head>
<body>

<h2 style="text-align: center;">Book Data</h2>

<form class="filter-form" method="get" action="">
    <label for="filterText">Filter by Book Name or Author Name:</label>
    <input type="text" id="filterText" name="filterText" value="<%= request.getParameter("filterText") != null ? request.getParameter("filterText") : "" %>">
    <button type="submit">Filter</button>
</form>

<%
    Connection conn = null;
    PreparedStatement pstmt = null;
    ResultSet rs = null;
    String dbURL = "jdbc:mysql://localhost:3306/lms"; 
    String dbUser = "root"; 
    String dbPassword = "tiger"; 

    // Get the filter text from the request
    String filterText = request.getParameter("filterText") != null ? request.getParameter("filterText") : "";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Create the SQL query with filtering by bookname or author_name
        String sql = "SELECT book_id, bookname, isbn, author_name, status FROM books WHERE bookname LIKE ? OR author_name LIKE ?";
        pstmt = conn.prepareStatement(sql);
        pstmt.setString(1, "%" + filterText + "%");
        pstmt.setString(2, "%" + filterText + "%");

        // Execute the query
        rs = pstmt.executeQuery();
%>

<table>
    <tr>
        <th>Book ID</th>
        <th>Book Name</th>
        <th>ISBN</th>
        <th>Author Name</th>
        <th>Status</th>
        <th>Action</th>
    </tr>

    <%
        // Loop through the result set and display the data in a table
        while (rs.next()) {
            int id = rs.getInt("book_id");
            String bookname = rs.getString("bookname");
            String isbn = rs.getString("isbn");
            String authorName = rs.getString("author_name");
            String status = rs.getString("status");
    %>
    <tr>
        <td><%= id %></td>
        <td><%= bookname %></td>
        <td><%= isbn %></td>
        <td><%= authorName %></td>
        <td><%= status %></td>
        <td>
            <% if ("available".equals(status)) { %>
                <!-- Borrow Icon -->
                <form action="borrowBook.jsp" method="post" style="display: inline;">
                    <input type="hidden" name="bookId" value="<%= id %>">
                    <button type="submit" class="action-btn">
                        <i class="fas fa-book-reader borrow-icon"></i> Borrow
                    </button>
                </form>
            <% } else { %>
                <!-- Return Icon (only for borrowed books) -->
                <form action="returnBook.jsp" method="post" style="display: inline;">
                    <input type="hidden" name="bookId" value="<%= id %>">
                    <button type="submit" class="action-btn">
                        <i class="fas fa-undo return-icon"></i> Return
                    </button>
                </form>
            <% } %>
        </td>
    </tr>
    <%
        }
    %>
</table>

<%
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
    }
%>

</body>
</html>
