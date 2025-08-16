<%@ page import="java.sql.*, java.io.*" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Update Book</title>
    
    <style>
        body {
            font-family: Arial, sans-serif;
            background-color: whitesmoke;
            margin: 0;
            padding: 0;
        }
        header {
            background-color: #4CAF50;
            color: white;
            text-align: center;
            padding: 15px;
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
        .container h2 {
            text-align: center;
            color: #333;
        }
        form {
            display: flex;
            flex-direction: column;
            gap: 15px;
        }
        label {
            font-size: 16px;
            font-weight: bold;
            color: #333;
        }
        input[type="text"], input[type="number"] {
            padding: 10px;
            font-size: 16px;
            border: 2px solid #ccc;
            border-radius: 4px;
            width: 100%;
            box-sizing: border-box;
        }
        input[type="text"]:focus, input[type="number"]:focus {
            border-color: #4CAF50;
            outline: none;
        }
        button {
            padding: 10px 15px;
            background-color: #4CAF50;
            color: white;
            border: none;
            border-radius: 4px;
            font-size: 16px;
            cursor: pointer;
        }
        button:hover {
            background-color: #45a049;
        }
        .back-link {
            display: block;
            margin-top: 20px;
            text-align: center;
            text-decoration: none;
            color: #4CAF50;
            font-size: 16px;
        }
        .back-link:hover {
            text-decoration: underline;
        }
        .error, .success {
            text-align: center;
            font-size: 18px;
            font-weight: bold;
            margin-bottom: 20px;
        }
        .error {
            color: red;
        }
        .success {
            color: green;
        }
    </style>
</head>
<body>
    <header>Update Book Details</header>

    <div class="container">
        <%
            String dbURL = "jdbc:mysql://localhost:3306/lms";
            String dbUser = "root";
            String dbPassword = "tiger";
            Connection conn = null;
            PreparedStatement pstmt = null;
            ResultSet rs = null;
            String bookId = request.getParameter("bookId");
            String bookname = "", isbn = "", authorName = "";

            // Step 1: Fetch the current data for the book
            if (bookId != null) {
                try {
                    Class.forName("com.mysql.cj.jdbc.Driver");
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                    String sql = "SELECT bookname, isbn, author_name FROM books WHERE book_id = ?";
                    pstmt = conn.prepareStatement(sql);
                    pstmt.setInt(1, Integer.parseInt(bookId));
                    rs = pstmt.executeQuery();

                    if (rs.next()) {
                        bookname = rs.getString("bookname");
                        isbn = rs.getString("isbn");
                        authorName = rs.getString("author_name");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                } finally {
                    if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }

            // Step 2: Handle the form submission to update book details
            if (request.getMethod().equalsIgnoreCase("POST")) {
                String updatedBookname = request.getParameter("bookname");
                String updatedIsbn = request.getParameter("isbn");
                String updatedAuthor = request.getParameter("authorName");

                try {
                    conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
                    String updateSql = "UPDATE books SET bookname = ?, isbn = ?, author_name = ? WHERE book_id = ?";
                    pstmt = conn.prepareStatement(updateSql);
                    pstmt.setString(1, updatedBookname);
                    pstmt.setString(2, updatedIsbn);
                    pstmt.setString(3, updatedAuthor);
                    pstmt.setInt(4, Integer.parseInt(bookId));

                    int result = pstmt.executeUpdate();
                    if (result > 0) {
                        out.println("<div class='success'>Book updated successfully!</div>");
                    } else {
                        out.println("<div class='error'>Failed to update the book.</div>");
                    }
                } catch (Exception e) {
                    e.printStackTrace();
                    out.println("<div class='error'>Error occurred: " + e.getMessage() + "</div>");
                } finally {
                    if (pstmt != null) try { pstmt.close(); } catch (SQLException e) { e.printStackTrace(); }
                    if (conn != null) try { conn.close(); } catch (SQLException e) { e.printStackTrace(); }
                }
            }
        %>

        <form method="post" action="">
            <label for="bookname">Book Name:</label>
            <input type="text" id="bookname" name="bookname" value="<%= bookname %>" required><br>

            <label for="isbn">ISBN:</label>
            <input type="text" id="isbn" name="isbn" value="<%= isbn %>" required><br>

            <label for="authorName">Author Name:</label>
            <input type="text" id="authorName" name="authorName" value="<%= authorName %>" required><br>

            <button type="submit">Update Book</button>
        </form>

        <a href="Book.jsp" class="back-link">Back to Book List</a>
    </div>
</body>
</html>
