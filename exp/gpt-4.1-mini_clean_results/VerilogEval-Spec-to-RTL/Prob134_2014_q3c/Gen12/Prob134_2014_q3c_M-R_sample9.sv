module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Compute next state using combinational assigns with conditional (ternary) operators
    wire [2:0] next_state = (y == 3'b000) ? ((x == 1'b0) ? 3'b000 : 3'b001) :
                           (y == 3'b001) ? ((x == 1'b0) ? 3'b001 : 3'b100) :
                           (y == 3'b010) ? ((x == 1'b0) ? 3'b010 : 3'b001) :
                           (y == 3'b011) ? ((x == 1'b0) ? 3'b001 : 3'b010) :
                           (y == 3'b100) ? ((x == 1'b0) ? 3'b011 : 3'b100) :
                                           3'b000;

    // Output z is high only for present states 3'b011 or 3'b100
    wire z_w = (y == 3'b011) || (y == 3'b100);

    // Outputs
    assign z  = z_w;
    assign Y0 = next_state[0];

endmodule