module TopModule (
    input in1,
    input in2,
    output out
);
    /* Optimal implementation - single continuous assignment
     * Implements: out = in1 AND NOT in2
     * This is the most efficient implementation in terms of:
     * - Timing (single gate operation)
     * - Power (no unnecessary intermediate nodes)
     * - Area (minimal logic cells)
     */
    assign out = in1 & ~in2;

    /* Alternative implementations (for reference):
     * 
     * 1. Using intermediate wire:
     * wire in2_not;
     * assign in2_not = ~in2;
     * assign out = in1 & in2_not;
     * 
     * 2. Using always block:
     * reg out_reg;
     * always @(*) begin
     *     out_reg = in1 & ~in2;
     * end
     * assign out = out_reg;
     */
endmodule