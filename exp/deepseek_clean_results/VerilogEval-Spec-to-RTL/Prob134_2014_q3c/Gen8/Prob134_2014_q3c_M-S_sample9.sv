module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state LSB (Y0) directly from truth table
    assign Y0 = (x) ? 
                ((y == 3'b000) ? 1'b1 :  // Next state 001
                 (y == 3'b001) ? 1'b0 :  // Next state 100
                 (y == 3'b010) ? 1'b1 :  // Next state 001
                 (y == 3'b011) ? 1'b0 :  // Next state 010
                 1'b0) :                 // Next state 100 (Y0=0)
                ((y == 3'b000) ? 1'b0 :  // Next state 000
                 (y == 3'b001) ? 1'b1 :  // Next state 001
                 (y == 3'b010) ? 1'b0 :  // Next state 010
                 (y == 3'b011) ? 1'b1 :  // Next state 001
                 1'b1);                  // Next state 011 (Y0=1)

    // z is 1 when y is 011 or 100
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule