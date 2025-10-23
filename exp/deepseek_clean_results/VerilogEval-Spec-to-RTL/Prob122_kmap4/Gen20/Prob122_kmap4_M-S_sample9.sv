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
    */
    
    // Simplified implementation: XOR all inputs
    assign out = a ^ b ^ c ^ d;

endmodule