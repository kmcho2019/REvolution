module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // next y[1] logic derived from state transitions:
    // next_y1 = y[0] | (y[1] & w) | (y[2] & ~y[1]);

    assign Y1 = y[0] | (y[1] & w) | (y[2] & ~y[1]);

endmodule