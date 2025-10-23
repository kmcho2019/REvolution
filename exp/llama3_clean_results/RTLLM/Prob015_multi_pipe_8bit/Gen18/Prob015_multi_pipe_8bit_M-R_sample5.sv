module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

// Input Stage
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_reg <= 1'b1;
    end
end

// Partial Product Generation Stage
wire [15:0] partial_product [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign partial_product[i] = (mul_b_reg[i] == 1'b1) ? ({8'b0, mul_a_reg} << i) : 16'b0;
    end
endgenerate

// Partial Sum Calculation Stage
reg [15:0] sum_reg [7:0];
integer j;
always @(posedge clk) begin
    sum_reg[0] <= partial_product[0];
    for (j = 1; j < 8; j++) begin
        sum_reg[j] <= sum_reg[j-1] + partial_product[j];
    end
end

// Final Product Calculation Stage
reg [15:0] final_product;
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        final_product <= 16'b0;
    end else if (mul_en_reg) begin
        final_product <= sum_reg[7];
    end
end

// Output Stage
assign mul_en_out = mul_en_reg;
assign mul_out = (mul_en_out) ? final_product : 16'b0;

endmodule