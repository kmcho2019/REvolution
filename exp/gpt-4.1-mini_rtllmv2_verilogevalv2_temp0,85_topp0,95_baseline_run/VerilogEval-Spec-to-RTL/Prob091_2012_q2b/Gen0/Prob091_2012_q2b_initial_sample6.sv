module TopModule (
    input  wire [5:0] y,
    input  wire       w,
    output wire       Y1,
    output wire       Y3
);

    // Y1: next state input for y[1] (state B)
    // From A (y[0]) with w=1
    assign Y1 = y[0] & w;

    // Y3: next state input for y[3] (state D)
    // From B, C, E, F with w=0
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule