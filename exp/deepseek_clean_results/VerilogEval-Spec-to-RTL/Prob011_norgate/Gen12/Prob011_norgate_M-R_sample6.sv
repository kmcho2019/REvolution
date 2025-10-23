module TopModule (
    input  a,    // First input
    input  b,    // Second input
    output out   // NOR output
);
    /*
     * Truth Table:
     * a b | out
     * --------
     * 0 0 | 1
     * 0 1 | 0
     * 1 0 | 0
     * 1 1 | 0
     */
    wire or_result;  // Intermediate OR result
    
    assign or_result = a | b;  // Explicit OR operation
    assign out = ~or_result;   // Inversion to create NOR
endmodule