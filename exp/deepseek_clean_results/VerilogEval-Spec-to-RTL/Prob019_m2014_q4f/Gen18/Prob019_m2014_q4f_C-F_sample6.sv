module TopModule (
    input in1,
    input in2,
    output out
);
    /* Optimal implementation of AND gate with inverted in2 input
     * Method 1: Direct assignment (most efficient)
     * Method 2: Using intermediate wire (commented)
     * Method 3: Using always block (commented)
     */
    
    // Method 1: Direct assignment (recommended)
    assign out = in1 & ~in2;
    
    /* Alternative implementations:
    // Method 2: Using intermediate wire
    wire in2_not;
    assign in2_not = ~in2;
    assign out = in1 & in2_not;
    
    // Method 3: Using always block
    reg out_reg;
    always @(*) begin
        out_reg = in1 & ~in2;
    end
    assign out = out_reg;
    */
endmodule