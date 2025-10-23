module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state wires (combinational next state)
    wire state_A, state_B;
    
    // State registers (flip-flops)
    reg state_A_reg, state_B_reg;
    
    // Next state logic (continuous assignments)
    assign state_A = ~areset ? (~x & state_A_reg) : 1'b1;
    assign state_B = ~areset ? (x | state_B_reg) : 1'b0;
    
    // Output logic
    assign z = (state_A_reg & x) | (state_B_reg & ~x);
    
    // State register updates
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A_reg <= 1'b1;
            state_B_reg <= 1'b0;
        end else begin
            state_A_reg <= state_A;
            state_B_reg <= state_B;
        end
    end

endmodule