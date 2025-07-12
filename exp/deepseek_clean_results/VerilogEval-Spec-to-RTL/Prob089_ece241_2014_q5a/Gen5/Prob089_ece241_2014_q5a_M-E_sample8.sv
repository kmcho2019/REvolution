module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg flag;
    reg [1:0] shift_reg;  // Two-stage pipeline for flag propagation
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            flag <= 1'b0;
            shift_reg <= 2'b00;
        end else begin
            // Update flag when first '1' is seen
            if (x && !flag) begin
                flag <= 1'b1;
            end
            
            // Pipeline the flag
            shift_reg <= {shift_reg[0], flag};
        end
    end
    
    // Output is x when flag is 0, ~x when flag is 1
    // Using the pipelined version of flag for proper timing
    assign z = x ^ shift_reg[1];

endmodule