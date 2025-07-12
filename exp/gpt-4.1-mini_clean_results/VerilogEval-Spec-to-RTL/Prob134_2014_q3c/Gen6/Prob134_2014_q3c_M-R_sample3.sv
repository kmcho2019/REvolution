module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Next state logic using combinational assign statements and conditional operators
    wire [2:0] next_state;

    assign next_state = 
        (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
        (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
        (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
        (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
        (y == 3'b100) ? (x ? 3'b100 : 3'b011) :
                        3'b000; // default safe state

    // Output z depends on present state only: 1 for 011 and 100, else 0
    assign z = (y == 3'b011) || (y == 3'b100);

    // Output Y0 is LSB of next state
    assign Y0 = next_state[0];

endmodule