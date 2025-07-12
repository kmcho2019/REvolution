module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    parameter SHIFT_REG_LEN = 1;  // Minimum size for this application
    
    reg invert;
    reg [SHIFT_REG_LEN-1:0] shift_reg;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            invert <= 1'b0;
            shift_reg <= {SHIFT_REG_LEN{1'b0}};
        end else begin
            // Shift in new bit
            shift_reg <= {shift_reg[SHIFT_REG_LEN-2:0], x};
            
            // Set invert flag when first '1' is detected in history
            if (!invert && (|shift_reg || x))
                invert <= 1'b1;
        end
    end
    
    // Output is current input XOR'd with invert flag
    assign z = x ^ invert;

endmodule