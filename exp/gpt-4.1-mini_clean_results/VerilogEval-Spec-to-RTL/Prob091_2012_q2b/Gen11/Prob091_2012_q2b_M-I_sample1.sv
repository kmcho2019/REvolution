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
    // Y3 is asserted when w=0 and current state is B, C, E, or F:
    // Factor OR into two 2-input OR gates for better synthesis:
    wire bc = y[1] | y[2];
    wire ef = y[4] | y[5];
    assign Y3 = w_n & (bc | ef);
endmodule