module TopModule (
    input [5:0] y,
    input w,
    output Y1,  // Next state y[0] (A)
    output Y3   // Next state y[2] (C)
);

    // Y1: Next state is A (from D with w=1 or staying in A with w=1)
    assign Y1 = (y[3] & w) | (y[0] & w);

    // Y3: Next state is C (from B with w=0 or from F with w=0)
    assign Y3 = (y[1] & ~w) | (y[5] & ~w);

endmodule