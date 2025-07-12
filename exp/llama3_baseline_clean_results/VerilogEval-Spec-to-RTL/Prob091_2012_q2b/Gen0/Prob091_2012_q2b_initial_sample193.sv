module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// State A: y = 000001, Y1 = 0, Y3 = 0
// State B: y = 000010, Y1 = 1, Y3 = 0
// State C: y = 000100, Y1 = 0, Y3 = 1
// State D: y = 001000, Y1 = 0, Y3 = 0
// State E: y = 010000, Y1 = 0, Y3 = 0
// State F: y = 100000, Y1 = 0, Y3 = 0

// Y1 is high when state B is next
assign Y1 = (y[5] && w) || (y[4] && w) || (y[1] && ~w);

// Y3 is high when state C is next
assign Y3 = (y[1] && w) || (y[4] && w) || (y[0] && ~w);

endmodule