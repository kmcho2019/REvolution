module TopModule (
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

    // LUT for next state [Y2,Y1,Y0] and output z
    // Format: {Y2,Y1,Y0,z} for x=0, {Y2,Y1,Y0,z} for x=1
    parameter [7:0] STATE_LUT [0:4] = '{
        8'b000_0_001_0,  // State 000
        8'b001_0_100_0,  // State 001
        8'b010_0_001_0,  // State 010
        8'b001_1_010_1,  // State 011
        8'b011_1_100_1   // State 100
    };

    wire [3:0] lut_output = STATE_LUT[y];
    wire [2:0] next_state = x ? lut_output[3:1] : lut_output[7:5];
    wire next_z = x ? lut_output[0] : lut_output[4];

    assign Y0 = next_state[0];
    assign z = next_z;

endmodule