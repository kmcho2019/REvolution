module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state bit calculations
    wire next_Y2 = (y[2] & ~y[1] & x) |         // State 100 stays when x=1
                   (~y[2] & y[1] & y[0] & ~x);   // State 011 -> 001 when x=0

    wire next_Y1 = (~y[2] & y[1] & ~y[0] & ~x) | // State 010 stays when x=0
                   (~y[2] & y[1] & y[0] & x) |  // State 011 -> 010 when x=1
                   (y[2] & ~y[1] & ~y[0] & ~x);  // State 100 -> 011 when x=0

    wire next_Y0 = (~y[2] & ~y[1] & ~y[0] & x) | // State 000 -> 001 when x=1
                   (~y[2] & ~y[1] & y[0] & ~x) | // State 001 stays when x=0
                   (~y[2] & y[1] & ~y[0] & x) |  // State 010 -> 001 when x=1
                   (~y[2] & y[1] & y[0] & ~x) |  // State 011 -> 001 when x=0
                   (y[2] & ~y[1] & ~y[0] & ~x);  // State 100 -> 011 when x=0

    // Output assignments
    assign Y0 = next_Y0;  // Direct connection
    assign z = (y[1] & y[0]) | (y[2] & ~y[1]);  // States 011 or 100

endmodule