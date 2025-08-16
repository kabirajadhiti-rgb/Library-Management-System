<%@ page import="java.sql.Connection, java.sql.DriverManager, java.sql.PreparedStatement, java.sql.ResultSet" %>
<%@ page contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
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

        .login-container {
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

        @media screen (max-width: 600px) {
            .login-container {
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
    String username = request.getParameter("username");
    String password = request.getParameter("password");

    if (username != null && password != null) {
        Connection conn = null;
        PreparedStatement pstmt = null;
        ResultSet rs = null;
        String dbURL = "jdbc:mysql://localhost:3306/smart_shelf";
        String dbUser = "root";
        String dbPassword = "tiger";

        try {
            Class.forName("com.mysql.cj.jdbc.Driver");
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            String sql = "SELECT * FROM users WHERE name = ? AND password = ?";
            pstmt = conn.prepareStatement(sql);
            pstmt.setString(1, username);
            pstmt.setString(2, password);

            rs = pstmt.executeQuery();
            if (rs.next()) {
                // Login successful, redirect to dashboard
                response.sendRedirect("index.html");
            } else {
                out.println("<h3 style='color: red;'>Invalid username or password!</h3>");
            }
        } catch (Exception e) {
            e.printStackTrace();
            out.println("<h3 style='color: red;'>Error: " + e.getMessage() + "</h3>");
        } finally {
            if (rs != null) try { rs.close(); } catch (Exception e) { e.printStackTrace(); }
            if (pstmt != null) try { pstmt.close(); } catch (Exception e) { e.printStackTrace(); }
            if (conn != null) try { conn.close(); } catch (Exception e) { e.printStackTrace(); }
        }
    }
%>
    <div class="login-container">
        <!-- Form Section -->
        <div class="form-section">
            <h2>Login</h2>
            <form action="login.jsp" method="post">
                <div class="input-container">
                    <div class="icon">
                        <i class="ri-user-3-fill"></i>
                    </div>
                    <input type="text" name="username" placeholder="Username" required>
                </div>
                <div class="input-container">
                    <div class="icon">
                        <i class="ri-lock-fill"></i>
                    </div>
                    <input type="password" name="password" placeholder="Password" required>
                </div>
                <div>
                    <input type="submit" value="Login">
                </div>
                <p>Don't have an account? <a href='signUp.jsp'>Register here</a></p>
            </form>
        </div>

        <!-- Image Section -->
        <div class="image-section">
            <img src="assets/undraw_sign_up_n6im.svg" alt="Login Icon">
        </div>
    </div>
</body>
</html>