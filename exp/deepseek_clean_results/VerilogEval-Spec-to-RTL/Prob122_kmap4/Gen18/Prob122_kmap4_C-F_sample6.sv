module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Karnaugh Map Implementation:
             ab
      cd   00  01  11  10
      00 | 0 | 1 | 0 | 1 |
      01 | 1 | 0 | 1 | 0 |
      11 | 0 | 1 | 0 | 1 |
      10 | 1 | 0 | 1 | 0 |
      
      The output follows a checkerboard pattern where:
      out = 1 when (a XOR b) == (c XOR d)
      This can be computed efficiently as (a^b)^(c^d)
    */
    
    assign out = (a ^ b) ^ (c ^ d);

endmodule