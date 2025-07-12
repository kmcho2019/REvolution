module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: rotate left by 4 bits if ctrl[2] is set
    wire [7:0] stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Stage 2: rotate left by 2 bits if ctrl[1] is set
    wire [7:0] stage2 = ctrl[1] ? {stage1[5:0], stage1[7:6]} : stage1;

    // Stage 3: rotate left by 1 bit if ctrl[0] is set
    assign out = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;

endmodule