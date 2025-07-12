module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // Individual state wires for one-hot encoding
    wire state_A, state_B;
    reg state_A_reg, state_B_reg;

    // Continuous assignments for state registers with async reset
    assign state_A = areset ? 1'b1 : state_A_reg;
    assign state_B = areset ? 1'b0 : state_B_reg;

    // Next state logic - direct assignments
    assign state_A_reg = state_A & ~x;
    assign state_B_reg = (state_A & x) | state_B;

    // Output logic - same as original but using state wires
    assign z = state_A ? x : ~x;

    // Clocked state updates
    always @(posedge clk) begin
        state_A_reg <= state_A;
        state_B_reg <= state_B;
    end

endmodule