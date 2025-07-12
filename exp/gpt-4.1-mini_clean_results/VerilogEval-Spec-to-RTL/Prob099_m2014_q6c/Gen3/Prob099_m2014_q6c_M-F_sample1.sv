module TopModule (
    input  [5:0] y,
    input        w,
    output       Y2,
    output       Y4
);

// Next y[1] (state B) active if in state A and w=0
assign Y2 = y[0] & ~w;

// Next y[3] (state D) active if w=1 and in states B, C, E, or F
assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule