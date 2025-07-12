module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Current state is A (000001)
wire state_A = y[0] & ~y[1] & ~y[2] & ~y[3] & ~y[4] & ~y[5];

// Current state is B (000010)
wire state_B = ~y[0] & y[1] & ~y[2] & ~y[3] & ~y[4] & ~y[5];

// Current state is C (000100)
wire state_C = ~y[0] & ~y[1] & y[2] & ~y[3] & ~y[4] & ~y[5];

// Current state is D (001000)
wire state_D = ~y[0] & ~y[1] & ~y[2] & y[3] & ~y[4] & ~y[5];

// Current state is E (010000)
wire state_E = ~y[0] & ~y[1] & ~y[2] & ~y[3] & y[4] & ~y[5];

// Current state is F (100000)
wire state_F = ~y[0] & ~y[1] & ~y[2] & ~y[3] & ~y[4] & y[5];

// Next-state signal Y1 (y[1])
assign Y1 = (state_A & ~w) | (state_F & w);

// Next-state signal Y3 (y[3])
assign Y3 = (state_B & w) | (state_C & w) | (state_E & w) | (state_D & ~w) | (state_F & w);

endmodule