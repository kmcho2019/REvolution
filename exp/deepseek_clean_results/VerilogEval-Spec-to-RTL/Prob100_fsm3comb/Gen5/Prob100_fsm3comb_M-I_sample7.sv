module TopModule (
    input in,
    input [1:0] state,
    output [1:0] next_state,
    output out
);

// State decoding
wire is_A = (state == 2'b00);
wire is_B = (state == 2'b01);
wire is_C = (state == 2'b10);
wire is_D = (state == 2'b11);

// Output depends only on current state (Moore machine)
assign out = is_D;  // 1 when in state D

// Optimized next state logic
assign next_state[1] = (is_B & ~in) | (is_C & in) | (is_D & ~in);
assign next_state[0] = (is_A & in) | (is_B & in) | (is_C & in) | (is_D & in);

endmodule