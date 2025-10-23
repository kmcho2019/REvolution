module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extended inputs
wire [7:0] ext_a = {4'b0, mul_a};
wire [7:0] ext_b = {4'b0, mul_b};

// Partial products
wire [7:0] pp0 = ext_b[0] ? ext_a : 8'b0;
wire [7:0] pp1 = ext_b[1] ? (ext_a << 1) : 8'b0;
wire [7:0] pp2 = ext_b[2] ? (ext_a << 2) : 8'b0;
wire [7:0] pp3 = ext_b[3] ? (ext_a << 3) : 8'b0;

// Pipeline stage 1 registers (even bits)
reg [7:0] stage1_pp0, stage1_pp2;
reg [7:0] stage1_sum;

// Pipeline stage 2 registers (odd bits)
reg [7:0] stage2_pp1, stage2_pp3;
reg [7:0] stage2_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        // Reset all pipeline registers
        stage1_pp0 <= 8'b0;
        stage1_pp2 <= 8'b0;
        stage1_sum <= 8'b0;
        stage2_pp1 <= 8'b0;
        stage2_pp3 <= 8'b0;
        stage2_sum <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        // First pipeline stage - register even bits
        stage1_pp0 <= pp0;
        stage1_pp2 <= pp2;
        stage1_sum <= stage1_pp0 + stage1_pp2;
        
        // Second pipeline stage - register odd bits and accumulate
        stage2_pp1 <= pp1;
        stage2_pp3 <= pp3;
        stage2_sum <= stage1_sum + stage2_pp1 + stage2_pp3;
        
        // Final output
        mul_out <= stage2_sum;
    end
end

endmodule