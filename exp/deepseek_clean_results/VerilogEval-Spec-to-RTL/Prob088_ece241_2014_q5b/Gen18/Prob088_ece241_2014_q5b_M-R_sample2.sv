module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state wires
    wire state_A, state_B;
    reg state_A_reg, state_B_reg;

    // State transition logic (combinational)
    assign state_A = ~areset & (state_A_reg & ~x);
    assign state_B = ~areset & ((state_A_reg & x) | state_B_reg);

    // Output logic
    assign z = state_A ? x : ~x;

    // State registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A_reg <= 1'b1;
            state_B_reg <= 1'b0;
        end
        else begin
            state_A_reg <= state_A;
            state_B_reg <= state_B;
        end
    end

endmodule