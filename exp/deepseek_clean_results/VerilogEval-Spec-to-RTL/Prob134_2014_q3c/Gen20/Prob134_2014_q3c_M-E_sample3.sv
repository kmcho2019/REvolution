module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state bit 0 (Y0) logic
    wire Y0_bit = (~y[2] & ~y[1] & y[0] & x) |  // State 001 with x=1
                  (~y[2] & y[1] & ~y[0] & x) | // State 010 with x=1
                  (~y[2] & y[1] & y[0] & ~x) |  // State 011 with x=0
                  (y[2] & ~y[1] & ~y[0] & ~x);  // State 100 with x=0

    // Output z logic
    assign z = (y[2] & ~y[1] & ~y[0]) |  // State 100
               (~y[2] & y[1] & y[0]);    // State 011

    assign Y0 = Y0_bit;

endmodule