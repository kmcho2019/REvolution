module TopModule (
    input        clk,  // clk unused, as FSM state is input-driven
    input        x,
    input  [2:0] y,    // present state input
    output       Y0,
    output       z
);

    wire [2:0] next_state;
    wire       z_w;

    // Next state logic using nested ternary operators
    assign next_state =
        (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
        (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
        (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
        (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
        (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
        3'b000; // default

    // Output logic for z
    assign z_w =
        (y == 3'b011) ? 1'b1 :
        (y == 3'b100) ? 1'b1 :
        1'b0;

    assign z = z_w;
    assign Y0 = next_state[0];

endmodule