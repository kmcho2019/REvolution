module TopModule (
    input  [31:0] in,
    output [31:0] out
);
    // Shift-register style byte reversal
    wire [31:0] stage0, stage1, stage2, stage3;
    
    // Stage 0: Extract byte 0 (LSB)
    assign stage0 = {in[7:0], 24'b0};
    
    // Stage 1: Extract byte 1 and combine
    assign stage1 = {in[15:8], 16'b0} | (stage0 >> 8);
    
    // Stage 2: Extract byte 2 and combine
    assign stage2 = {in[23:16], 8'b0} | (stage1 >> 8);
    
    // Stage 3: Extract byte 3 (MSB) and combine
    assign stage3 = in[31:24] | (stage2 >> 8);
    
    assign out = stage3;
endmodule