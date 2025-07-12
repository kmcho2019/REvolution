module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Simplified next state LSB logic
    assign Y0 = x ? (y == 3'b000 || y == 3'b011 ? ~y[0] : y[0]) 
                 : (y == 3'b000 ? 1'b0 : y[0]);

    // Output z is 1 when y is 011 or 100
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule