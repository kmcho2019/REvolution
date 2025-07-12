module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire y0_and_not_y1;
    wire not_y0_and_w;
    wire y1_or_y2;

    assign y0_and_not_y1 = y[0] & ~y[1];
    assign not_y0_and_w = ~y[0] & w;
    assign y1_or_y2 = y[1] | y[2];

    assign Y1 = y0_and_not_y1 | (not_y0_and_w & y1_or_y2);

endmodule