<%@ page import="java.sql.*" %>
<%
    String name = request.getParameter("name");
    String email = request.getParameter("email");
    String course = request.getParameter("course");

    // RDS Connection Details
    String url = "jdbc:mysql://student-db-instance.chimeecigr3s.ap-south-1.rds.amazonaws.com:3306/studentdb";
    String user = "admin";
    String pass = "password123";

    try {
        Class.forName("com.mysql.cj.jdbc.Driver");
        Connection conn = DriverManager.getConnection(url, user, pass);
        PreparedStatement ps = conn.prepareStatement("insert into students(name, email, course) values(?,?,?)");
        ps.setString(1, name);
        ps.setString(2, email);
        ps.setString(3, course);
        
        int i = ps.executeUpdate();
        if(i > 0) {
            out.print("<h3>Registration Successful!</h3>");
            out.print("<a href='index.jsp'>Register another student</a>");
        }
        conn.close();
    } catch(Exception e) {
        out.print("Error: " + e.getMessage());
        e.printStackTrace();
    }
%>
