module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    wire next_y1;

    assign next_y1 = (y[0] & ~y[1]) | (~y[0] & w & (y[1] | y[2]));
    assign Y1 = next_y1;

endmodule