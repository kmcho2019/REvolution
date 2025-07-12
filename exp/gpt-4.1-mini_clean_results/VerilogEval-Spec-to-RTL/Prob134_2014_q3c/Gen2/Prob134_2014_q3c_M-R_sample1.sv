module TopModule(
    input clk,
    input x,
    input [2:0] y,    // Present state
    output Y0,
    output z
);

    // Next state logic using conditional operators
    wire [2:0] Y_next = 
        (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
        (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
        (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
        (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
        (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
                        3'b000;  // default state if unknown

    // Output logic based on present state
    assign z = (y == 3'b011) || (y == 3'b100) ? 1'b1 : 1'b0;

    // Output Y0 is LSB of next state
    assign Y0 = Y_next[0];

endmodule