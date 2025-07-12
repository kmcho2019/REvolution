module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

// y bits:
// y[0]: A
// y[1]: B
// y[2]: C
// y[3]: D
// y[4]: E
// y[5]: F

// Y1: next y[1] (state B)
// From A with w=0 => B
assign Y1 = y[0] & ~w;

// Y3: next y[3] (state D)
// From B,C,E,F with w=1 => D
assign Y3 = w & (y[1] | y[2] | y[4] | y[5]);

endmodule