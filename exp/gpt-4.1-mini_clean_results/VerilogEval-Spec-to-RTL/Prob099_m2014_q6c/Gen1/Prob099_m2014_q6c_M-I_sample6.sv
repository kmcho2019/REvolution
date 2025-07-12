module TopModule (
    input  [5:0] y,
    input        w,
    output       Y2,
    output       Y4
);

// y bits:
// y[0]: A
// y[1]: B
// y[2]: C
// y[3]: D
// y[4]: E
// y[5]: F

// Y2: next y[1] (state B)
// From A with w=0 => B
assign Y2 = y[0] & ~w;

// Y4: next y[3] (state D)
// From B, C, E, F with w=1 => D
assign Y4 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule