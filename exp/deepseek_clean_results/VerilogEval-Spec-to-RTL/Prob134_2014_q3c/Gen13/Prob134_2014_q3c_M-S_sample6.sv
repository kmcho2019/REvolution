module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state LSB (Y0) logic
    assign Y0 = x ? (y == 3'b000 || y == 3'b010 || y == 3'b100) :
                   (y == 3'b001 || y == 3'b011);

    // Output z is 1 in states 011 (3) and 100 (4)
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule