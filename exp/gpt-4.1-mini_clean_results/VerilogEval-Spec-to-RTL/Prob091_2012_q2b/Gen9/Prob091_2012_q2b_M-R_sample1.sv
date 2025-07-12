module TopModule(
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);
    wire w_n = ~w;

    // Next state input logic for state B (y[1])
    assign Y1 = y[0] & w;

    // Next state input logic for state D (y[3])
    // Sum of the relevant states ANDed with ~w
    assign Y3 = (y[1] | y[2] | y[4] | y[5]) & w_n;

endmodule