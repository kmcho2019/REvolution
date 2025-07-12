module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// For Y1, it should be '1' when the next state will be B
// This happens when current state is A and w is '1'
assign Y1 = y[0] && w;

// For Y3, it should be '1' when the next state will be C
// This can happen from B (when w is '1') or from F (when w is '1')
assign Y3 = (y[1] && w) || (y[5] && w);

endmodule