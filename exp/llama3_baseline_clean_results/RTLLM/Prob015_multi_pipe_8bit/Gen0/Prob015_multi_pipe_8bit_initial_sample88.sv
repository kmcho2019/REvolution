module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output reg mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg mul_en_out_reg;

// Input control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
    end else begin
        mul_en_out_reg <= mul_en_in;
    end
end

assign mul_en_out = mul_en_out_reg;

// Input registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial product generation
wire [15:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;

assign temp0 = {8'd0, mul_a_reg} * (1'b1 << 0);
assign temp1 = {8'd0, mul_a_reg} * (1'b1 << 1);
assign temp2 = {8'd0, mul_a_reg} * (1'b1 << 2);
assign temp3 = {8'd0, mul_a_reg} * (1'b1 << 3);
assign temp4 = {8'd0, mul_a_reg} * (1'b1 << 4);
assign temp5 = {8'd0, mul_a_reg} * (1'b1 << 5);
assign temp6 = {8'd0, mul_a_reg} * (1'b1 << 6);
assign temp7 = {8'd0, mul_a_reg} * (1'b1 << 7);

// Partial sum calculation
reg [15:0] sum0, sum1, sum2, sum3;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum0 <= 16'd0;
        sum1 <= 16'd0;
        sum2 <= 16'd0;
        sum3 <= 16'd0;
    end else if (mul_en_in) begin
        sum0 <= (mul_b_reg[0] ? temp0 : 16'd0) + (mul_b_reg[1] ? temp1 : 16'd0);
        sum1 <= (mul_b_reg[2] ? temp2 : 16'd0) + (mul_b_reg[3] ? temp3 : 16'd0);
        sum2 <= (mul_b_reg[4] ? temp4 : 16'd0) + (mul_b_reg[5] ? temp5 : 16'd0);
        sum3 <= (mul_b_reg[6] ? temp6 : 16'd0) + (mul_b_reg[7] ? temp7 : 16'd0);
    end
end

// Final product calculation
reg [15:0] mul_out_reg;

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'd0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum0 + sum1 + sum2 + sum3;
    end
end

// Output assignment
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 16'd0;
    end else if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'd0;
    end
end

endmodule