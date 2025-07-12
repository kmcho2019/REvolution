module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] accum_stage1, accum_stage2;
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accum_stage1 <= 0;
        accum_stage2 <= 0;
        mul_out <= 0;
    end else begin
        // Stage 1: bits 0 and 1
        accum_stage1 <= (mul_b[0] ? ext_a : 0) + 
                       (mul_b[1] ? ext_a << 1 : 0);
        
        // Stage 2: bits 2 and 3 with accumulation
        accum_stage2 <= accum_stage1 + 
                       (mul_b[2] ? ext_a << 2 : 0) + 
                       (mul_b[3] ? ext_a << 3 : 0);
        
        mul_out <= accum_stage2;
    end
end

endmodule