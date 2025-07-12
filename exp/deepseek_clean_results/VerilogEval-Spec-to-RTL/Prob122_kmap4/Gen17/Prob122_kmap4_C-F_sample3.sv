module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Implementation of K-map (checkerboard pattern):
             ab
      cd   00  01  11  10
      00 | 0 | 1 | 0 | 1 |
      01 | 1 | 0 | 1 | 0 |
      11 | 0 | 1 | 0 | 1 |
      10 | 1 | 0 | 1 | 0 |
      
      Pattern Analysis:
      - Vertical stripes created by a^b
      - Horizontal stripes created by c^d
      - Combined XOR creates perfect checkerboard
    */
    
    // Vertical stripe pattern (columns alternate)
    wire vertical_pattern = a ^ b;
    
    // Horizontal stripe pattern (rows alternate) 
    wire horizontal_pattern = c ^ d;
    
    // Combine patterns to create checkerboard output
    assign out = vertical_pattern ^ horizontal_pattern;

endmodule