module TopModule (
    input        clk,    // clock input (not used)
    input        x,
    input  [2:0] y,      // present state
    output       Y0,
    output       z
);

    // Next state bits computed independently as functions of y and x
    wire Y2, Y1, Y0_int;

    // Next state bit 2 (Y[2])
    assign Y2 = (y == 3'b001 & x == 1'b1) | (y == 3'b100 & x == 1'b0);

    // Next state bit 1 (Y[1])
    assign Y1 = (y == 3'b100 & x == 1'b1) | (y == 3'b011 & x == 1'b1) | (y == 3'b010 & x == 1'b0);

    // Next state bit 0 (Y[0]) - also output Y0
    assign Y0_int = (y == 3'b000 & x == 1'b1) |
                    (y == 3'b001 & x == 1'b0) |
                    (y == 3'b010 & x == 1'b1) |
                    (y == 3'b011 & x == 1'b0) |
                    (y == 3'b100 & x == 1'b1);

    // Output z is 1 when present state is 011 or 100
    assign z = (y == 3'b011) | (y == 3'b100);

    // Output Y0 is LSB of next state
    assign Y0 = Y0_int;

endmodule