module TopModule (
    input        clk,   // clock input (not used here)
    input        x,
    input  [2:0] y,     // present state
    output       Y0,
    output       z
);

    // Define next states for x=0 and x=1 for all valid present states
    // For states outside defined set, default to 3'b000
    wire [2:0] next_state_x0;
    wire [2:0] next_state_x1;
    
    // Next state lookup for x=0 (index by y)
    // Encoding only for states 0 to 4 (000 to 100), else 000
    assign next_state_x0 = (y == 3'b000) ? 3'b000 :
                          (y == 3'b001) ? 3'b001 :
                          (y == 3'b010) ? 3'b010 :
                          (y == 3'b011) ? 3'b001 :
                          (y == 3'b100) ? 3'b011 :
                          3'b000;
    // Next state lookup for x=1 (index by y)
    assign next_state_x1 = (y == 3'b000) ? 3'b001 :
                          (y == 3'b001) ? 3'b100 :
                          (y == 3'b010) ? 3'b001 :
                          (y == 3'b011) ? 3'b010 :
                          (y == 3'b100) ? 3'b100 :
                          3'b000;

    // Select next state based on x
    wire [2:0] next_state = x ? next_state_x1 : next_state_x0;

    // Output z: defined only for states 011 and 100, else 0
    // Use a simple combinational decode by encoding z for each state in a vector
    // Index 0 to 7 for all possible y values, states not defined get 0
    wire [7:0] z_lut = 8'b00011000; // bit 3 (011) and bit 4 (100) are set to 1
    wire       z_val = z_lut[y];

    // Assign outputs
    assign Y0 = next_state[0];
    assign z  = z_val;

endmodule