module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // LUT for next states [x=1][x=0] packed as {Y_x1, Y_x0}
    wire [5:0] lut [0:4] = {
        6'b001000,  // state 000: x1=001, x0=000
        6'b100001,  // state 001: x1=100, x0=001
        6'b001010,  // state 010: x1=001, x0=010
        6'b010001,  // state 011: x1=010, x0=001
        6'b100011   // state 100: x1=100, x0=011
    };

    // Get both possible next states
    wire [2:0] next_x0 = lut[y][2:0];
    wire [2:0] next_x1 = lut[y][5:3];
    
    // Select next state based on x
    wire [2:0] next_state = x ? next_x1 : next_x0;
    
    // Output assignments
    assign Y0 = next_state[0];
    assign z = (y == 3'b011) | (y == 3'b100);

endmodule