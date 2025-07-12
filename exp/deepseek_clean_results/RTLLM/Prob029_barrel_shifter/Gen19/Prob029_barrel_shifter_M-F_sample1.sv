module barrel_shifter(
    input [7:0] in,        // 8-bit input
    input [2:0] ctrl,      // Control: [2]=4-bit, [1]=2-bit, [0]=1-bit
    output [7:0] out       // Rotated output (right rotation)
);

    // Intermediate results after each shift stage
    wire [7:0] stage1, stage2;

    // First stage: 4-bit right rotation if ctrl[2] is set
    assign stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Second stage: 2-bit right rotation if ctrl[1] is set
    assign stage2 = ctrl[1] ? {stage1[1:0], stage1[7:2]} : stage1;

    // Final stage: 1-bit right rotation if ctrl[0] is set
    assign out = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;

endmodule