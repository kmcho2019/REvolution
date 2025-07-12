module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // LUT for x=0 case: {next_state[2:0], z}
    wire [3:0] lut_x0 [0:4];
    assign lut_x0[0] = 4'b0000; // state 000
    assign lut_x0[1] = 4'b0010; // state 001
    assign lut_x0[2] = 4'b0100; // state 010
    assign lut_x0[3] = 4'b0010; // state 011
    assign lut_x0[4] = 4'b0111; // state 100

    // LUT for x=1 case: {next_state[2:0], z}
    wire [3:0] lut_x1 [0:4];
    assign lut_x1[0] = 4'b0010; // state 000
    assign lut_x1[1] = 4'b1000; // state 001
    assign lut_x1[2] = 4'b0010; // state 010
    assign lut_x1[3] = 4'b0101; // state 011
    assign lut_x1[4] = 4'b1001; // state 100

    // State index conversion (maps y[2:0] to 0-4)
    wire [2:0] state_index;
    assign state_index = (y == 3'b000) ? 3'd0 :
                         (y == 3'b001) ? 3'd1 :
                         (y == 3'b010) ? 3'd2 :
                         (y == 3'b011) ? 3'd3 :
                         (y == 3'b100) ? 3'd4 : 3'd0;

    // Select between LUTs based on x
    wire [3:0] lut_out;
    assign lut_out = x ? lut_x1[state_index] : lut_x0[state_index];

    // Output assignments
    assign Y0 = lut_out[0]; // Next state's LSB
    assign z = lut_out[3];  // z output

endmodule