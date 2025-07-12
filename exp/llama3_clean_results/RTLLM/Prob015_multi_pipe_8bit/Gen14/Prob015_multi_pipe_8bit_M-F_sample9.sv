module multi_pipe_8bit(
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
reg [15:0] mul_out_reg;
reg mul_en_out_reg;
reg [2:0] counter;

// Input Buffering
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out_reg <= 1'b0;
        counter <= 3'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
        counter <= 3'b0;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Partial Product Generation and Sum Calculation
reg [15:0] partial_sum;
always @(posedge clk) begin
    if (!rst_n) begin
        partial_sum <= 16'b0;
    end else if (mul_en_in) begin
        partial_sum <= 16'b0;
    end else if (counter < 3'b111) begin
        partial_sum <= partial_sum + ({8'b0, mul_a_reg} << counter);
        counter <= counter + 1;
    end else begin
        mul_out_reg <= partial_sum;
    end
end

// Final Product Calculation and Output
always @(posedge clk) begin
    if (!rst_n) begin
        mul_out_reg <= 16'b0;
    end else if (counter == 3'b111) begin
        mul_out_reg <= partial_sum;
    end
end

// Output assignment
assign mul_en_out = (counter == 3'b111) && mul_en_out_reg;
assign mul_out = mul_out_reg;

endmodule