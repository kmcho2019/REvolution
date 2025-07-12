module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extended inputs
wire [7:0] a_ext = {4'b0, mul_a};

// Pipeline Stage 1: Generate and sum first two partial products
reg [7:0] stage1_sum;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_sum <= 8'b0;
    end else begin
        stage1_sum <= (mul_b[0] ? a_ext : 8'b0) + 
                     (mul_b[1] ? (a_ext << 1) : 8'b0);
    end
end

// Pipeline Stage 2: Sum remaining partial products and final result
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out <= 8'b0;
    end else begin
        mul_out <= stage1_sum + 
                  (mul_b[2] ? (a_ext << 2) : 8'b0) + 
                  (mul_b[3] ? (a_ext << 3) : 8'b0);
    end
end

endmodule