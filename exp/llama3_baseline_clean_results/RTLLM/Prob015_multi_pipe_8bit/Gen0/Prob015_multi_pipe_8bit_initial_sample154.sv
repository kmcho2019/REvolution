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

wire [15:0] temp;
wire [15:0] sum;

assign mul_en_out = mul_en_out_reg[7];

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out_reg <= 8'b0;
        mul_out <= 16'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= {7'b0, mul_en_in};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
    end
end

assign temp = (mul_a_reg * mul_b_reg);
assign sum = temp;

always @(posedge clk) begin
    if (mul_en_out_reg[7]) begin
        mul_out <= sum;
    end else begin
        mul_out <= 16'b0;
    end
end

endmodule