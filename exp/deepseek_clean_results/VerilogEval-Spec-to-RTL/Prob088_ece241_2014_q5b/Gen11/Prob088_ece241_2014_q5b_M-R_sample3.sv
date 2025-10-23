module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: 01 for A, 10 for B
    reg [1:0] state;

    // Combinational next state logic
    wire [1:0] next_state;
    assign next_state[0] = ~x & state[0];        // Stay in A only if x=0
    assign next_state[1] = (state[0] & x) | state[1];  // Move to B on x=1 or stay in B

    // Output logic - z depends on current state and input
    assign z = state[0] ? x : ~x;

    // State transition with asynchronous reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A
        end
        else begin
            state <= next_state;
        end
    end

endmodule