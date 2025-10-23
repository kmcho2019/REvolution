module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state registers
    reg state_A, state_B;

    // Next state logic (combinational)
    // State A remains active only when x=0
    wire next_state_A = state_A & ~x;
    // State B is active when not in state A (one-hot property)
    wire next_state_B = ~next_state_A;

    // Output logic (combinational Mealy output)
    // z = x when in state A, ~x when in state B
    assign z = state_A ? x : ~x;

    // State register updates (sequential)
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            // Asynchronous reset to state A
            state_A <= 1'b1;
            state_B <= 1'b0;
        end else begin
            // Normal state transition
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule