module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

assign Y1 = y[3] & w; // Next state A when current state D and w = 1
assign Y3 = (y[1] & w) | (y[2] & w) | (y[4] & w) | (y[5] & w); // Next state D when current state B, C, E, or F and w = 1

endmodule