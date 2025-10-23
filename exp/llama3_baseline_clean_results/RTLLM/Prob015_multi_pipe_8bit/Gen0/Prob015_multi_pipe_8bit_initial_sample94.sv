module multi_pipe_8bit (
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
reg [15:0] mul_out_reg;
wire [15:0] temp;

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 8'd0;
    end else begin
        mul_en_out_reg <= {mul_en_in, mul_en_out_reg[7:1]};
    end
end

assign mul_en_out = mul_en_out_reg[7];

// Input Registers
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
assign temp = (mul_b_reg[7]? mul_a_reg : 8'd0) << 7 |
              (mul_b_reg[6]? mul_a_reg : 8'd0) << 6 |
              (mul_b_reg[5]? mul_a_reg : 8'd0) << 5 |
              (mul_b_reg[4]? mul_a_reg : 8'd0) << 4 |
              (mul_b_reg[3]? mul_a_reg : 8'd0) << 3 |
              (mul_b_reg[2]? mul_a_reg : 8'd0) << 2 |
              (mul_b_reg[1]? mul_a_reg : 8'd0) << 1 |
              (mul_b_reg[0]? mul_a_reg : 8'd0) << 0;

// Partial Sum Calculation
reg [15:0] sum;
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        sum <= 16'd0;
    end else if (mul_en_in) begin
        sum <= temp;
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_out_reg <= 16'd0;
    end else begin
        mul_out_reg <= sum;
    end
end

// Output Assignment
assign mul_out = (mul_en_out)? mul_out_reg : 16'd0;

endmodule