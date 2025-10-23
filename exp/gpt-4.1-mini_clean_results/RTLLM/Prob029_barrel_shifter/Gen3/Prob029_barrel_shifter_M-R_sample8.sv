module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);

    // Stage 1: shift by 4 if ctrl[2] is set
    wire [7:0] stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Stage 2: shift by 2 if ctrl[1] is set
    wire [7:0] stage2 = ctrl[1] ? {stage1[5:0], stage1[7:6]} : stage1;

    // Stage 3: shift by 1 if ctrl[0] is set
    wire [7:0] stage3 = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;

    assign out = stage3;

endmodule