module TopModule (
    input x,
    input y,
    output z
);
    /* Implementation options:
     * 1. Direct XNOR gate (most efficient)
     * 2. Explicit case statement (more readable)
     * Synthesis tools will optimize both to same implementation
     */
    
    // Option 1: Direct XNOR implementation
    assign z = x ~^ y;
    
    /* Option 2: Case statement implementation (commented out)
    reg z_reg;
    always @(*) begin
        case ({x, y})
            2'b00: z_reg = 1'b1;  // Both 0 -> 1
            2'b01: z_reg = 1'b0;  // Different -> 0
            2'b10: z_reg = 1'b0;  // Different -> 0
            2'b11: z_reg = 1'b1;  // Both 1 -> 1
        endcase
    end
    assign z = z_reg;
    */
endmodule