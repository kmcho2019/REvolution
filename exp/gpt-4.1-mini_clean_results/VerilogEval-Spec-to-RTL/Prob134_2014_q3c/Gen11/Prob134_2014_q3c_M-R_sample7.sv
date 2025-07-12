module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state logic encoded as a combinational expression using case and ternary operators
    wire [2:0] next_state = (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
                            (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
                            (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
                            (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
                            (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
                            3'b000;

    // Output z is high only for states 011 and 100
    wire z_wire = (y == 3'b011) || (y == 3'b100);

    assign Y0 = next_state[0];
    assign z  = z_wire;

endmodule