module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state logic using continuous assignments and nested ternary operators
    wire [2:0] Y = (y == 3'b000) ? ((x == 0) ? 3'b000 : 3'b001) :
                   (y == 3'b001) ? ((x == 0) ? 3'b001 : 3'b100) :
                   (y == 3'b010) ? ((x == 0) ? 3'b010 : 3'b001) :
                   (y == 3'b011) ? ((x == 0) ? 3'b001 : 3'b010) :
                   (y == 3'b100) ? ((x == 0) ? 3'b011 : 3'b100) :
                   3'b000; // default safe state

    // Y0 is the LSB of the next state
    assign Y0 = Y[0];

    // Output z depends combinationally on the present state y
    assign z = (y == 3'b011) || (y == 3'b100);

endmodule