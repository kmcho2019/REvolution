module multi_pipe_4bit #(parameter size = 4) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Registered pipeline stages
reg [2*size-1:0] stage1_reg, stage2_reg;

// Extended multiplicand with zero padding
wire [2*size-1:0] ext_a = { {size{1'b0}}, mul_a };

// Generate shifted versions of extended multiplicand
wire [2*size-1:0] ext_a_shift1 = ext_a << 1;
wire [2*size-1:0] ext_a_shift2 = ext_a << 2;
wire [2*size-1:0] ext_a_shift3 = ext_a << 3;

// Partial products (gated by multiplier bits)
wire [2*size-1:0] pp0 = mul_b[0] ? ext_a : 0;
wire [2*size-1:0] pp1 = mul_b[1] ? ext_a_shift1 : 0;
wire [2*size-1:0] pp2 = mul_b[2] ? ext_a_shift2 : 0;
wire [2*size-1:0] pp3 = mul_b[3] ? ext_a_shift3 : 0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        stage1_reg <= 0;
        stage2_reg <= 0;
        mul_out <= 0;
    end else begin
        // First pipeline stage: process bits 0 and 1
        stage1_reg <= pp0 + pp1;
        
        // Second pipeline stage: process bits 2 and 3 and accumulate
        stage2_reg <= stage1_reg + pp2 + pp3;
        
        // Final output
        mul_out <= stage2_reg;
    end
end

endmodule