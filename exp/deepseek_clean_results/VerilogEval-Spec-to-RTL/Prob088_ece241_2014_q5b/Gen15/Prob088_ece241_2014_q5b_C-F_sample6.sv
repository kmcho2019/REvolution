module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State signals (one-hot encoding)
    wire state_A, state_B;
    wire next_state_A, next_state_B;

    // Optimized next state logic
    assign next_state_A = state_A & ~x;       // Stay in A only if x=0
    assign next_state_B = (state_A & x) | state_B; // Move to B if x=1 or stay in B

    // Optimized output logic - only depends on current state and input
    assign z = state_A ? x : ~x;

    // State registers with async reset (using modular DFFs)
    dff state_A_ff (
        .clk(clk),
        .arst(areset),
        .d(next_state_A),
        .q(state_A),
        .reset_val(1'b1)  // Reset to state A (one-hot)
    );

    dff state_B_ff (
        .clk(clk),
        .arst(areset),
        .d(next_state_B),
        .q(state_B),
        .reset_val(1'b0)  // Reset to 0 (not state A)
    );

endmodule

// Optimized D flip-flop with async reset
module dff (
    input clk,
    input arst,
    input d,
    output reg q,
    input reset_val
);
    always @(posedge clk or posedge arst) begin
        if (arst)
            q <= reset_val;
        else
            q <= d;
    end
endmodule