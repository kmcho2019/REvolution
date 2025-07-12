module TopModule (
    input  wire [2:0] y,
    input  wire       w,
    output wire       Y1
);

    // Simplified combinational logic for next state bit y[1]
    // Expression derived to: Y1 = (y[0] & ~y[1]) | (~y[0] & w & (y[1] | y[2]))
    assign Y1 = (y[0] & ~y[1]) | (~y[0] & w & (y[1] | y[2]));

endmodule