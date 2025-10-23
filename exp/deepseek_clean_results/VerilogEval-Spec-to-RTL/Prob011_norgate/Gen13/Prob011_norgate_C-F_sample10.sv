module TopModule (
    input  a,    // First input signal
    input  b,    // Second input signal
    output out   // NOR gate output
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
    
    // Optimal NOR implementation using continuous assignment
    assign out = ~(a | b);
endmodule