module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

// Input Control
reg mul_en_out_reg;
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end
assign mul_en_out = mul_en_out_reg;

// Input Registers
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial Product Generation
wire [15:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
assign temp0 = (mul_b_reg[0] == 1'b1) ? {8'b0, mul_a_reg} : 16'b0;
assign temp1 = (mul_b_reg[1] == 1'b1) ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
assign temp2 = (mul_b_reg[2] == 1'b1) ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
assign temp3 = (mul_b_reg[3] == 1'b1) ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
assign temp4 = (mul_b_reg[4] == 1'b1) ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
assign temp5 = (mul_b_reg[5] == 1'b1) ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
assign temp6 = (mul_b_reg[6] == 1'b1) ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
assign temp7 = (mul_b_reg[7] == 1'b1) ? {1'b0, mul_a_reg, 7'b0} : 16'b0;

// Partial Sum Calculation
reg [15:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6;
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum0 <= 16'b0;
        sum1 <= 16'b0;
        sum2 <= 16'b0;
        sum3 <= 16'b0;
        sum4 <= 16'b0;
        sum5 <= 16'b0;
        sum6 <= 16'b0;
    end else if (mul_en_in) begin
        sum0 <= temp0;
        sum1 <= temp1 + temp0;
        sum2 <= temp2 + sum1;
        sum3 <= temp3 + sum2;
        sum4 <= temp4 + sum3;
        sum5 <= temp5 + sum4;
        sum6 <= temp6 + sum5;
    end else begin
        sum0 <= sum0;
        sum1 <= sum1;
        sum2 <= sum2;
        sum3 <= sum3;
        sum4 <= sum4;
        sum5 <= sum5;
        sum6 <= sum6;
    end
end

// Final Product Calculation
reg [15:0] mul_out_reg;
always @ (posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum6 + temp7;
    end else begin
        mul_out_reg <= mul_out_reg;
    end
end

// Output Assignment
assign mul_out = (mul_en_out) ? mul_out_reg : 16'b0;

endmodule