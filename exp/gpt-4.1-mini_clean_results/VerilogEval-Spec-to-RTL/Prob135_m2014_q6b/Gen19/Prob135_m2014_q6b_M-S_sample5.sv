module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Next state logic for y[1]
    assign Y1 = (~y[1] & y[0]) | (w & (y[1] | y[2]) & ~y[0]);

endmodule