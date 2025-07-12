module TopModule (
    input  [3:0] in,      // 4-bit input
    output       out_and,  // AND reduction output
    output       out_or,   // OR reduction output
    output       out_xor   // XOR reduction output
);
    // Using Verilog reduction operators for cleaner and more optimal implementation
    assign out_and = &in;  // 4-input AND
    assign out_or  = |in;  // 4-input OR
    assign out_xor = ^in;  // 4-input XOR
    
    /* Benefits:
     * 1. More concise code (3 lines vs original 15)
     * 2. No intermediate wires = less switching power
     * 3. Same logic depth (2 levels) maintained
     * 4. Clearer intent for synthesis tools
     * 5. Functionally identical to original
     */
endmodule