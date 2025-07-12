module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    // One-hot state encoding: 
    // state[0] = state A
    // state[1] = state B
    reg [1:0] state;

    // Next state logic (one-hot optimized)
    wire [1:0] next_state;
    assign next_state[0] = state[0] & ~x;  // Stay in A only if x=0
    assign next_state[1] = (state[0] & x) | state[1];  // Move to B on x=1 or stay in B

    // Output logic - simple mux based on current state
    assign z = state[1] ? ~x : x;

    // State transition with async reset
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 2'b01;  // Reset to state A (01 in one-hot)
        end
        else begin
            state <= next_state;
        end
    end

endmodule