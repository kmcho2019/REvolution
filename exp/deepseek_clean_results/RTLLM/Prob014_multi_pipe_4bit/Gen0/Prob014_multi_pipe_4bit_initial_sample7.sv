module multi_pipe_4bit (
    input clk,
    input rst_n,
    input [3:0] mul_a,
    input [3:0] mul_b,
    output reg [7:0] mul_out
);

parameter size = 4;

// Extended inputs (8-bit with 4 zeros at MSB)
wire [7:0] a_ext = {4'b0, mul_a};
wire [7:0] b_ext = {4'b0, mul_b};

// Partial products
wire [7:0] pp [0:3];
genvar i;
generate
    for (i = 0; i < size; i = i + 1) begin : PARTIAL_PRODUCTS
        assign pp[i] = b_ext[i] ? (a_ext << i) : 8'd0;
    end
endgenerate

// Pipeline registers
reg [7:0] stage1_reg;
reg [7:0] stage2_reg;

// First pipeline stage: sum of pp[0] and pp[1]
wire [7:0] stage1_sum = pp[0] + pp[1];

// Second pipeline stage: sum of pp[2] and pp[3]
wire [7:0] stage2_sum = pp[2] + pp[3];

// Final sum
wire [7:0] final_sum = stage1_reg + stage2_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1_reg <= 8'd0;
        stage2_reg <= 8'd0;
        mul_out <= 8'd0;
    end else begin
        stage1_reg <= stage1_sum;
        stage2_reg <= stage2_sum;
        mul_out <= final_sum;
    end
end

endmodule