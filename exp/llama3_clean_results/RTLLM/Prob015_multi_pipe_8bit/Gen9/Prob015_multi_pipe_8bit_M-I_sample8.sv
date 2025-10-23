// Improved multi_pipe_8bit.v
module multi_pipe_8bit (
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
reg [15:0] mul_out_reg;

// Input registers
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
        mul_en_out_reg <= 1'b0;
    end
end

// Generate partial products
wire [15:0] partial_products [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin: partial_product_gen
        assign partial_products[i] = (mul_b_reg[i] == 1'b1) ? ({8'd0, mul_a_reg} << i) : 16'd0;
    end
endgenerate

// Wallace tree adder
wire [15:0] sum1, sum2, sum3, sum4, sum5, sum6, sum7;
assign sum1 = partial_products[0] + partial_products[1];
assign sum2 = partial_products[2] + partial_products[3];
assign sum3 = partial_products[4] + partial_products[5];
assign sum4 = partial_products[6] + partial_products[7];
assign sum5 = sum1 + sum2;
assign sum6 = sum3 + sum4;
assign sum7 = sum5 + sum6;

// Output stage
always @ (posedge clk) begin
    if (mul_en_out_reg) begin
        mul_out_reg <= sum7;
    end else begin
        mul_out_reg <= 16'd0;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_out_reg;

// Clock gating
reg clk_gated;
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        clk_gated <= 1'b0;
    end else if (mul_en_in) begin
        clk_gated <= 1'b1;
    end else begin
        clk_gated <= 1'b0;
    end
end

// Shared adder resources
reg [15:0] shared_adder_out;
always @ (posedge clk_gated) begin
    shared_adder_out <= sum7;
end

// Final output
assign mul_out = shared_adder_out;

endmodule