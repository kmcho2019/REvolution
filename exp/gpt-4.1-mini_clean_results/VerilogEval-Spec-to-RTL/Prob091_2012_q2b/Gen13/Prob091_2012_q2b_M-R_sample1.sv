module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    wire w_n = ~w;

    // Next state input logic for y[1] (state B)
    assign Y1 = y[0] & w;

    // Next state input logic for y[3] (state D)
    assign Y3 = w_n & (y[1] | y[2] | y[4] | y[5]);

endmodule