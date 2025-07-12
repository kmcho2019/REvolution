module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
    );

// y[5:0] = 000001(A), 000010(B), 000100(C), 001000(D), 010000(E), 100000(F)
// For Y1 (input of state flip-flop y[1])
assign Y1 = (y[1] & ~w) | (y[3] & ~w) | (y[5] & w & y[0]) | (y[4] & ~w);

// For Y3 (input of state flip-flop y[3])
assign Y3 = (y[3] & ~w) | (y[4] & ~w) | (y[2] & ~w);

endmodule