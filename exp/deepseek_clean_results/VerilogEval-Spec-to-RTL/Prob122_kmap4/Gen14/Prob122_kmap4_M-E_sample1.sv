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
    
    // Pattern selection based on cd
    wire pattern_sel;
    assign pattern_sel = c ^ d;
    
    // Create the two possible patterns
    wire pattern0, pattern1;
    assign pattern0 = a ^ b;       // 0,1,0,1 pattern
    assign pattern1 = ~(a ^ b);    // 1,0,1,0 pattern
    
    // Final output selection
    assign out = pattern_sel ? pattern1 : pattern0;

endmodule