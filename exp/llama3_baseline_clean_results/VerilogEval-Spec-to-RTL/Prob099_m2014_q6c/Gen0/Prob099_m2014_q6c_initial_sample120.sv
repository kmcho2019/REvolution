module TopModule(
    input  wire [5:0] y,
    input  wire w,
    output wire Y1,
    output wire Y3
);

// One-hot encoding: y[5:0] = 000001, 000010, 000100, 001000, 010000, 100000 for states A, B, C, D, E, F respectively
// Derive logic equations by inspection
assign Y1 = (~y[5] & ~y[4] & ~y[3] & ~y[2] & y[1] & ~y[0] & ~w) | (~y[5] & ~y[4] & ~y[3] & ~y[2] & ~y[1] & y[0] & ~w); // Y1 (next state B)
assign Y3 = (~y[5] & ~y[4] & ~y[3] & y[2] & ~y[1] & ~y[0] & ~w) | (~y[5] & ~y[4] & y[3] & ~y[2] & ~y[1] & ~y[0] & w) | (~y[5] & y[4] & ~y[3] & ~y[2] & ~y[1] & ~y[0] & w); // Y3 (next state D)

endmodule