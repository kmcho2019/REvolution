module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state Y0 (LSB) calculation using ternary operators
    assign Y0 = (y == 3'b000) ? (x ? 1'b1 : 1'b0) :
                (y == 3'b001) ? (x ? 1'b0 : 1'b1) :
                (y == 3'b010) ? (x ? 1'b1 : 1'b0) :
                (y == 3'b011) ? (x ? 1'b0 : 1'b1) :
                (y == 3'b100) ? (x ? 1'b0 : 1'b1) :
                1'b0; // default case

    // Output z is 1 when state is 011 or 100
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule