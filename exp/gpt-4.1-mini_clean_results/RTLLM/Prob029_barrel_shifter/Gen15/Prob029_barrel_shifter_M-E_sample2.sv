module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Rotate left by 4 bits
    wire [7:0] rot4 = {in[3:0], in[7:4]};
    wire [7:0] stage1 = ctrl[2] ? rot4 : in;

    // Rotate left by 2 bits
    wire [7:0] rot2 = {stage1[5:0], stage1[7:6]};
    wire [7:0] stage2 = ctrl[1] ? rot2 : stage1;

    // Rotate left by 1 bit
    wire [7:0] rot1 = {stage2[6:0], stage2[7]};
    assign out = ctrl[0] ? rot1 : stage2;

endmodule