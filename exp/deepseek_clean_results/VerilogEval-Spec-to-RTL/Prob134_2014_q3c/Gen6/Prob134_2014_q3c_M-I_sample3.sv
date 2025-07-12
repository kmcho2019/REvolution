module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Combined next state and output logic
    assign Y0 = (x ? 
                (y == 3'b000 ? 1'b1 : 
                 y == 3'b001 ? 1'b0 : 
                 y == 3'b010 ? 1'b1 : 
                 y == 3'b011 ? 1'b0 : 
                 1'b0) : 
                (y == 3'b000 ? 1'b0 : 
                 y == 3'b001 ? 1'b1 : 
                 y == 3'b010 ? 1'b0 : 
                 y == 3'b011 ? 1'b1 : 
                 1'b1));

    // Output z is 1 only in states 011 and 100
    assign z = (y[2] & ~y[1]) | (y[1] & y[0]);  // Equivalent to y == 3'b011 || y == 3'b100

endmodule