module TopModule (
    input clk,       // clock input (not used)
    input x,
    input [2:0] y,   // present state input
    output Y0,
    output z
);

    // Combinational logic for next state using nested ternary operators
    wire [2:0] next_state = (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
                            (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
                            (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
                            (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
                            (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
                            3'b000; // default for invalid states

    // Output z depends solely on present state y
    assign z = (y == 3'b011) || (y == 3'b100);

    // Y0 is the LSB of next_state
    assign Y0 = next_state[0];

endmodule