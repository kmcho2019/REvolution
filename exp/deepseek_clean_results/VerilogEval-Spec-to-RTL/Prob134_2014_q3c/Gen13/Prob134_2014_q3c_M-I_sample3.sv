module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Optimized next state logic for Y0
    assign Y0 = (x & ~y[2] & ~y[1]) |              // x=1 and states 000,001
                (~x & y[0]) |                       // x=0 and states 001,011
                (x & y[1] & ~y[0]);                // x=1 and state 010

    // Optimized output logic
    assign z = y[2] | (y[1] & y[0]);  // States 011 (3'b011) or 100 (3'b100)

endmodule