module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    // Stage 1: Shift by 4 if ctrl[2] is set
    wire [7:0] stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Stage 2: Shift by 2 if ctrl[1] is set (operates on stage1 result)
    wire [7:0] stage2 = ctrl[1] ? {stage1[5:0], stage1[7:6]} : stage1;
    
    // Stage 3: Shift by 1 if ctrl[0] is set (operates on stage2 result)
    assign out = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;
endmodule