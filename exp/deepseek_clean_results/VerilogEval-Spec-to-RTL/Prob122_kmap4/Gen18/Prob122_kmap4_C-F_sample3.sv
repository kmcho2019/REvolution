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
      
      Mathematical explanation:
      The output is 1 when (a XOR b) XOR (c XOR d) = 0
      This is equivalent to checking if the parity of (a,b) matches the parity of (c,d)
      The XOR implementation is optimal for both area and timing
    */
    
    assign out = (a ^ b) ^ (c ^ d);

endmodule