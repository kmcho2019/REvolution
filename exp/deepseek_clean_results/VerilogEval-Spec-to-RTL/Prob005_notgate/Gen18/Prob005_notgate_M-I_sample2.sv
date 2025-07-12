module TopModule (
    input wire in,       // Explicit wire declaration
    output wire out      // Explicit wire declaration
);
    // Continuous assignment for optimal combinational logic
    assign out = ~in;
    
    /* Technology Note:
     * Synthesis tool will automatically select optimal:
     * - Drive strength based on fanout
     * - Vt variant based on timing/power constraints
     * - Cell variant based on standard cell library
     */
endmodule