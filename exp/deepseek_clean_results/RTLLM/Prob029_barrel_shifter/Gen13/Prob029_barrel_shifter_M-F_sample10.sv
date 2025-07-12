module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage1, stage2;
    
    // First stage: 4-bit rotation
    assign stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Second stage: 2-bit rotation
    assign stage2 = ctrl[1] ? {stage1[1:0], stage1[7:2]} : stage1;
    
    // Third stage: 1-bit rotation
    assign out = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;
endmodule