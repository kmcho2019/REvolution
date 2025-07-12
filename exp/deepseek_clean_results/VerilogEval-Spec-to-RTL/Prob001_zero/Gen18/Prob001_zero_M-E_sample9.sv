module TopModule (
    output zero  // Constant LOW output implemented via NAND logic
);
    // Internal signals
    wire high1, high2;
    
    // Create constant HIGH signals
    assign high1 = 1'b1;
    assign high2 = 1'b1;
    
    // Implement zero using NAND logic: 1 NAND 1 = 0
    nand(zero, high1, high2);
    
    /* Implementation notes:
     * - Uses basic gate-level primitive
     * - Demonstrates logical derivation of constant
     * - Shows alternative to direct assignment
     * - Functionally equivalent to simpler solutions
     */
endmodule