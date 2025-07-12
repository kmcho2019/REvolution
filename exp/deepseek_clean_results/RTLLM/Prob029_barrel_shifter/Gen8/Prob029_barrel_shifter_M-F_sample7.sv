module barrel_shifter(
    input [7:0] in,
    input [2:0] ctrl,
    output reg [7:0] out
);
    // Intermediate results after each shift stage
    wire [7:0] stage1_out;
    wire [7:0] stage2_out;
    
    // Stage 1: 4-bit shift (controlled by ctrl[2])
    assign stage1_out = ctrl[2] ? {in[3:0], in[7:4]} : in;
    
    // Stage 2: 2-bit shift (controlled by ctrl[1])
    assign stage2_out = ctrl[1] ? {stage1_out[5:0], stage1_out[7:6]} : stage1_out;
    
    // Stage 3: 1-bit shift (controlled by ctrl[0])
    always @(*) begin
        out = ctrl[0] ? {stage2_out[6:0], stage2_out[7]} : stage2_out;
    end
endmodule