module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state_A = 1'b1, state_B = 1'b0
    reg state_A, state_B;

    // Next state logic - parallel transitions
    wire next_state_A = state_A & ~x;
    wire next_state_B = (state_A & x) | state_B;

    // Output logic - z is x when in A, ~x when in B
    assign z = state_A ? x : ~x;

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule