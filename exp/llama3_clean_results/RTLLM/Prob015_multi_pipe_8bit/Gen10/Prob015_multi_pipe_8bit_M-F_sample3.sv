module multi_pipe_8bit(
    input wire clk,
    input wire rst_n,
    input wire mul_en_in,
    input wire [7:0] mul_a,
    input wire [7:0] mul_b,
    output wire mul_en_out,
    output wire [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
reg mul_en_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_out_reg <= 16'b0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

reg [15:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
always @(posedge clk) begin
    if (mul_en_out_reg) begin
        temp0 <= (mul_b_reg[0]) ? mul_a_reg : 16'b0;
        temp1 <= (mul_b_reg[1]) ? (mul_a_reg << 1) : 16'b0;
        temp2 <= (mul_b_reg[2]) ? (mul_a_reg << 2) : 16'b0;
        temp3 <= (mul_b_reg[3]) ? (mul_a_reg << 3) : 16'b0;
        temp4 <= (mul_b_reg[4]) ? (mul_a_reg << 4) : 16'b0;
        temp5 <= (mul_b_reg[5]) ? (mul_a_reg << 5) : 16'b0;
        temp6 <= (mul_b_reg[6]) ? (mul_a_reg << 6) : 16'b0;
        temp7 <= (mul_b_reg[7]) ? (mul_a_reg << 7) : 16'b0;
    end else begin
        temp0 <= 16'b0;
        temp1 <= 16'b0;
        temp2 <= 16'b0;
        temp3 <= 16'b0;
        temp4 <= 16'b0;
        temp5 <= 16'b0;
        temp6 <= 16'b0;
        temp7 <= 16'b0;
    end
end

reg [15:0] sum0, sum1, sum2, sum3;
always @(posedge clk) begin
    if (mul_en_out_reg) begin
        sum0 <= temp0 + temp1;
        sum1 <= temp2 + temp3;
        sum2 <= temp4 + temp5;
        sum3 <= temp6 + temp7;
    end else begin
        sum0 <= 16'b0;
        sum1 <= 16'b0;
        sum2 <= 16'b0;
        sum3 <= 16'b0;
    end
end

reg [15:0] sum4, sum5;
always @(posedge clk) begin
    if (mul_en_out_reg) begin
        sum4 <= sum0 + sum1;
        sum5 <= sum2 + sum3;
    end else begin
        sum4 <= 16'b0;
        sum5 <= 16'b0;
    end
end

always @(posedge clk) begin
    if (mul_en_out_reg) begin
        mul_out_reg <= sum4 + sum5;
    end else begin
        mul_out_reg <= 16'b0;
    end
end

assign mul_en_out = mul_en_out_reg;
assign mul_out = mul_en_out_reg ? mul_out_reg : 16'b0;

endmodule