module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Rotate left by 4 bits if ctrl[2] is set
    wire [7:0] stage0 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Rotate left by 2 bits if ctrl[1] is set
    wire [7:0] stage1 = ctrl[1] ? {stage0[5:0], stage0[7:6]} : stage0;

    // Rotate left by 1 bit if ctrl[0] is set
    wire [7:0] stage2 = ctrl[0] ? {stage1[6:0], stage1[7]} : stage1;

    assign out = stage2;

endmodule