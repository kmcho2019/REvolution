module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state[1:0] where
    // state[0] = state_A, state[1] = state_B
    reg [1:0] state;

    // Next state logic
    wire [1:0] next_state;
    assign next_state[0] = ~x & state[0];       // Stay in A if x=0
    assign next_state[1] = x | state[1];        // Move to B if x=1 or stay in B

    // Output logic - z is x when in state A, ~x otherwise
    assign z = state[0] ? x : ~x;

    // State update with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A (one-hot)
        end else begin
            state <= next_state;
        end
    end

endmodule