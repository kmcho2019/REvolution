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
reg [7:0] mul_en_out_reg;
reg [15:0] sum;
reg [15:0] mul_out_reg;

wire [15:0] temp;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_out_reg <= 8'd0;
        sum <= 16'd0;
        mul_out_reg <= 16'd0;
    end else begin
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            mul_en_out_reg <= {7'd0, mul_en_in};
        end
        sum <= sum + (mul_a_reg * {8'd0, mul_b_reg[0]}) + 
               (mul_a_reg * {7'd0, mul_b_reg[1], 1'd0}) + 
               (mul_a_reg * {6'd0, mul_b_reg[2], 2'd0}) + 
               (mul_a_reg * {5'd0, mul_b_reg[3], 3'd0}) + 
               (mul_a_reg * {4'd0, mul_b_reg[4], 4'd0}) + 
               (mul_a_reg * {3'd0, mul_b_reg[5], 5'd0}) + 
               (mul_a_reg * {2'd0, mul_b_reg[6], 6'd0}) + 
               (mul_a_reg * {1'd0, mul_b_reg[7], 7'd0});
        mul_out_reg <= sum;
    end
end

assign mul_en_out = mul_en_out_reg[7];
assign mul_out = mul_en_out ? mul_out_reg : 16'd0;

endmodule