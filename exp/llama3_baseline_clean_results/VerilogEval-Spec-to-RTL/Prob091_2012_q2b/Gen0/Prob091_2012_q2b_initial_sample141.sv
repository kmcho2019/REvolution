module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Y1 corresponds to state B (000010)
// State B is entered from A when w is 0, or from F when w is 1
assign Y1 = (y[0] &&!w) || (y[5] && w);

// Y3 corresponds to state D (001000)
// State D is entered from B when w is 0, from C when w is 0, 
// from E when w is 0, or from D when w is 0 (self-loop not needed)
// Also, D can be entered from F when w is 0
assign Y3 = (!w && (y[1] || y[2] || y[4] || y[5]));

endmodule