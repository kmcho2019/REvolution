module multi_pipe_8bit (
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
wire [15:0] temp [7:0];
reg [15:0] sum [7:0];
reg [15:0] mul_out_reg;

// Input Control
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_en_out_reg <= 0;
    end else begin
        mul_en_out_reg <= mul_en_in;
    end
end

// Output enable signal
assign mul_en_out = mul_en_out_reg;

// Input Registers
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_a_reg <= 0;
        mul_b_reg <= 0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
    end
end

// Partial Product Generation
integer i;
always @(*) begin
    for (i = 0; i < 8; i++) begin
        if (mul_b_reg[i])
            temp[i] = {8'b0, mul_a_reg} << i;
        else
            temp[i] = 16'b0;
    end
end

// Partial Sum Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        for (i = 0; i < 8; i++) begin
            sum[i] <= 0;
        end
    end else if (mul_en_in) begin
        sum[0] <= temp[0];
        for (i = 1; i < 8; i++) begin
            sum[i] <= sum[i - 1] + temp[i];
        end
    end
end

// Final Product Calculation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        mul_out_reg <= 0;
    end else if (mul_en_in) begin
        mul_out_reg <= sum[7];
    end
end

// Output Assignment
assign mul_out = (mul_en_out) ? mul_out_reg : 16'b0;

endmodule