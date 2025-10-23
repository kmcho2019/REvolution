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
reg mul_en_out_reg;

// Input Buffering and Partial Product Generation
always @(posedge clk) begin
    if (!rst_n) begin
        mul_a_reg <= 8'b0;
        mul_b_reg <= 8'b0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end else begin
        mul_en_out_reg <= 1'b0;
    end
end

// Partial Sum Calculation and Final Product Calculation
reg [15:0] partial_sum;
always @(posedge clk) begin
    if (!rst_n) begin
        partial_sum <= 16'b0;
    end else if (mul_en_out_reg) begin
        reg [15:0] temp_sum;
        temp_sum = 16'b0;
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i])
                temp_sum = temp_sum + ({8'b0, mul_a_reg} << i);
        end
        partial_sum <= temp_sum;
    end
end

// Output assignment
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg) ? partial_sum : 16'b0;

endmodule