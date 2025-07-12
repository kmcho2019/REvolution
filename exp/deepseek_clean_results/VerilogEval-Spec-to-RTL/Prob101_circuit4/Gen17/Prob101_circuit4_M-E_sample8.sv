module TopModule (
    input a,       // Unused input (interface requirement)
    input b,       // Mux select line 1
    input c,       // Mux select line 2
    input d,       // Unused input (interface requirement)
    output q       // Output: q = b OR c
);
    // 4:1 MUX implementation of OR function
    // Select lines: {c, b}
    // Data inputs wired to implement OR truth table:
    // 00: 0 (neither b nor c)
    // 01: 1 (b)
    // 10: 1 (c)
    // 11: 1 (both)
    
    assign q = (c & b) ? 1'b1 :  // Both true
               (c & ~b) ? 1'b1 : // Only c true
               (~c & b) ? 1'b1 : // Only b true
               1'b0;             // Neither true
endmodule