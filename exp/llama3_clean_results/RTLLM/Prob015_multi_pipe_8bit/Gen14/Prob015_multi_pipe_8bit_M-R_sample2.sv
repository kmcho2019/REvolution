// multi_pipe_8bit_refactored.v
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
reg mul_en_out_reg;
reg [15:0] mul_out_reg;

// Input Buffering
always @ (posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        mul_a_reg <= 8'd0;
        mul_b_reg <= 8'd0;
        mul_en_out_reg <= 1'b0;
    end else if (mul_en_in) begin
        mul_a_reg <= mul_a;
        mul_b_reg <= mul_b;
        mul_en_out_reg <= 1'b1;
    end
end

// Partial Product Generation and Partial Sum Calculation
reg [15:0] partial_sum_reg;
always @ (posedge clk) begin
    if (mul_en_out_reg) begin
        partial_sum_reg <= 16'd0;
        for (int i = 0; i < 8; i++) begin
            if (mul_b_reg[i] == 1'b1) begin
                partial_sum_reg <= partial_sum_reg + ({8'd0, mul_a_reg} << i);
            end
        end
    end
end

// Final Product Calculation
always @ (posedge clk) begin
    if (mul_en_out_reg) begin
        mul_out_reg <= partial_sum_reg;
    end
end

// Output
assign mul_en_out = mul_en_out_reg;
assign mul_out = (mul_en_out_reg) ? mul_out_reg : 16'd0;

endmodule