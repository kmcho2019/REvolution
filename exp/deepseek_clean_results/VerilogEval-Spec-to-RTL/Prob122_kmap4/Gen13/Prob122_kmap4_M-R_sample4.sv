module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Implementation of K-map:
             ab
      cd   00  01  11  10
      00 | 0 | 1 | 0 | 1 |
      01 | 1 | 0 | 1 | 0 |
      11 | 0 | 1 | 0 | 1 |
      10 | 1 | 0 | 1 | 0 |
    */
    
    // Intermediate XOR results
    wire ab_xor;  // XOR of first two inputs
    wire cd_xor;  // XOR of last two inputs
    
    // Compute pairwise XORs
    assign ab_xor = a ^ b;
    assign cd_xor = c ^ d;
    
    // Final output is XOR of intermediate results
    assign out = ab_xor ^ cd_xor;

endmodule