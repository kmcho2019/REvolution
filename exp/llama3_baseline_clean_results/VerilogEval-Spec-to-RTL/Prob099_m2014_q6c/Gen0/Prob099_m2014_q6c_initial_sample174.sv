module TopModule(
    input [5:0] y, // Current state
    input w,       // Input signal
    output Y1,     // Next-state signal for y[0]
    output Y3      // Next-state signal for y[2]
);

// One-hot encoded states
wire state_A = y[0]; // 000001
wire state_B = y[1]; // 000010
wire state_C = y[2]; // 000100
wire state_D = y[3]; // 001000
wire state_E = y[4]; // 010000
wire state_F = y[5]; // 100000

// Next-state logic for Y1 (y[0])
assign Y1 = (state_A & ~w) | (state_D & w);

// Next-state logic for Y3 (y[2])
assign Y3 = (state_B & ~w) | (state_F & w) | (state_E & ~w);

endmodule