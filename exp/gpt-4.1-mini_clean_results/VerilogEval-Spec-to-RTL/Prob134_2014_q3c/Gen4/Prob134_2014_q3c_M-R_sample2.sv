module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state logic assigned combinationally using conditional operators
    wire [2:0] Y;

    assign Y = (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
               (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
               (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
               (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
               (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
               3'b000;  // default

    // Output Y0 is the least significant bit of the next state Y
    assign Y0 = Y[0];

    // Output z combinationally derived from present state y
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule