// multi_pipe_8bit.v
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

// Generate partial products and sum them
wire [15:0] sum;
assign sum = (mul_b_reg[0]? {8'd0, mul_a_reg} : 16'd0) +
             (mul_b_reg[1]? {8'd0, mul_a_reg} << 1 : 16'd0) +
             (mul_b_reg[2]? {8'd0, mul_a_reg} << 2 : 16'd0) +
             (mul_b_reg[3]? {8'd0, mul_a_reg} << 3 : 16'd0) +
             (mul_b_reg[4]? {8'd0, mul_a_reg} << 4 : 16'd0) +
             (mul_b_reg[5]? {8'd0, mul_a_reg} << 5 : 16'd0) +
             (mul_b_reg[6]? {8'd0, mul_a_reg} << 6 : 16'd0) +
             (mul_b_reg[7]? {8'd0, mul_a_reg} << 7 : 16'd0);

// Output stage
always @ (posedge clk) begin
    if (mul_en_out_reg) begin
        mul_out_reg <= sum;
    end else begin
        mul_out_reg <= 16'd0;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_out_reg;

endmodule