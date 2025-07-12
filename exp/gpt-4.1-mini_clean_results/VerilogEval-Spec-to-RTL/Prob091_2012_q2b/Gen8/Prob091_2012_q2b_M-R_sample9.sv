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
    // Y3 = (~w) & ~(y[0] | y[3])
    assign Y3 = w_n & ~(y[0] | y[3]);

endmodule