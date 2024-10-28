package com.zippify.servlet;

import com.zippify.compression.HuffmanCompressor;

import javax.servlet.ServletException;
import javax.servlet.annotation.WebServlet;
import javax.servlet.http.HttpServlet;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.Part;
import java.io.*;

@WebServlet("/CompressServlet")
public class CompressServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        Part filePart = request.getPart("file");  // Get uploaded file part
        String fileName = filePart.getSubmittedFileName();
        InputStream fileContent = filePart.getInputStream();

        // Compress file using Huffman coding
        File compressedFile = new File("compressed_" + fileName);
        try (OutputStream fos = new FileOutputStream(compressedFile)) {
            HuffmanCompressor.compress(fileContent, fos);
        }

        // Set response headers for file download
        response.setContentType("application/octet-stream");
        response.setHeader("Content-Disposition", "attachment; filename=" + compressedFile.getName());

        // Stream compressed file back to client
        try (FileInputStream fis = new FileInputStream(compressedFile);
             OutputStream os = response.getOutputStream()) {
            byte[] buffer = new byte[4096];
            int bytesRead;
            while ((bytesRead = fis.read(buffer)) != -1) {
                os.write(buffer, 0, bytesRead);
            }
        }

        // Delete the temporary compressed file after sending it
        compressedFile.delete();
    }
}
