module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state registers: state_A and state_B
    reg state_A, state_B;

    // Next state logic - shift right when x=1 in state_A
    wire next_state_A = state_A & ~x;
    wire next_state_B = (state_A & x) | state_B;

    // Output logic - Mealy output depends on current state and input
    assign z = (state_A & x) | (state_B & ~x);

    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A (one-hot 10)
            state_B <= 1'b0;
        end
        else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule