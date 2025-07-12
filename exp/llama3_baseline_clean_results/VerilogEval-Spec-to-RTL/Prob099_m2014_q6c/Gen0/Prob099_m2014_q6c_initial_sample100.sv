module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Derive the logic equations for Y1 (state B) and Y3 (state D) by inspection
// Y1 is set when transitioning to state B
// This happens from state A when w is 0
assign Y1 = (y[0] && !w); // Transition from A to B

// Y3 is set when transitioning to state D
// This happens from state B when w is 1, from state C when w is 1, 
// from state D when w is 1, and from state E when w is 1 and y[4] is 1
assign Y3 = ((y[1] && w) || (y[2] && w) || (y[3] && w) || (y[4] && w));

endmodule