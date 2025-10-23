module multi_pipe_8bit(
    input clk,
    input rst_n,
    input mul_en_in,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output mul_en_out,
    output [15:0] mul_out
);

reg [0:0] mul_en_out_reg;
reg [7:0] mul_a_reg;
reg [7:0] mul_b_reg;
wire [15:0] temp;
reg [15:0] sum;
reg [15:0] mul_out_reg;

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

// Output Enable Signal
assign mul_en_out = mul_en_out_reg[0];

// Input Registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
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
assign temp = (mul_a_reg * mul_b_reg);

// Partial Sum Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        sum <= 16'd0;
    end else if (mul_en_in) begin
        sum <= temp;
    end else begin
        sum <= sum;
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 16'd0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum;
    end else begin
        mul_out_reg <= mul_out_reg;
    end
end

// Output Assignment
assign mul_out = (mul_en_out) ? mul_out_reg : 16'd0;

endmodule