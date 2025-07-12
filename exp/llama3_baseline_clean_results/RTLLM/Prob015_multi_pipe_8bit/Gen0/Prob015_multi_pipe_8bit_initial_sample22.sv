module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg; // Register to store the output enable signal
reg [7:0] mul_a_reg; // Register to store the multiplicand
reg [7:0] mul_b_reg; // Register to store the multiplier
reg [15:0] mul_out_reg; // Register to store the final product
wire [15:0] temp [7:0]; // Wires to store partial products
reg [15:0] sum [7:0]; // Registers to store partial sums

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Input Registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
genvar i;
generate
    for (i = 0; i < 8; i++) begin
        assign temp[i] = (mul_b_reg[i] == 1'b1) ? {8'b0, mul_a_reg} : 16'b0;
    end
endgenerate

// Partial Sum Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (int i = 0; i < 8; i++) begin
            sum[i] <= 16'b0;
        end
    end else begin
        sum[0] <= temp[0];
        for (int i = 1; i < 8; i++) begin
            sum[i] <= sum[i-1] + temp[i];
        end
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else begin
        mul_out_reg <= sum[7];
    end
end

// Output Assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out) ? mul_out_reg : 16'b0;

endmodule