module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output [7:0] out
);
    wire [7:0] stage4, stage2;
    
    // Stage 1: 4-bit shift (controlled by ctrl[2])
    assign stage4 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Stage 2: 2-bit shift (controlled by ctrl[1])
    assign stage2 = ctrl[1] ? {stage4[5:0], stage4[7:6]} : stage4;
    
    // Stage 3: 1-bit shift (controlled by ctrl[0])
    assign out = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;
endmodule