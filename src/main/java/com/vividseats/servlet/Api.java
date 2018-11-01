package com.vividseats.servlet;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.io.PrintWriter;

public class Api extends HttpServlet {

    @Override
    protected void doGet(HttpServletRequest req, HttpServletResponse resp) throws ServletException, IOException {
        try (PrintWriter pw = new PrintWriter(resp.getOutputStream())) {
            pw.write(String.format("{ \"environment\": \"%s\" }\n", System.getenv("ENVIRONMENT")));
            pw.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

}
