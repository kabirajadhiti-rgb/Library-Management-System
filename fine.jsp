<%@ page import="java.sql.*, java.io.*, java.util.Date, java.text.SimpleDateFormat" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Book Data with Fines</title>
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
        .fine-notification {
            background-color: yellow;
            padding: 10px;
            margin: 10px auto;
            text-align: center;
            color: red;
            font-weight: bold;
        }
        form.filter-form {
            text-align: center;
            margin: 20px;
            padding: 8px;
        }
    </style>
</head>
<body>

<h2 style="text-align: center;">Book Data with Fines</h2>

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
    Date currentDate = new Date(); // Current date to compare with the due date

    SimpleDateFormat sdf = new SimpleDateFormat("yyyy-MM-dd"); // For formatting the date
    String currentDateString = sdf.format(currentDate);

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

        // Create the SQL query with filtering by bookname or author_name
        String sql = "SELECT book_id, bookname, isbn, author_name, due_date, fine_per_book FROM fine_books WHERE bookname LIKE ? OR author_name LIKE ?";
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
        <th>Due Date</th>
        <th>Fine</th>
    </tr>

    <%
        // Loop through the result set and display the data in a table
        while (rs.next()) {
            int id = rs.getInt("book_id");
            String bookname = rs.getString("bookname");
            String isbn = rs.getString("isbn");
            String authorName = rs.getString("author_name");
            Date dueDate = rs.getDate("due_date");
            double finePerBook = rs.getDouble("fine_per_book");

            // Calculate the number of days overdue
            long diffInMillis = currentDate.getTime() - dueDate.getTime();
            long diffInDays = diffInMillis / (1000 * 60 * 60 * 24); // Convert milliseconds to days

            // Determine if there is a fine
            double fineAmount = 0;
            if (diffInDays > 0) {
                fineAmount = finePerBook ; //* diffInDays; // Apply fine for each overdue day
            }
    %>
    <tr>
        <td><%= id %></td>
        <td><%= bookname %></td>
        <td><%= isbn %></td>
        <td><%= authorName %></td>
        <td><%= dueDate %></td>
        <td>
            <%
                if (fineAmount > 0) {
            %>
                <div class="fine-notification">
                    Fine: $<%= fineAmount %> - Please Pay
                </div>
            <%
                } else {
            %>
                No Fine
            <%
                }
            %>
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
