module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Level 1: Compute all possible 1-bit rotations
    wire [7:0] rot1 = {in[0], in[7:1]};
    
    // Level 2: Compute 2-bit rotations using level 1 results
    wire [7:0] rot2_0 = in;
    wire [7:0] rot2_1 = {rot1[1:0], rot1[7:2]};
    
    // Level 3: Compute 4-bit rotations using level 2 results
    wire [7:0] rot4_0 = ctrl[1] ? rot2_1 : rot2_0;
    wire [7:0] rot4_1 = {rot4_0[3:0], rot4_0[7:4]};
    
    // Final selection
    wire [7:0] pre_out = ctrl[2] ? rot4_1 : rot4_0;
    assign out = ctrl[0] ? {pre_out[0], pre_out[7:1]} : pre_out;
endmodule