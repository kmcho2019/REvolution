module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] mul_out_reg;
wire [15:0] temp;

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= {1'b1, 7'b0};
    end else begin
        mul_en_out_reg <= {mul_en_out_reg[6:0], 1'b0};
    end
end

assign mul_en_out = mul_en_out_reg[7];

// Input Registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
wire [15:0] temp0, temp1, temp2, temp3, temp4, temp5, temp6, temp7;
assign temp0 = (mul_b[0]) ? {8'b0, mul_a_reg} : 16'b0;
assign temp1 = (mul_b[1]) ? {7'b0, mul_a_reg, 1'b0} : 16'b0;
assign temp2 = (mul_b[2]) ? {6'b0, mul_a_reg, 2'b0} : 16'b0;
assign temp3 = (mul_b[3]) ? {5'b0, mul_a_reg, 3'b0} : 16'b0;
assign temp4 = (mul_b[4]) ? {4'b0, mul_a_reg, 4'b0} : 16'b0;
assign temp5 = (mul_b[5]) ? {3'b0, mul_a_reg, 5'b0} : 16'b0;
assign temp6 = (mul_b[6]) ? {2'b0, mul_a_reg, 6'b0} : 16'b0;
assign temp7 = (mul_b[7]) ? {1'b0, mul_a_reg, 7'b0} : 16'b0;

assign temp = temp0 + temp1 + temp2 + temp3 + temp4 + temp5 + temp6 + temp7;

// Partial Sum Calculation
reg [15:0] sum;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 0;
    end else if (mul_en_in) begin
        sum <= temp;
    end else begin
        sum <= sum;
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_out_reg <= 0;
    end else begin
        mul_out_reg <= sum;
    end
end

// Output Assignment
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out <= 0;
    end else if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 0;
    end
end

endmodule