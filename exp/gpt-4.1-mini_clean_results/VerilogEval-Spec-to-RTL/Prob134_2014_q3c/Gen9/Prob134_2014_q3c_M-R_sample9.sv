module TopModule (
    input        clk,
    input        x,
    input  [2:0] y,
    output       Y0,
    output       z
);

    // Lookup tables for next state when x=0 and x=1
    // Index corresponds to present state y
    reg [2:0] next_state_x0 [0:4];
    reg [2:0] next_state_x1 [0:4];

    initial begin
        // Initialize next state for x=0
        next_state_x0[0] = 3'b000; // y=000
        next_state_x0[1] = 3'b001; // y=001
        next_state_x0[2] = 3'b010; // y=010
        next_state_x0[3] = 3'b001; // y=011
        next_state_x0[4] = 3'b011; // y=100

        // Initialize next state for x=1
        next_state_x1[0] = 3'b001; // y=000
        next_state_x1[1] = 3'b100; // y=001
        next_state_x1[2] = 3'b001; // y=010
        next_state_x1[3] = 3'b010; // y=011
        next_state_x1[4] = 3'b100; // y=100
    end

    wire [2:0] next_state;

    // Only valid states are 0 to 4, others map to 0 safely
    wire [2:0] y_index = (y <= 3'd4) ? y : 3'd0;

    // Select next_state based on x input
    assign next_state = x ? next_state_x1[y_index] : next_state_x0[y_index];

    // Output z is 1 only for y=011 or y=100
    assign z = (y == 3'b011) || (y == 3'b100);

    // Y0 is LSB of next_state
    assign Y0 = next_state[0];

endmodule