module barrel_shifter(
    input [7:0] in,        // 8-bit input
    input [2:0] ctrl,      // Control: [2]=4-bit, [1]=2-bit, [0]=1-bit
    output [7:0] out       // Rotated output (left rotation)
);

    // Intermediate results after each shift stage
    wire [7:0] stage1, stage2;

    // First stage: 4-bit shift if ctrl[2] is set
    assign stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Second stage: 2-bit shift if ctrl[1] is set (applied to stage1 result)
    assign stage2 = ctrl[1] ? {stage1[1:0], stage1[7:2]} : stage1;

    // Final stage: 1-bit shift if ctrl[0] is set (applied to stage2 result)
    assign out = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;

endmodule