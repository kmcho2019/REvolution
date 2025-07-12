module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Generate all possible shifted versions in parallel
    wire [7:0] shifted_1 = {in[6:0], in[7]};    // Rotate right by 1
    wire [7:0] shifted_2 = {in[5:0], in[7:6]};  // Rotate right by 2
    wire [7:0] shifted_4 = {in[3:0], in[7:4]};  // Rotate right by 4
    
    // Level 1 selection (ctrl[0] - shift by 1)
    wire [7:0] level1_out = ctrl[0] ? shifted_1 : in;
    
    // Level 2 selection (ctrl[1] - shift by 2)
    wire [7:0] shifted_level1_2 = {level1_out[5:0], level1_out[7:6]};
    wire [7:0] level2_out = ctrl[1] ? shifted_level1_2 : level1_out;
    
    // Level 3 selection (ctrl[2] - shift by 4)
    wire [7:0] shifted_level2_4 = {level2_out[3:0], level2_out[7:4]};
    assign out = ctrl[2] ? shifted_level2_4 : level2_out;
endmodule