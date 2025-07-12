module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state registers
    reg state_A, state_B;

    // Next state logic (optimized combinational)
    // State A remains active when x=0
    wire next_state_A = state_A & ~x;
    // State B becomes/stays active when either in B or transitioning from A with x=1
    wire next_state_B = state_B | (state_A & x);

    // Output logic (combinational Mealy output)
    // z = x when in state A, ~x when in state B
    assign z = state_A ? x : ~x;

    // State register updates with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to state A (one-hot)
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            // Normal state transitions
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule