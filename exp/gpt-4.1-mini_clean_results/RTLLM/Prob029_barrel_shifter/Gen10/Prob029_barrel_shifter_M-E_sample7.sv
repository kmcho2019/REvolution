module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: rotate by 4 bits if ctrl[2] == 1
    wire [7:0] stage1_rotated = {in[3:0], in[7:4]};
    wire [7:0] stage1 = ctrl[2] ? stage1_rotated : in;

    // Stage 2: rotate by 2 bits if ctrl[1] == 1
    wire [7:0] stage2_rotated = {stage1[1:0], stage1[7:2]};
    wire [7:0] stage2 = ctrl[1] ? stage2_rotated : stage1;

    // Stage 3: rotate by 1 bit if ctrl[0] == 1
    wire [7:0] stage3_rotated = {stage2[0], stage2[7:1]};
    assign out = ctrl[0] ? stage3_rotated : stage2;

endmodule