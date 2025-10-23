module TopModule(
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

// Internal signals for next-state logic
wire Y2_int, Y4_int;

// Next-state signal Y1 (state B)
assign Y1 = y[0] && ~w || y[5] && ~w;

// Next-state signal Y2 (state C)
assign Y2_int = y[1] && ~w;

// Next-state signal Y3 (state D)
assign Y3 = y[1] && w || y[2] && w || y[3] && w || y[4] && w;

// Next-state signal Y4 (state E)
assign Y4_int = y[2] && w;

// Output assignments for required signals
assign Y1 = Y1;
assign Y3 = Y3;

// Optional output assignments for internal signals (for debugging purposes)
// assign Y2 = Y2_int;
// assign Y4 = Y4_int;

endmodule