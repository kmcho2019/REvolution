module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    wire [2:0] next_state;

    // Compute next state using continuous assign with ternary operators
    assign next_state = (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
                        (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
                        (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
                        (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
                        (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
                        3'b000;  // default safe state

    // z is 1 when y == 3'b011 or y == 3'b100
    assign z = (y[2] & ~y[1] & y[0]) | (y[2] & ~y[1] & ~y[0]);

    // Y0 is LSB of next_state
    assign Y0 = next_state[0];

endmodule