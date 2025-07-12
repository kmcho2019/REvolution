module TopModule (
    input  wire [5:0] y,
    input  wire       w,
    output wire       Y1,
    output wire       Y3
);

    // Y1 is set when current state is A (y[0]) and w=1 => next state B
    assign Y1 = y[0] & w;

    // Y3 is set when transitioning to D from B, C, E, or F with w=0
    assign Y3 = (~w) & (y[1] | y[2] | y[4] | y[5]);

endmodule