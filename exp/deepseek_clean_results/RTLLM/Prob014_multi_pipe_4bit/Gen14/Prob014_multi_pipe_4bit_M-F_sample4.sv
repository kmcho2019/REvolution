module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

reg [2*size-1:0] accum_stage1, accum_stage2;
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

// Hardwired shifted versions of extended multiplicand
wire [2*size-1:0] ext_a_shift1 = {ext_a[2*size-2:0], 1'b0};
wire [2*size-1:0] ext_a_shift2 = {ext_a[2*size-3:0], 2'b0};
wire [2*size-1:0] ext_a_shift3 = {ext_a[2*size-4:0], 3'b0};

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        accum_stage1 <= 0;
        accum_stage2 <= 0;
        mul_out <= 0;
    end else begin
        // Stage 1: bits 0 and 1 (using AND gates instead of conditional)
        accum_stage1 <= ({2*size{mul_b[0]}} & ext_a) + 
                       ({2*size{mul_b[1]}} & ext_a_shift1);
        
        // Stage 2: bits 2 and 3 with accumulation
        accum_stage2 <= accum_stage1 + 
                       ({2*size{mul_b[2]}} & ext_a_shift2) + 
                       ({2*size{mul_b[3]}} & ext_a_shift3);
        
        mul_out <= accum_stage2;
    end
end

endmodule