module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Right rotation implementation
    wire [7:0] stage1, stage2, stage3;

    // Stage 1: 4-bit right rotation if ctrl[2] is set
    assign stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Stage 2: 2-bit right rotation if ctrl[1] is set
    assign stage2 = ctrl[1] ? {stage1[1:0], stage1[7:2]} : stage1;

    // Stage 3: 1-bit right rotation if ctrl[0] is set
    assign stage3 = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;

    // Final output
    assign out = stage3;
endmodule