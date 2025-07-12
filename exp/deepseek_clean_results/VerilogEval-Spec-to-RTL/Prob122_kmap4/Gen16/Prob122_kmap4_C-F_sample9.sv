module TopModule (
    input  a,
    input  b,
    input  c,
    input  d,
    output out
);

    /* Checkerboard pattern implementation using XOR operations:
       out = (a^b) ^ (c^d) matches the specified K-map */
    wire row_pattern;  // XOR of a and b creates row alternation
    wire col_pattern;  // XOR of c and d creates column alternation
    
    assign row_pattern = a ^ b;
    assign col_pattern = c ^ d;
    assign out = row_pattern ^ col_pattern;  // Combines patterns for checkerboard

endmodule