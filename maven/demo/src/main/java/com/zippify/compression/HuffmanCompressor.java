package com.zippify.compression;

import java.io.*;
import java.util.HashMap;
import java.util.PriorityQueue;

public class HuffmanCompressor {
    private static class Node implements Comparable<Node> {
        char ch;
        int frequency;
        Node left, right;

        Node(char ch, int frequency) {
            this.ch = ch;
            this.frequency = frequency;
        }

        Node(int frequency, Node left, Node right) {
            this.frequency = frequency;
            this.left = left;
            this.right = right;
        }

        @Override
        public int compareTo(Node o) {
            return Integer.compare(this.frequency, o.frequency);
        }
    }

    public static void compress(InputStream input, OutputStream output) throws IOException {
        // Read input file and count character frequencies
        HashMap<Character, Integer> frequencyMap = new HashMap<>();
        BufferedInputStream bis = new BufferedInputStream(input);
        int b;
        while ((b = bis.read()) != -1) {
            char ch = (char) b;
            frequencyMap.put(ch, frequencyMap.getOrDefault(ch, 0) + 1);
        }

        // Create Huffman Tree
        PriorityQueue<Node> pq = new PriorityQueue<>();
        for (var entry : frequencyMap.entrySet()) {
            pq.add(new Node(entry.getKey(), entry.getValue()));
        }

        while (pq.size() > 1) {
            Node left = pq.poll();
            Node right = pq.poll();
            Node parent = new Node(left.frequency + right.frequency, left, right);
            pq.add(parent);
        }

        Node root = pq.poll();
        HashMap<Character, String> huffmanCode = new HashMap<>();
        generateHuffmanCode(root, "", huffmanCode);

        // Reset the stream and encode data
        bis.close();
        input.reset();
        BufferedOutputStream bos = new BufferedOutputStream(output);
        bis = new BufferedInputStream(input);

        StringBuilder sb = new StringBuilder();
        while ((b = bis.read()) != -1) {
            char ch = (char) b;
            sb.append(huffmanCode.get(ch));
        }

        bos.write(sb.toString().getBytes());  // Write encoded data
        bis.close();
        bos.close();
    }

    private static void generateHuffmanCode(Node root, String code, HashMap<Character, String> huffmanCode) {
        if (root == null) return;

        if (root.left == null && root.right == null) {
            huffmanCode.put(root.ch, code);
        }

        generateHuffmanCode(root.left, code + "0", huffmanCode);
        generateHuffmanCode(root.right, code + "1", huffmanCode);
    }
}
