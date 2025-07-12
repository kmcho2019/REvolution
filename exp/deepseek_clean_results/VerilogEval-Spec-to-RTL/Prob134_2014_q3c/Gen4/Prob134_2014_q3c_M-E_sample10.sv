module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // LUT for next states {x=0, x=1} for each state
    reg [5:0] state_lut [0:4];
    initial begin
        state_lut[0] = 6'b000_001; // state 000
        state_lut[1] = 6'b001_100; // state 001
        state_lut[2] = 6'b010_001; // state 010
        state_lut[3] = 6'b001_010; // state 011
        state_lut[4] = 6'b011_100; // state 100
    end

    // Get next state (3 bits) based on current state and x
    wire [2:0] next_state = x ? state_lut[y][2:0] : state_lut[y][5:3];

    // Output logic
    assign z = (y[1] & y[0]) | (y[2] & ~y[1] & ~y[0]); // z=1 for states 011 and 100
    assign Y0 = next_state[0];

endmodule