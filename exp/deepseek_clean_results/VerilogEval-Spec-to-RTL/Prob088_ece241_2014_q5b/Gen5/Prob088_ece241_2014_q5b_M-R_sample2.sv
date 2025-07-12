module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: state[0] = A, state[1] = B
    reg [1:0] state;

    // Next state logic using continuous assignment
    wire [1:0] next_state;
    assign next_state[0] = state[0] & ~x;  // Stay in A if x=0
    assign next_state[1] = (state[0] & x) | state[1];  // Move to B on x=1 or stay in B

    // Output logic - Mealy style (depends on current state and input)
    assign z = state[0] ? x : ~x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A (one-hot)
        end
        else begin
            state <= next_state;
        end
    end

endmodule