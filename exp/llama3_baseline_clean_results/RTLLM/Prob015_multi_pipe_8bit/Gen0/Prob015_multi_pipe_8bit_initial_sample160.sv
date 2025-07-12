module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;

wire [15:0] temp;

assign mul_en_out = mul_en_out_reg[0];

always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_out_reg <= 16'd0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {1'b1};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_en_out_reg <= {1'b0};
    end
end

assign temp = (mul_b_reg[0] ? {8'd0, mul_a_reg} : 16'd0) +
              (mul_b_reg[1] ? {7'd0, mul_a_reg, 1'd0} : 16'd0) +
              (mul_b_reg[2] ? {6'd0, mul_a_reg, 2'd0} : 16'd0) +
              (mul_b_reg[3] ? {5'd0, mul_a_reg, 3'd0} : 16'd0) +
              (mul_b_reg[4] ? {4'd0, mul_a_reg, 4'd0} : 16'd0) +
              (mul_b_reg[5] ? {3'd0, mul_a_reg, 5'd0} : 16'd0) +
              (mul_b_reg[6] ? {2'd0, mul_a_reg, 6'd0} : 16'd0) +
              (mul_b_reg[7] ? {1'd0, mul_a_reg, 7'd0} : 16'd0);

always @ (posedge clk) begin
    if (mul_en_in) begin
        mul_out_reg <= temp;
    end else begin
        mul_out_reg <= 16'd0;
    end
end

assign mul_out = (mul_en_out) ? mul_out_reg : 16'd0;

endmodule