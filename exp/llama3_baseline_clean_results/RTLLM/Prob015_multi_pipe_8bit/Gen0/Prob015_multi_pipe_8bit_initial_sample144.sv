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
wire [15:0] temp;
reg [15:0] sum_reg;
reg [15:0] mul_out_reg;

assign mul_en_out = mul_en_out_reg[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        sum_reg <= 16'd0;
        mul_out_reg <= 16'd0;
    end else begin
        if (mul_en_in) begin
            mul_en_out_reg <= 1'b1;
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
            sum_reg <= 16'd0;
            mul_out_reg <= 16'd0;
        end else begin
            mul_en_out_reg <= 1'b0;
        end
    end
end

always @(posedge clk) begin
    if (mul_en_out_reg[0]) begin
        temp[0] <= (mul_b_reg[0]) ? mul_a_reg : 8'd0;
        temp[1] <= (mul_b_reg[1]) ? {mul_a_reg, 1'd0} : 9'd0;
        temp[2] <= (mul_b_reg[2]) ? {mul_a_reg, 2'd0} : 10'd0;
        temp[3] <= (mul_b_reg[3]) ? {mul_a_reg, 3'd0} : 11'd0;
        temp[4] <= (mul_b_reg[4]) ? {mul_a_reg, 4'd0} : 12'd0;
        temp[5] <= (mul_b_reg[5]) ? {mul_a_reg, 5'd0} : 13'd0;
        temp[6] <= (mul_b_reg[6]) ? {mul_a_reg, 6'd0} : 14'd0;
        temp[7] <= (mul_b_reg[7]) ? {mul_a_reg, 7'd0} : 15'd0;
        
        sum_reg <= temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
        mul_out_reg <= sum_reg;
    end
end

always @(posedge clk) begin
    if (mul_en_out_reg[0]) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'd0;
    end
end

endmodule