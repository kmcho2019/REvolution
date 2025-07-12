module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;

// Partial product generation
wire [15:0] pp0, pp1, pp2, pp3, pp4, pp5, pp6, pp7;

// Partial sum calculation
reg [15:0] sum0, sum1, sum2, sum3, sum4, sum5, sum6;

// Final product calculation
reg [15:0] mul_out_reg;

// Input control and input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
        mul_a_reg <= 0;
        mul_b_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {mul_en_in, 7'b0};
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial product generation
assign pp0 = (mul_b_reg[0] == 1'b1) ? {8'b0, mul_a_reg} : 16'b0;
assign pp1 = (mul_b_reg[1] == 1'b1) ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
assign pp2 = (mul_b_reg[2] == 1'b1) ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
assign pp3 = (mul_b_reg[3] == 1'b1) ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
assign pp4 = (mul_b_reg[4] == 1'b1) ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
assign pp5 = (mul_b_reg[5] == 1'b1) ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
assign pp6 = (mul_b_reg[6] == 1'b1) ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
assign pp7 = (mul_b_reg[7] == 1'b1) ? {1'b0, mul_a_reg, 7'b0} : 16'b0;

// Partial sum calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum0 <= 0;
        sum1 <= 0;
        sum2 <= 0;
        sum3 <= 0;
        sum4 <= 0;
        sum5 <= 0;
        sum6 <= 0;
    end else begin
        sum0 <= pp0 + pp1;
        sum1 <= pp2 + pp3;
        sum2 <= pp4 + pp5;
        sum3 <= pp6 + pp7;
        sum4 <= sum0 + sum1;
        sum5 <= sum2 + sum3;
        sum6 <= sum4 + sum5;
    end
end

// Final product calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 0;
    end else begin
        mul_out_reg <= sum6;
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out <= 0;
        mul_out <= 0;
    end else begin
        mul_en_out <= mul_en_out_reg[7];
        if (mul_en_out) begin
            mul_out <= mul_out_reg;
        end else begin
            mul_out <= 0;
        end
    end
end

endmodule