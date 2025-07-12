module TopModule(
    input a,
    input b,
    input c,
    input d,  // Don't-care input (optimized away)
    output out
);
    /* K-map implementation:
       cd\ab  01  00  10  11
       00 | d | 0 | 1 | 1 |
       01 | 0 | 0 | d | d |
       11 | 0 | 1 | 1 | 1 |
       10 | 0 | 1 | 1 | 1 |
       
       Minimized expression: out = a | (~b & c)
    */
    
    assign out = a | (~b & c);
endmodule