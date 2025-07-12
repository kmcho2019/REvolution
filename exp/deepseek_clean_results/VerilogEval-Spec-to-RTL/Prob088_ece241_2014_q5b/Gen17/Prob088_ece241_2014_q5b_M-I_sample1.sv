module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // State signals (one-hot encoding)
    wire state_A, state_B;
    wire next_state_A, next_state_B;

    // Simplified next state logic
    assign next_state_A = ~x & state_A;  // Stay in A only if x=0
    assign next_state_B = x | state_B;   // Move to B if x=1 or stay in B

    // Optimized output logic
    assign z = (state_A & x) | (state_B & ~x);

    // State registers with async reset
    dff state_A_ff (
        .clk(clk),
        .arst(areset),
        .d(next_state_A),
        .q(state_A),
        .reset_val(1'b1)  // Reset to state A
    );

    dff state_B_ff (
        .clk(clk),
        .arst(areset),
        .d(next_state_B),
        .q(state_B),
        .reset_val(1'b0)   // Reset to 0 (not state A)
    );

endmodule

// D flip-flop with async reset primitive
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