module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoded states
wire state_A = y[0]; // 000001
wire state_B = y[1]; // 000010
wire state_C = y[2]; // 000100
wire state_D = y[3]; // 001000
wire state_E = y[4]; // 010000
wire state_F = y[5]; // 100000

// Next-state signals Y2 and Y4
assign Y1 = (state_B & ~w) | (state_D & ~w);
assign Y3 = (state_D & ~w) | (state_B & w) | (state_C & w) | (state_E & w) | (state_F & w);

endmodule