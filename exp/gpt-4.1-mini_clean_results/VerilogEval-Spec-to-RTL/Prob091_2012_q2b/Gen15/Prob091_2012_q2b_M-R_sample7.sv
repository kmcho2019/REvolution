module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // Localparams for state bits for readability
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    // Y1 is asserted when in state A and input w is high
    assign Y1 = y[STATE_A] & w;

    // Y3 is asserted when in any of the states B, C, E, or F and w is low
    assign Y3 = (y[STATE_B] | y[STATE_C] | y[STATE_E] | y[STATE_F]) & (~w);

endmodule