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
wire [15:0] sum;

assign mul_en_out = mul_en_out_reg[0];

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_out_reg <= 16'd0;
    end else begin
        mul_en_out_reg <= {mul_en_in};
        if (mul_en_in) begin
            mul_a_reg <= mul_a;
            mul_b_reg <= mul_b;
        end else begin
            mul_a_reg <= mul_a_reg;
            mul_b_reg <= mul_b_reg;
        end
        // generate partial products
        temp[0] = (mul_b[0] == 1'b1) ? {8'd0, mul_a_reg[7:0]} : 16'd0;
        temp[1] = (mul_b[1] == 1'b1) ? {8'd0, mul_a_reg[7:0], 1'b0} : 16'd0;
        temp[2] = (mul_b[2] == 1'b1) ? {8'd0, mul_a_reg[7:0], 2'b00} : 16'd0;
        temp[3] = (mul_b[3] == 1'b1) ? {8'd0, mul_a_reg[7:0], 3'b000} : 16'd0;
        temp[4] = (mul_b[4] == 1'b1) ? {8'd0, mul_a_reg[7:0], 4'b0000} : 16'd0;
        temp[5] = (mul_b[5] == 1'b1) ? {8'd0, mul_a_reg[7:0], 5'b00000} : 16'd0;
        temp[6] = (mul_b[6] == 1'b1) ? {8'd0, mul_a_reg[7:0], 6'b000000} : 16'd0;
        temp[7] = (mul_b[7] == 1'b1) ? {8'd0, mul_a_reg[7:0], 7'b0000000} : 16'd0;
        // calculate partial sums
        sum = temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];
        mul_out_reg <= sum;
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