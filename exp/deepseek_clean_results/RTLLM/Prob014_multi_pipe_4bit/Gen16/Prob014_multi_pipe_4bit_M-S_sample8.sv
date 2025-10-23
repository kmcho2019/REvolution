module multi_pipe_4bit #(
    parameter size = 4
) (
    input clk,
    input rst_n,
    input [size-1:0] mul_a,
    input [size-1:0] mul_b,
    output reg [2*size-1:0] mul_out
);

// Pipeline registers
reg [2*size-1:0] stage1_sum;
reg [2*size-1:0] stage2_sum;

// First pipeline stage: bits 0-1
wire [2*size-1:0] pp0 = mul_b[0] ? {{size{1'b0}}, mul_a} : 0;
wire [2*size-1:0] pp1 = mul_b[1] ? {{size-1{1'b0}}, mul_a, 1'b0} : 0;

// Second pipeline stage: bits 2-3
wire [2*size-1:0] pp2 = mul_b[2] ? {{size-2{1'b0}}, mul_a, 2'b0} : 0;
wire [2*size-1:0] pp3 = mul_b[3] ? {{size-3{1'b0}}, mul_a, 3'b0} : 0;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= 0;
        stage2_sum <= 0;
        mul_out <= 0;
    end else begin
        // First pipeline stage
        stage1_sum <= pp0 + pp1;
        
        // Second pipeline stage
        stage2_sum <= stage1_sum + pp2 + pp3;
        
        // Final output
        mul_out <= stage2_sum;
    end
end

endmodule