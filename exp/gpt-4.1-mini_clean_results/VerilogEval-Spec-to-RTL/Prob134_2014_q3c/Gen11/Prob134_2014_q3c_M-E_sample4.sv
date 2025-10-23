module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // Next state vectors for x=0 and x=1 indexed by y
    wire [2:0] next_state_x0 [0:4];
    wire [2:0] next_state_x1 [0:4];

    assign next_state_x0[0] = 3'b000; // y=000
    assign next_state_x0[1] = 3'b001; // y=001
    assign next_state_x0[2] = 3'b010; // y=010
    assign next_state_x0[3] = 3'b001; // y=011
    assign next_state_x0[4] = 3'b011; // y=100

    assign next_state_x1[0] = 3'b001; // y=000
    assign next_state_x1[1] = 3'b100; // y=001
    assign next_state_x1[2] = 3'b001; // y=010
    assign next_state_x1[3] = 3'b010; // y=011
    assign next_state_x1[4] = 3'b100; // y=100

    // Determine if y is in the defined state range (0 to 4)
    wire y_valid = (y <= 3'b100);

    // Select next state based on x and y
    wire [2:0] next_state = y_valid ? (x ? next_state_x1[y] : next_state_x0[y]) : 3'b000;

    // Output logic z derived directly from state and input x:
    // z=1 for (y=011 or y=100) regardless of x; otherwise 0.
    wire z_out = (y == 3'b011) || (y == 3'b100);

    assign Y0 = next_state[0];
    assign z = z_out;

endmodule