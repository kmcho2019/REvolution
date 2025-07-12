module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Karnaugh Map Implementation:
       The checkerboard pattern indicates output is 1 when:
       - (a XOR b) is different from (c XOR d)
       Which is equivalent to (a XOR b XOR c XOR d)
       
       Pattern visualization:
             ab
      cd   00  01  11  10
      00 | 0 | 1 | 0 | 1 |
      01 | 1 | 0 | 1 | 0 |
      11 | 0 | 1 | 0 | 1 |
      10 | 1 | 0 | 1 | 0 |
    */
    
    // First level XORs (row and column patterns)
    wire row_pattern = a ^ b;
    wire col_pattern = c ^ d;
    
    // Final output combines patterns
    assign out = row_pattern ^ col_pattern;
    
    /* Note: This is mathematically equivalent to:
       assign out = a ^ b ^ c ^ d;
       but structured to clearly show the K-map relationship
    */
endmodule