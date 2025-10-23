module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire cond1 = y[0] & ~y[1];
    wire cond2 = ~y[0] & w & (y[1] | y[2]);

    assign Y1 = cond1 | cond2;

endmodule