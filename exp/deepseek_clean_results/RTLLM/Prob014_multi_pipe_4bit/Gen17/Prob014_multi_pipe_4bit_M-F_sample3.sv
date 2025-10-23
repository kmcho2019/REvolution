module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Extended multiplicand
wire [2*size-1:0] ext_a = {{size{1'b0}}, mul_a};

// Pipeline registers
reg [2*size-1:0] stage1_reg;
reg [2*size-1:0] stage2_reg;

// Partial products
wire [2*size-1:0] pp0 = mul_b[0] ? ext_a : 0;
wire [2*size-1:0] pp1 = mul_b[1] ? ext_a << 1 : 0;
wire [2*size-1:0] pp2 = mul_b[2] ? ext_a << 2 : 0;
wire [2*size-1:0] pp3 = mul_b[3] ? ext_a << 3 : 0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all registers
        stage1_reg <= 0;
        stage2_reg <= 0;
        mul_out <= 0;
    end else begin
        // First pipeline stage: bits 0-1
        stage1_reg <= pp0 + pp1;
        
        // Second pipeline stage: bits 2-3 + previous result
        stage2_reg <= stage1_reg + pp2 + pp3;
        
        // Final output
        mul_out <= stage2_reg;
    end
end

endmodule