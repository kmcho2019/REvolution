module TopModule (
    input  [5:0] y, // current one-hot state: A=y[0], B=y[1], C=y[2], D=y[3], E=y[4], F=y[5]
    input        w,
    output       Y1, // next-state signal for state B (y[1])
    output       Y3  // next-state signal for state D (y[3])
);

// Decode current states explicitly for clarity
wire A = y[0];
wire B = y[1];
wire C = y[2];
wire D = y[3];
wire E = y[4];
wire F = y[5];

// Next-state logic by inspection from the FSM and transitions
// Y1 corresponds to next-state B: active when current A and w=0
assign Y1 = A & ~w;

// Y3 corresponds to next-state D: active when current state in {B, C, E, F} and w=1
assign Y3 = w & (B | C | E | F);

endmodule