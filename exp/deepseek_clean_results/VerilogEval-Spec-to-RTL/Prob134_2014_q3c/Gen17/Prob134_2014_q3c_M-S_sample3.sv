module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state calculation
    wire [2:0] next_state = 
        (y == 3'b000) ? (x ? 3'b001 : 3'b000) :
        (y == 3'b001) ? (x ? 3'b100 : 3'b001) :
        (y == 3'b010) ? (x ? 3'b001 : 3'b010) :
        (y == 3'b011) ? (x ? 3'b010 : 3'b001) :
        (x ? 3'b100 : 3'b011); // state 100

    // Output assignments
    assign Y0 = next_state[0];
    assign z = (y == 3'b011 || y == 3'b100);

endmodule