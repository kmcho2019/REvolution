module TopModule(
    input  [5:0] y,
    input  w,
    output Y1,
    output Y3
);

// Since Y1 and Y3 are directly given by the state encoding, 
// no additional logic is needed for these outputs.
assign Y1 = y[0]; // Directly from state encoding
assign Y3 = y[2]; // Directly from state encoding

// Derive next-state signals Y2 and Y4
// Y2 (y[1]) is set when in state B or transitioning to B from A on w=1, or transitioning to D from C or E on w=1
assign Y2 = (y[1] && ~w) || (y[0] && w) || (y[2] && w) || (y[4] && w);

// Y4 (y[3]) is set when in state D or transitioning to D from B, C, E, or F on w=1
assign Y4 = (y[3] && ~w) || (y[1] && w) || (y[2] && w) || (y[4] && w) || (y[5] && w);

endmodule