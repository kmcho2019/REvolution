module TopModule (
    input  wire clk,
    input  wire areset,
    input  wire x,
    output wire z
);

// State encoding: one-hot with 2 bits
// state[1] = state_B, state[0] = state_A
reg [1:0] state, next_state;

// Next state logic
assign next_state[0] = state[0] & ~x;        // Stay in A if in A and x=0
assign next_state[1] = (state[0] & x) | state[1]; // Move to B if in A and x=1 or stay in B

// Output logic (Mealy)
assign z = (state[0]) ? x : ~x;

// Sequential logic with asynchronous active-high reset
always @(posedge clk or posedge areset) begin
    if (areset)
        state <= 2'b01; // Reset to state A (one-hot)
    else
        state <= next_state;
end

endmodule