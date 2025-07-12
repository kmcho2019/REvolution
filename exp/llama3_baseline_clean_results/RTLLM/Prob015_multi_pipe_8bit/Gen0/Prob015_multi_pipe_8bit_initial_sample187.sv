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
reg [15:0] mul_out_reg;

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1;
    end else begin
        mul_en_out_reg <= 0;
    end
end

// Input Registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end else begin
        mul_a_reg <= mul_a_reg;
        mul_b_reg <= mul_b_reg;
    end
end

// Partial Product Generation
wire [15:0] temp [7:0];
integer i;
always @(*) begin
    for (i = 0; i < 8; i = i + 1) begin
        if (mul_b_reg[i]) begin
            temp[i] = mul_a_reg << i;
        end else begin
            temp[i] = 16'd0;
        end
    end
end

// Partial Sum Calculation
reg [15:0] sum [7:0];
integer j;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        for (j = 0; j < 8; j = j + 1) begin
            sum[j] <= 16'd0;
        end
    end else begin
        sum[0] <= temp[0];
        for (j = 1; j < 8; j = j + 1) begin
            sum[j] <= sum[j-1] + temp[j];
        end
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'd0;
    end else begin
        mul_out_reg <= sum[7];
    end
end

// Output Assignment
always @(*) begin
    if (mul_en_out_reg) begin
        mul_en_out <= 1;
        mul_out <= mul_out_reg;
    end else begin
        mul_en_out <= 0;
        mul_out <= 16'd0;
    end
end

endmodule