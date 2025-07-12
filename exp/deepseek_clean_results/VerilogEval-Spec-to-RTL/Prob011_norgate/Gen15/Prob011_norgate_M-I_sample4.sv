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
    assign out = ~(a | b);
endmodule