module TopModule (
    input in1,
    input in2,
    output out
);
    /* Alternative implementation showing:
     * 1. Explicit inversion of in2
     * 2. Two equivalent assignment styles
     */
    
    // Method 1: Using intermediate wire (explicit inversion)
    wire in2_not;
    assign in2_not = ~in2;
    assign out = in1 & in2_not;
    
    /* Method 2: Using always block (commented out)
     * reg out_reg;
     * always @(*) begin
     *     out_reg = in1 & ~in2;
     * end
     * assign out = out_reg;
     */
endmodule