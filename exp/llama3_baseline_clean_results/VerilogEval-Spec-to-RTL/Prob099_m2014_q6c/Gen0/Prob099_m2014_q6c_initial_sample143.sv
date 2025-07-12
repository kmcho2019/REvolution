module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// One-hot encoding for states A, B, C, D, E, F
// A: 000001, B: 000010, C: 000100, D: 001000, E: 010000, F: 100000

// Y1 corresponds to state B
assign Y1 = (y[5:0] == 6'b000001 && w == 1) || // A -> A
            (y[5:0] == 6'b000010 && w == 0); // B -> C, D but only keep B when w=0

// Y3 corresponds to state D
assign Y3 = (y[5:0] == 6'b000001 && w == 1) || // A -> A
            (y[5:0] == 6'b000010 && w == 1) || // B -> D
            (y[5:0] == 6'b000100 && w == 1) || // C -> D
            (y[5:0] == 6'b010000 && w == 1) || // E -> D
            (y[5:0] == 6'b001000 && w == 0);  // D -> F but only keep D when w=0

endmodule