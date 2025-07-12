module multi_pipe_8bit (
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

// Partial product generation
wire [15:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
assign temp0 = (mul_b[0] == 1'b1) ? {8'd0, mul_a} : 16'd0;
assign temp1 = (mul_b[1] == 1'b1) ? {7'd0, mul_a, 1'b0} : 16'd0;
assign temp2 = (mul_b[2] == 1'b1) ? {6'd0, mul_a, 2'd0} : 16'd0;
assign temp3 = (mul_b[3] == 1'b1) ? {5'd0, mul_a, 3'd0} : 16'd0;
assign temp4 = (mul_b[4] == 1'b1) ? {4'd0, mul_a, 4'd0} : 16'd0;
assign temp5 = (mul_b[5] == 1'b1) ? {3'd0, mul_a, 5'd0} : 16'd0;
assign temp6 = (mul_b[6] == 1'b1) ? {2'd0, mul_a, 6'd0} : 16'd0;
assign temp7 = (mul_b[7] == 1'b1) ? {1'd0, mul_a, 7'd0} : 16'd0;

// Partial sum calculation
reg [15:0] sum0, sum1, sum2, sum3;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum0 <= 16'd0;
        sum1 <= 16'd0;
        sum2 <= 16'd0;
        sum3 <= 16'd0;
    end else if (mul_en_in) begin
        sum0 <= temp0 + temp1;
        sum1 <= temp2 + temp3;
        sum2 <= temp4 + temp5;
        sum3 <= temp6 + temp7;
    end else begin
        sum0 <= 16'd0;
        sum1 <= 16'd0;
        sum2 <= 16'd0;
        sum3 <= 16'd0;
    end
end

// Final product calculation
reg [15:0] mul_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'd0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum0 + sum1 + sum2 + sum3;
    end else begin
        mul_out_reg <= 16'd0;
    end
end

// Input control and output assignment
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else begin
        mul_en_out_reg <= mul_en_in;
    end
end

assign mul_en_out = mul_en_out_reg;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 16'd0;
    end else if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'd0;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end
end

endmodule