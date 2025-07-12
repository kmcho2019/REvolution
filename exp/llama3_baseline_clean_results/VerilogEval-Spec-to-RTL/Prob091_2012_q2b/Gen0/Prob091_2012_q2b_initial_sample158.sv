module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 should be 1 when transitioning to state B
assign Y1 = (y[0] && w); // Transition from A to B when w=1

// Y3 should be 1 when transitioning to states D or E
assign Y3 = (y[1] && ~w) || (y[2] && ~w) || (y[4] && w) || (y[5] && ~w);
// Transition from B to D when w=0, from C to D when w=0, from E to E when w=1, from F to D when w=0

endmodule