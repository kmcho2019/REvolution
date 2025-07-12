module TopModule (
    input  [5:0] y,
    input        w,
    output       Y1,
    output       Y3
);

    // State bit indices for readability
    localparam STATE_A = 0;
    localparam STATE_B = 1;
    localparam STATE_C = 2;
    localparam STATE_D = 3;
    localparam STATE_E = 4;
    localparam STATE_F = 5;

    assign Y1 = y[STATE_A] & w;
    assign Y3 = (~w) & (y[STATE_B] | y[STATE_C] | y[STATE_E] | y[STATE_F]);

endmodule