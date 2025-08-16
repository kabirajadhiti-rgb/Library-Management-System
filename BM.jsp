<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register Page</title>
    <link href="https://cdn.jsdelivr.net/npm/remixicon@4.3.0/fonts/remixicon.css" rel="stylesheet"/>
    <style>
        body {
            font-family: algerian, sans-serif;
            background-color: skyblue;
            display: flex;
            justify-content: center;
            align-items: center;
            height: 100vh;
            margin: 0;
        }

        .register-container {
            width: 800px;
            background-color: whitesmoke;
            padding: 20px;
            box-shadow: 0 5px 8px rgba(0, 0, 0, 0.43);
            border-radius: 10px;
            display: flex;
            justify-content: space-between;
            align-items: flex-start;
            flex-wrap: nowrap;
        }

        .form-section {
            width: 60%;
            padding-right: 20px;
        }

        .form-section h2 {
            text-align: center;
            margin-bottom: 20px;
        }

        .input-container {
            display: flex;
            align-items: center;
            margin-bottom: 15px;
        }

        .input-container .icon {
            width: 30px;
            display: flex;
            justify-content: center;
            align-items: center;
            color: #888;
            font-size: 20px;
        }

        .form-section input[type="text"],
        .form-section input[type="password"] {
            width: calc(100% - 40px);
            padding: 10px;
            border: 1px solid black;
            border-radius: 5px;
            margin-left: 10px;
            box-sizing: border-box;
        }

        .form-section input[type="submit"] {
            width: 100%;
            padding: 10px;
            background-color: blueviolet;
            color: white;
            border: none;
            border-radius: 5px;
            cursor: pointer;
        }

        .form-section input[type="submit"]:hover {
            background-color: blue;
        }

        .image-section {
            width: 40%;
            display: flex;
            justify-content: center;
            align-items: center;
        }

        .image-section img {
            width: 100%;
            max-width: 300px;
            height: auto;
        }

        @media screen and (max-width: 600px) {
            .register-container {
                flex-direction: column;
                align-items: center;
            }

            .form-section, .image-section {
                width: 100%;
                max-width: 100%;
                padding: 0;
            }

            .image-section {
                margin-top: 20px;
            }
        }
    </style>
</head>
<body>

<%
    String bookname = request.getParameter("bookname");
    String isbn = request.getParameter("isbn");
    String author_name = request.getParameter("author_name");

    // Only process if form is submitted
    if (bookname != null && isbn != null && author_name != null && !bookname.isEmpty() && !isbn.isEmpty() && !author_name.isEmpty()) {
        // Declare database connection and statement objects
        Connection conn = null;
        PreparedStatement pstmt = null;
        String dbURL = "jdbc:mysql://localhost:3306/lms";  // Database URL
        String dbUser = "root";  // Database username
        String dbPassword = "tiger";  // Database password

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Establish connection to the database
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // SQL query to insert book details into the database
            String sql = "INSERT INTO books (bookname, isbn, author_name) VALUES (?, ?, ?)";
            pstmt = conn.prepareStatement(sql);

            // Set parameters for the SQL query
            pstmt.setString(1, bookname);
            pstmt.setString(2, isbn);
            pstmt.setString(3, author_name);

            // Execute the query
            int result = pstmt.executeUpdate();
            if (result > 0) {
                // Registration successful, redirect to the Book.jsp page
                response.sendRedirect("Book.jsp");
            } else {
                out.println("<h3 style='color: red;'>Registration failed. Please try again.</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3 style='color: red;'>Error: " + e.getMessage() + "</h3>");
        } finally {
            // Close database resources
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
%>

    <div class="register-container">
        <!-- Form Section -->
        <div class="form-section">
            <h2>Register</h2>
            <form action="BM.jsp" method="post">
                <div class="input-container">
                    <div class="icon">
                        <i class="ri-book-fill"></i> <!-- Book Icon -->
                    </div>
                    <input type="text" name="bookname" placeholder="Bookname" required>
                </div>
                <div class="input-container">
                    <div class="icon">
                        <i class="ri-barcode-line"></i> <!-- ISBN Icon -->
                    </div>
                    <input type="text" name="isbn" placeholder="ISBN" required>
                </div>
                <div class="input-container">
                    <div class="icon">
                        <i class="ri-user-fill"></i> <!-- Author Icon -->
                    </div>
                    <input type="text" name="author_name" placeholder="Author Name" required>
                </div>
                
                <div>
                    <input type="submit" value="Register">
                </div>
                <p>Already registered? Just click here</p>
            </form>
        </div>

        <!-- Image Section -->
        <div class="image-section">
            <img src="assets/undraw_sign_up_n6im.svg" alt="Register Icon">
        </div>
    </div>

</body>
</html>
