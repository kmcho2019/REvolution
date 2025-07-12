module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state[0] = A, state[1] = B
    reg [1:0] state;
    wire [1:0] next_state;

    // Next state logic - direct one-hot assignments
    assign next_state[0] = state[0] & ~x;  // Stay in A if x=0
    assign next_state[1] = (state[0] & x) | state[1];  // Move to B if x=1 or stay in B

    // Output logic - combinational function of state and input
    assign z = state[0] ? x : ~x;

    // State registers with async reset
    always @(posedge clk or posedge areset) begin
        if (areset)
            state <= 2'b01;  // Reset to state A (one-hot)
        else
            state <= next_state;
    end

endmodule