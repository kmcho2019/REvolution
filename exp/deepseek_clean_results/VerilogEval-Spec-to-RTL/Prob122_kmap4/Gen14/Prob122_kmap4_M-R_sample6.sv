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
    wire ab_xor = a ^ b;
    wire cd_xor = c ^ d;
    
    // Final output combines intermediate results
    assign out = ab_xor ^ cd_xor;

    /* This is equivalent to the original a^b^c^d because:
       (a^b)^(c^d) = a^b^c^d (XOR is associative)
    */
endmodule