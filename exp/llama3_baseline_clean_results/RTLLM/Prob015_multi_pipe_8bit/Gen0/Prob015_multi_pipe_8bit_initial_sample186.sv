module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output reg [15:0] mul_out
);

reg [7:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
reg [15:0] sum_reg;
reg [15:0] mul_out_reg;

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_en_out_reg <= 8'd0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= mul_en_in;
    end else begin
        mul_en_out_reg <= mul_en_out_reg >> 1;
    end
end

assign mul_en_out = mul_en_out_reg[7];

// Input Registers
always @(posedge clk) begin
    if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
wire [15:0] temp [7:0];
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign temp[i] = (mul_b_reg[i] == 1'b1) ? (mul_a_reg << i) : 16'd0;
    end
endgenerate

// Partial Sum Calculation
wire [15:0] sum;
assign sum = temp[0] + temp[1] + temp[2] + temp[3] + temp[4] + temp[5] + temp[6] + temp[7];

// Final Product Calculation
always @(posedge clk) begin
    if (mul_en_in) begin
        mul_out_reg <= sum;
    end else if (mul_en_out_reg[7]) begin
        mul_out_reg <= mul_out_reg;
    end else begin
        mul_out_reg <= 16'd0;
    end
end

// Output Assignment
always @(posedge clk) begin
    if (mul_en_out) begin
        mul_out <= mul_out_reg;
    end else begin
        mul_out <= 16'd0;
    end
end

endmodule