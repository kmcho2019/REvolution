module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

// Extended multiplicand
wire [7:0] ext_a = {4'b0, mul_a};

// Pipeline register
reg [7:0] stage1_reg;

// First stage: sum of first two partial products
wire [7:0] sum_stage1 = (mul_b[0] ? ext_a : 8'b0) + 
                        (mul_b[1] ? (ext_a << 1) : 8'b0);

// Second stage: sum of remaining partial products
wire [7:0] sum_stage2 = stage1_reg + 
                        (mul_b[2] ? (ext_a << 2) : 8'b0) + 
                        (mul_b[3] ? (ext_a << 3) : 8'b0);

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'b0;
        mul_out <= 8'b0;
    end else begin
        stage1_reg <= sum_stage1;
        mul_out <= sum_stage2;
    end
end

endmodule