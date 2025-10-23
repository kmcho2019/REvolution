module TopModule(
    input in,
    input [3:0] state,
    output [3:0] next_state,
    output out
);

// One-hot state encoding
wire A = state[0];
wire B = state[1];
wire C = state[2];
wire D = state[3];

// State transition logic
assign next_state[0] = (A & ~in) | (C & ~in) | (D & in);
assign next_state[1] = (A & in) | (B & in) | (D & ~in);
assign next_state[2] = (B & ~in) | (C & in);
assign next_state[3] = (C & in) | (D & in);

// Output logic
assign out = D;

endmodule