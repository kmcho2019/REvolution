module barrel_shifter (
    input  wire [7:0] in,
    input  wire [2:0] ctrl,
    output wire [7:0] out
);
    // Stage 1: shift right by 4 if ctrl[2] is set
    wire [7:0] stage1;
    assign stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;

    // Stage 2: shift right by 2 if ctrl[1] is set
    wire [7:0] stage2;
    assign stage2 = ctrl[1] ? {stage1[1:0], stage1[7:2]} : stage1;

    // Stage 3: shift right by 1 if ctrl[0] is set
    assign out = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;

endmodule