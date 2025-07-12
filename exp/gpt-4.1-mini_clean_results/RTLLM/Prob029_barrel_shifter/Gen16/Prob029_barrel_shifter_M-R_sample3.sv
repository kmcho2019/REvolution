module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Rotate left by 4 bits
    wire [7:0] rot4 = {in[3:0], in[7:4]};
    // Select between original and rotated by 4 based on ctrl[2]
    wire [7:0] stage1 = (ctrl[2]) ? rot4 : in;

    // Rotate left by 2 bits (applied on stage1)
    wire [7:0] rot2 = {stage1[5:0], stage1[7:6]};
    // Select between stage1 and rotated by 2 based on ctrl[1]
    wire [7:0] stage2 = (ctrl[1]) ? rot2 : stage1;

    // Rotate left by 1 bit (applied on stage2)
    wire [7:0] rot1 = {stage2[6:0], stage2[7]};
    // Select between stage2 and rotated by 1 based on ctrl[0]
    assign out = (ctrl[0]) ? rot1 : stage2;

endmodule