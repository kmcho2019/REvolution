module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Implementation of K-map (checkerboard pattern) using minterms:
             ab
      cd   00  01  11  10
      00 | 0 | 1 | 0 | 1 |
      01 | 1 | 0 | 1 | 0 |
      11 | 0 | 1 | 0 | 1 |
      10 | 1 | 0 | 1 | 0 |
    */
    
    // Minterms for each '1' in the K-map
    wire term1 = ~c & ~d & ~a &  b;  // cd=00, ab=01
    wire term2 = ~c & ~d &  a & ~b;  // cd=00, ab=10
    wire term3 = ~c &  d & ~a & ~b;  // cd=01, ab=00
    wire term4 = ~c &  d &  a &  b;  // cd=01, ab=11
    wire term5 =  c & ~d & ~a & ~b;  // cd=10, ab=00
    wire term6 =  c & ~d &  a &  b;  // cd=10, ab=11
    wire term7 =  c &  d & ~a &  b;  // cd=11, ab=01
    wire term8 =  c &  d &  a & ~b;  // cd=11, ab=10

    // Combine all minterms
    assign out = term1 | term2 | term3 | term4 | term5 | term6 | term7 | term8;

endmodule