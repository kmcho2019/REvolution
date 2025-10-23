module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    input dir,  // 0 for right rotation, 1 for left rotation
    output [7:0] out
);
    // Right rotation stages
    wire [7:0] right_stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    wire [7:0] right_stage2 = ctrl[1] ? {right_stage1[5:0], right_stage1[7:6]} : right_stage1;
    wire [7:0] right_out = ctrl[0] ? {right_stage2[6:0], right_stage2[7]} : right_stage2;
    
    // Left rotation stages
    wire [7:0] left_stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    wire [7:0] left_stage2 = ctrl[1] ? {left_stage1[1:0], left_stage1[7:2]} : left_stage1;
    wire [7:0] left_out = ctrl[0] ? {left_stage2[0], left_stage2[7:1]} : left_stage2;
    
    // Select direction
    assign out = dir ? left_out : right_out;
endmodule