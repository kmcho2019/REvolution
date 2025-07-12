module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state_A, state_B;  // One-hot state registers

    // Simplified state transition logic
    wire next_state_A = state_A & ~x;
    wire next_state_B = (state_A & x) | (state_B & ~x);

    // Optimized output logic - purely combinational from current state and input
    assign z = (state_A & x) | (state_B & ~x);

    // State registers using standard library DFFs
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state_A <= 1'b1;  // Reset to state A
            state_B <= 1'b0;
        end else begin
            state_A <= next_state_A;
            state_B <= next_state_B;
        end
    end

endmodule