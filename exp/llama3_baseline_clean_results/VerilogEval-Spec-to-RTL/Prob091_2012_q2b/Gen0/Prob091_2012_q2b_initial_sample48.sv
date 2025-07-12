module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoded states
wire A = y[0];  // 000001
wire B = y[1];  // 000010
wire C = y[2];  // 000100
wire D = y[3];  // 001000
wire E = y[4];  // 010000
wire F = y[5];  // 100000

// Next state logic for Y1 (y[1])
// Y1 should be 1 when the next state is B (000010) or D (001000)
assign Y1 = (A & ~w) | (B & ~w) | (C & ~w) | (D & w) | (E & ~w) | (F & ~w);

// Next state logic for Y3 (y[3])
// Y3 should be 1 when the next state is D (001000)
assign Y3 = (B & ~w) | (C & ~w) | (D & ~w) | (E & ~w) | (F & ~w);

endmodule