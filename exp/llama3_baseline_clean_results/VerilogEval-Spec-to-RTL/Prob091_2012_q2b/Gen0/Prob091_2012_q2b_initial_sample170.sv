module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// Y1 is set when in states B (000010) or D (001000)
assign Y1 = y[1] | (y[3] & ~w);

// Y3 is set when in state D (001000)
assign Y3 = y[3];

endmodule