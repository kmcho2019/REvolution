module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    wire [7:0] stage1, stage2;
    
    // Stage 1: 4-bit shift if ctrl[2] is set
    assign stage1 = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Stage 2: 2-bit shift if ctrl[1] is set
    assign stage2 = ctrl[1] ? {stage1[5:0], stage1[7:6]} : stage1;
    
    // Stage 3: 1-bit shift if ctrl[0] is set
    always @(*) begin
        out = ctrl[0] ? {stage2[6:0], stage2[7]} : stage2;
    end
endmodule