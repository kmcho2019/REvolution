module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Simplified next state logic for y[1]
    // After Boolean reduction:
    // Y1 = (y[0] & ~y[1]) | (~y[0] & w & y[2])
    assign Y1 = (y[0] & ~y[1]) | (~y[0] & w & y[2]);

endmodule