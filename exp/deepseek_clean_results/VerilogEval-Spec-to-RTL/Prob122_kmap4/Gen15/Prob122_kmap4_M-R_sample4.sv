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
    
    // First XOR pair (a,b) creates vertical stripes
    wire ab_xor = a ^ b;
    
    // Second XOR pair (c,d) creates horizontal stripes
    wire cd_xor = c ^ d;
    
    // Combined XOR creates checkerboard pattern
    assign out = ab_xor ^ cd_xor;

endmodule