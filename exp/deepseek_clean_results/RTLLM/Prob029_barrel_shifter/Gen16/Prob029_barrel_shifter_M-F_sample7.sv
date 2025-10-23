module barrel_shifter(
    input [7:0] in,        // 8-bit input
    input [2:0] ctrl,      // Control: [2]=4-bit, [1]=2-bit, [0]=1-bit
    output [7:0] out       // Rotated output
);

    // Stage 1: 4-bit shift
    wire [7:0] stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Stage 2: 2-bit shift
    wire [7:0] stage2 = ctrl[1] ? {stage1[1:0], stage1[7:2]} : stage1;
    
    // Stage 3: 1-bit shift
    assign out = ctrl[0] ? {stage2[0], stage2[7:1]} : stage2;

endmodule