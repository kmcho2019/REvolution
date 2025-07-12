module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state[0] = A, state[1] = B
    reg [1:0] state;
    wire [1:0] next_state;

    // Optimized next state logic - simpler transitions
    assign next_state[0] = ~x & state[0];  // Stay in A only if x=0
    assign next_state[1] = x | state[1];   // Move to B if x=1 or stay in B

    // More efficient output logic - depends only on state[1]
    assign z = state[1] ? ~x : x;

    // State registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // Reset to state A (one-hot)
        else
            state <= next_state;
    end

endmodule