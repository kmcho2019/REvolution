module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_out_reg;

// Input Control and Registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1;
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_en_out_reg <= 0;
    end
end

// Partial Product Generation
wire [15:0] temp [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin : gen_partial_products
        assign temp[i] = (mul_a_reg << i) & (1 << i) ? {8'b0, mul_a_reg} : 16'b0;
    end
endgenerate

// Partial Sum Calculation
reg [15:0] sum [7:0];
always @(posedge clk) begin
    sum[0] <= temp[0];
    for (i = 1; i < 8; i++) begin
        sum[i] <= sum[i-1] + temp[i];
    end
end

// Final Product Calculation
reg [15:0] mul_out_reg;
always @(posedge clk) begin
    mul_out_reg <= sum[7];
end

// Output Assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_en_out ? mul_out_reg : 16'b0;

endmodule