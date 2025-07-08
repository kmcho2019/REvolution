module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,  // corresponds to y[1]
    output       Y3   // corresponds to y[3]
);

    // Next state for y[1] (B)
    assign Y1 = y[0] & ~w;

    // Next state for y[3] (D)
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w;

endmodule