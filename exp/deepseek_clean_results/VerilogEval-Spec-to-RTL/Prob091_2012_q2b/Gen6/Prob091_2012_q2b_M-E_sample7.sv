module TopModule (
    input [5:0] y,
    input w,
    output Y1,
    output Y3
);

    // Common inverted w signal
    wire w_n;
    assign w_n = ~w;

    // Next state for y[1] (Y1)
    assign Y1 = y[0] & w;

    // Next state for y[3] (Y3)
    wire or_out;
    assign or_out = y[1] | y[2] | y[4] | y[5];
    assign Y3 = w_n & or_out;

endmodule